<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Listing;
use App\Models\ListingDetail;
use App\Models\ListingMedia;
use App\Services\ListingMetricsService;
use App\Services\ListingQueryService;
use App\Support\CompactCountFormatter;
use App\Support\ListingFormDataNormalizer;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;
use Symfony\Component\HttpKernel\Exception\HttpExceptionInterface;

class ListingController extends Controller
{
    public function __construct(
        private ListingQueryService $listingQuery,
        private ListingMetricsService $metricsService,
        private ListingFormDataNormalizer $formDataNormalizer
    ) {
    }

    /**
     * Home feed + filters.
     */
    public function index(Request $request)
    {
        return $this->paginatedListings(
            $request,
            true,
            false,
            $this->requestHasListingFilters($request)
        );
    }

    /**
     * Search listings (same filters + pagination as index).
     */
    public function search(Request $request)
    {
        return $this->paginatedListings(
            $request,
            true,
            true,
            $this->requestHasListingFilters($request)
        );
    }

    private function paginatedListings(
        Request $request,
        bool $activeOnly,
        bool $withEmptySearchMessage = false,
        bool $withEmptyFilterMessage = false
    )
    {
        $appliedFilters = $this->listingQuery->resolveListingFiltersFromRequest($request);

        $query = $this->listingQuery->baseListingQuery($request, $activeOnly);
        $this->listingQuery->applyFiltersArray($query, $appliedFilters);
        $query->orderByDesc('created_at');

        $requestedPage = max(1, (int) $request->query('page', 1));
        $paginator = $query->paginate(20, ['*'], 'page', $requestedPage);
        if (count($paginator->items()) === 0 && $requestedPage > 1 && $paginator->lastPage() > 0) {
            $paginator = $query->paginate(20, ['*'], 'page', $paginator->lastPage());
        }

        $this->listingQuery->transformPaginatorCollection($paginator, $request->user());

        $payload = [
            'listings' => $paginator->items(),
            'applied_filters' => $appliedFilters,
            'pagination' => [
                'current_page' => $paginator->currentPage(),
                'last_page' => $paginator->lastPage(),
                'per_page' => $paginator->perPage(),
                'total' => $paginator->total(),
                'from' => $paginator->firstItem(),
                'to' => $paginator->lastItem(),
                'has_more_pages' => $paginator->hasMorePages(),
            ],
        ];

        if ($paginator->total() === 0) {
            $searchTerm = trim((string) (
                $request->query('keyword')
                ?? $request->query('q')
                ?? $request->query('search')
                ?? ''
            ));

            if ($withEmptySearchMessage && $searchTerm !== '') {
                $payload['message'] = 'No listings found matching your search.';
            } elseif ($withEmptyFilterMessage || ($withEmptySearchMessage && $this->requestHasListingFilters($request))) {
                $payload['message'] = 'No listings found for the selected filters.';
            } elseif ($withEmptySearchMessage) {
                $payload['message'] = 'No listings found.';
            } elseif ($withEmptyFilterMessage) {
                $payload['message'] = 'No listings found for the selected filters.';
            }
        }

        return response()->json($payload);
    }

    private function requestHasListingFilters(Request $request): bool
    {
        return $this->listingQuery->resolveListingFiltersFromRequest($request) !== [];
    }

    /**
     * Add-post screen: optional fields the client may send on create (GET /listings/add-post).
     */
    public function addPostForm()
    {
        return response()->json([
            'notes' => null,
            'additional_notes' => null,
        ]);
    }

    /**
     * Listing detail.
     */
    public function show(Request $request, Listing $listing)
    {
        $listingId = $listing->id;

        $listingForView = $this->listingQuery->baseListingQuery($request, false)
            ->whereKey($listingId)
            ->firstOrFail();

        $viewer = $request->user();
        if ($viewer && $viewer->id !== $listingForView->created_by) {
            $this->metricsService->recordFromUser(
                $listingForView,
                $viewer->id,
                \App\Models\ListingMetricEvent::METRIC_VIEW
            );
        }

        $listing = $this->listingQuery->baseListingQuery($request, false)
            ->whereKey($listingId)
            ->firstOrFail();

        $this->listingQuery->transformListingForResponse($listing, $request->user());

        return response()->json($listing);
    }

    /**
     * Create listing or requirement (manual form).
     */
    public function store(Request $request)
    {
        try {
            $user = $request->user();
            $profileCompletionPercent = (int) ($user->profile_completion_percent ?? 0);

            if ($profileCompletionPercent !== 100) {
                return response()->json([
                    'message' => 'Complete your profile to 100% before posting.',
                    'profile_completion' => $profileCompletionPercent . '%',
                ], 403);
            }

            $payloads = $this->resolveIncomingPostPayloads($request);
            $payloadFiles = $this->resolveIncomingPostFiles($request);
            $topLevelFormData = $this->parseFormDataField(
                $request->input('form-data', $request->input('form_data', $request->input('formData')))
            );
            $rules = $this->listingStoreValidationRules();

            $createdListings = [];
            foreach ($payloads as $index => $payload) {
                if (!empty($payloadFiles[$index])) {
                    $payload = array_merge($payload, $payloadFiles[$index]);
                }

                $data = Validator::make($payload, $rules)->validate();

                $itemFormData = [];
                if (array_key_exists('form-data', $payload)) {
                    $itemFormData = $this->parseFormDataField($payload['form-data']);
                } elseif (array_key_exists('form_data', $payload)) {
                    $itemFormData = $this->parseFormDataField($payload['form_data']);
                } elseif (array_key_exists('formData', $payload)) {
                    $itemFormData = $this->parseFormDataField($payload['formData']);
                } elseif (array_is_list($topLevelFormData) && isset($topLevelFormData[$index])) {
                    $itemFormData = $this->parseFormDataField($topLevelFormData[$index]);
                } elseif (!array_is_list($topLevelFormData)) {
                    $itemFormData = $topLevelFormData;
                }

                if (!empty($itemFormData)) {
                    $data = $this->applyFormDataToListingPayload($data, $itemFormData);
                }

                $this->stripBlankOptionalNotes($data, $itemFormData);

                $createdListings[] = $this->createListingFromPayload(
                    $request,
                    $user->id,
                    $data,
                    $itemFormData,
                    $index === 0 && count($payloads) === 1,
                    $payloadFiles[$index] ?? []
                );
            }

            if (count($createdListings) === 1) {
                return response()->json([
                    'message' => 'Post created successfully.',
                    'listing_id' => $createdListings[0]->id,
                ], 201);
            }

            return response()->json([
                'message' => 'Posts created successfully.',
                'count' => count($createdListings),
                'listing_ids' => array_map(fn (Listing $listing) => $listing->id, $createdListings),
            ], 201);
        } catch (ValidationException $e) {
            return response()->json([
                'message' => 'Validation failed.',
                'error' => $e->getMessage(),
                'errors' => $e->errors(),
            ], 422);
        } catch (\Throwable $e) {
            return response()->json([
                'message' => 'Failed to create post.',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Get listing data for edit screen.
     */
    public function edit(Request $request, Listing $listing): JsonResponse
    {
        $listing = $this->listingQuery->baseListingQuery($request, false)
            ->whereKey($listing->id)
            ->firstOrFail();

        $this->listingQuery->transformListingForResponse($listing, $request->user());

        return response()->json([
            'message' => 'Listing loaded for edit.',
            'listing' => $listing,
            'metrics' => $this->listingMetricsPayload($listing),
        ]);
    }

    /**
     * Update listing — same body/field names as add-post; only DB columns are written.
     */
    public function update(Request $request, Listing $listing): JsonResponse
    {
        try {
            $listingId = $listing->id;
            $payload = $this->normalizeListingFieldKeysInPayload(
                $this->resolveUpdatePayload($request)
            );
            $this->stripExpiryFieldsFromPayload($payload);
            $this->normalizeListingIntentInPayload($payload);
            $explicitListingIntent = $this->extractExplicitListingIntentFromPayload($payload);

            $formData = $this->normalizeListingFieldKeysInPayload(
                $this->extractFormDataFromPostPayload($payload, $request)
            );
            $this->stripExpiryFieldsFromPayload($formData);
            $this->removeFormDataKeysFromPayload($payload);
            $this->stripNonUploadMediaFromPayload($payload);

            $data = Validator::make($payload, $this->listingUpdateValidationRules())->validate();

            if (!empty($formData)) {
                $data = $this->applyFormDataToListingPayload($data, $formData);
                $this->stripExpiryFieldsFromPayload($data);
            }

            if ($explicitListingIntent !== null) {
                // posts[0][kind] / status must win over stale values inside form-data JSON.
                $data['kind'] = $explicitListingIntent;
                $formData['kind'] = $explicitListingIntent;
                unset($formData['status']);
            } else {
                $resolvedKind = $this->resolveKindForListingUpdate($data, $formData);
                if ($resolvedKind !== null) {
                    $data['kind'] = $resolvedKind;
                    $formData['kind'] = $resolvedKind;
                }
            }

            $this->stripBlankOptionalNotes($data, $formData);

            $this->applyUpdateToListing($listing, $data, $formData);
            $this->syncListingMediaOnUpdate($listing, $request);

            $listing = $this->listingQuery->baseListingQuery($request, false)
                ->whereKey($listingId)
                ->firstOrFail();

            $this->listingQuery->transformListingForResponse($listing, $request->user());

            return response()->json([
                'message' => 'Listing updated successfully.',
                'listing_id' => $listing->id,
                'listing' => $listing,
            ]);
        } catch (ValidationException $e) {
            return response()->json([
                'message' => 'Validation failed.',
                'error' => $e->getMessage(),
                'errors' => $e->errors(),
            ], 422);
        } catch (HttpExceptionInterface $e) {
            return response()->json([
                'message' => $e->getMessage() ?: 'Request failed.',
            ], $e->getStatusCode());
        } catch (\Throwable $e) {
            return response()->json([
                'message' => 'Failed to update listing.',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Delete listing.
     */
    public function destroy(Request $request, Listing $listing)
    {
        $listing->delete();

        return response()->json([
            'message' => 'Listing deleted.',
        ]);
    }

    /**
     * Mark listing as sold (separate marked_as field; does not change status).
     */
    public function markSold(Request $request, Listing $listing): JsonResponse
    {
        $listing->marked_as = 'sold';
        $listing->save();

        return response()->json([
            'message' => 'Listing marked as sold.',
            'listing_id' => $listing->id,
            'marked_as' => $listing->marked_as,
            'status' => $listing->status,
            'my_listings_totals' => $this->metricsService->dashboardForUser($request->user()->id),
        ]);
    }

    /**
     * Mark listing as rented (separate marked_as field; does not change status).
     */
    public function markRented(Request $request, Listing $listing): JsonResponse
    {
        $listing->marked_as = 'rented';
        $listing->save();

        return response()->json([
            'message' => 'Listing marked as rented.',
            'listing_id' => $listing->id,
            'marked_as' => $listing->marked_as,
            'status' => $listing->status,
            'my_listings_totals' => $this->metricsService->dashboardForUser($request->user()->id),
        ]);
    }

    /**
     * My listings.
     */
    public function myListings(Request $request)
    {
        $user = $request->user();

        $query = $this->listingQuery->baseListingQuery($request, false)
            ->where('created_by', $user->id)
            ->orderByDesc('created_at');

        $paginator = $query->paginate(20);
        $this->listingQuery->transformPaginatorCollection($paginator, $user);

        return $paginator;
    }

    /**
     * Active listings for authenticated user (status active + not expired).
     */
    public function myActiveListings(Request $request): JsonResponse
    {
        return $this->paginatedMyListingsByScope($request, 'active');
    }

    /**
     * Expired, sold, and rented listings for authenticated user.
     */
    public function myInactiveListings(Request $request): JsonResponse
    {
        return $this->paginatedMyListingsByScope($request, 'inactive');
    }

    /**
     * Extend listing expiry by up to 1 month from now/current expiry.
     */
    public function extendExpiry(Request $request, Listing $listing): JsonResponse
    {
        $base = $listing->expires_at instanceof Carbon && $listing->expires_at->isFuture()
            ? $listing->expires_at->copy()
            : Carbon::now();

        $listing->expires_at = $base->addMonth();

        if ($listing->status === 'expired') {
            $listing->status = 'active';
        }

        $clearedMarkedAs = false;
        if (in_array($listing->marked_as, ['sold', 'rented'], true)) {
            $listing->marked_as = null;
            $clearedMarkedAs = true;
        }

        $listing->save();

        return response()->json([
            'message' => 'Listing expiry extended by 1 month.',
            'listing_id' => $listing->id,
            'expires_at' => $listing->expires_at?->toIso8601String(),
            'post_expiry' => $listing->post_expiry,
            'status' => $listing->status,
            'marked_as' => $listing->marked_as,
            'marked_as_cleared' => $clearedMarkedAs,
        ]);
    }

    private function paginatedMyListingsByScope(Request $request, string $scope): JsonResponse
    {
        $user = $request->user();
        $query = $this->listingQuery->baseListingQuery($request, false)
            ->where('created_by', $user->id);

        if ($scope === 'active') {
            $query->where('status', 'active')
                ->whereNull('marked_as')
                ->where(function ($q) {
                    $q->whereNull('expires_at')
                        ->orWhere('expires_at', '>', Carbon::now());
                });
        } else {
            // Inactive = marked sold/rented OR expired (by date or status).
            $query->where(function ($q) {
                $q->whereIn('marked_as', ['sold', 'rented'])
                    ->orWhere('status', 'expired')
                    ->orWhere(function ($expiredQuery) {
                        $expiredQuery->whereNotNull('expires_at')
                            ->where('expires_at', '<=', Carbon::now());
                    });
            });
        }

        $query->orderByDesc('created_at');

        $requestedPage = max(1, (int) $request->query('page', 1));
        $paginator = $query->paginate(20, ['*'], 'page', $requestedPage);
        if (count($paginator->items()) === 0 && $requestedPage > 1 && $paginator->lastPage() > 0) {
            $paginator = $query->paginate(20, ['*'], 'page', $paginator->lastPage());
        }

        $this->listingQuery->transformPaginatorCollection($paginator, $user);

        $payload = [
            'scope' => $scope,
            'listings' => $paginator->items(),
            'pagination' => [
                'current_page' => $paginator->currentPage(),
                'last_page' => $paginator->lastPage(),
                'per_page' => $paginator->perPage(),
                'total' => $paginator->total(),
                'from' => $paginator->firstItem(),
                'to' => $paginator->lastItem(),
                'has_more_pages' => $paginator->hasMorePages(),
            ],
        ];

        if ($scope === 'inactive') {
            $payload['summary'] = $this->inactiveListingsSummary($user->id);
        }

        return response()->json($payload);
    }

    /**
     * @return array<string, int>
     */
    private function inactiveListingsSummary(int $userId): array
    {
        $base = Listing::query()->where('created_by', $userId);

        $inactiveFilter = function ($q) {
            $q->whereIn('marked_as', ['sold', 'rented'])
                ->orWhere('status', 'expired')
                ->orWhere(function ($expiredQuery) {
                    $expiredQuery->whereNotNull('expires_at')
                        ->where('expires_at', '<=', Carbon::now());
                });
        };

        return [
            'marked_sold' => (clone $base)->where('marked_as', 'sold')->count(),
            'marked_rented' => (clone $base)->where('marked_as', 'rented')->count(),
            'expired' => (clone $base)->where(function ($q) {
                $q->where('status', 'expired')
                    ->orWhere(function ($expiredQuery) {
                        $expiredQuery->whereNotNull('expires_at')
                            ->where('expires_at', '<=', Carbon::now());
                    });
            })->count(),
            'total_inactive' => (clone $base)->where($inactiveFilter)->count(),
        ];
    }

    /**
     * @return array<string, mixed>
     */
    private function listingMetricsPayload(Listing $listing): array
    {
        return $this->metricsService->externalTotalsForListing($listing);
    }

    private function resolveListingType(?string $kind): ?string
    {
        if ($kind === null || trim($kind) === '') {
            return null;
        }

        $normalized = strtolower(trim(str_replace('_', ' ', $kind)));

        return match ($normalized) {
            'sale', 'for sale' => 'sale',
            'rent', 'for rent' => 'rent',
            'required', 'rent request', 'buy request', 'requirement' => 'requirement',
            default => str_contains($normalized, 'rent') ? 'rent'
                : (str_contains($normalized, 'sale') ? 'sale' : 'requirement'),
        };
    }

    private function normalizeTags(array $tags): array
    {
        $normalized = array_values(array_filter(array_map(function ($tag) {
            if (!is_string($tag)) {
                return null;
            }

            $tag = trim($tag);
            return $tag === '' ? null : strtoupper($tag);
        }, $tags)));

        return array_values(array_unique($normalized));
    }

    private function storeUploadedMedia(Request $request, Listing $listing): void
    {
        $groups = [
            'images' => 'image',
            'videos' => 'video',
            'documents' => 'doc',
        ];

        $order = 0;
        foreach ($groups as $field => $type) {
            if (!$request->hasFile($field)) {
                continue;
            }

            foreach ((array) $request->file($field) as $file) {
                if (!$file) {
                    continue;
                }

                $path = $file->store('listing-media', 'public');
                ListingMedia::create([
                    'listing_id' => $listing->id,
                    'type' => $type,
                    'url' => Storage::url($path),
                    'order' => $order++,
                ]);
            }
        }
    }

    /**
     * Treat omitted or whitespace-only notes as not provided (optional field).
     *
     * @param  array<string, mixed>  $data
     * @param  array<string, mixed>  $formData
     */
    private function stripBlankOptionalNotes(array &$data, array &$formData = []): void
    {
        foreach (['notes', 'description'] as $key) {
            if (array_key_exists($key, $data) && $this->isBlankValue($data[$key])) {
                unset($data[$key]);
            }

            if (array_key_exists($key, $formData) && $this->isBlankValue($formData[$key])) {
                unset($formData[$key]);
            }
        }
    }

    private function isBlankValue($value): bool
    {
        return $value === null
            || $value === ''
            || (is_string($value) && trim($value) === '');
    }

    private function parseFormDataField($value): array
    {
        if (is_array($value)) {
            return $value;
        }

        if (!is_string($value) || trim($value) === '') {
            return [];
        }

        $decoded = json_decode($value, true);
        if (json_last_error() === JSON_ERROR_NONE && is_array($decoded)) {
            return $decoded;
        }

        return ['raw' => $value];
    }

    /**
     * Map form-data JSON keys onto listings / listing_details columns when a matching DB column exists.
     *
     * @param  array<string, mixed>  $data
     * @param  array<string, mixed>  $formData
     * @return array<string, mixed>
     */
    private function applyFormDataToListingPayload(array $data, array $formData): array
    {
        $listingCols = $this->listingColumnsWritableFromFormData();
        $detailCols = $this->listingDetailColumnsWritableFromFormData();
        $aliases = $this->formDataFieldAliases();

        foreach ($formData as $rawKey => $value) {
            if ($this->shouldSkipFormDataKey((string) $rawKey)) {
                continue;
            }

            $key = $aliases[$this->normalizeFormDataKey((string) $rawKey)]
                ?? $this->normalizeFormDataKey((string) $rawKey);

            if ($key === 'off_plan' || $key === 'is_off_plan') {
                $data['off_plan'] = $this->normalizeIncomingFieldValue('off_plan', $value);
                continue;
            }

            if ($key === 'post_expiry') {
                $data['expires_at'] = $this->normalizeIncomingFieldValue('expires_at', $value);
                continue;
            }

            if ($key === 'commission_type') {
                $data['commission_type'] = $this->normalizeIncomingFieldValue('commission_type', $value);
                continue;
            }

            if ($key === 'kind') {
                $data['kind'] = $this->normalizeIncomingFieldValue('kind', $value);
                continue;
            }

            // App form often sends listing intent as "Status" (for rent / for sale), not DB lifecycle status.
            if ($key === 'status') {
                if ($this->isValidListingLifecycleStatus($value)) {
                    $data['status'] = strtolower(trim((string) $value));
                } else {
                    $data['kind'] = $this->normalizeIncomingFieldValue('kind', $value);
                }
                continue;
            }

            // price / price-sp resolved together after the loop (price-sp takes priority).
            if ($key === 'price' || $key === 'price_sp') {
                continue;
            }

            if (isset($listingCols[$key])) {
                $data[$key] = $this->normalizeIncomingFieldValue($key, $value);
                continue;
            }

            if (isset($detailCols[$key])) {
                if (!$this->isBlankValue($value) || $key !== 'notes') {
                    $data[$key] = $this->normalizeIncomingFieldValue($key, $value);
                }
            }
        }

        $tags = $data['tags'] ?? null;
        if ($tags === null) {
            foreach ($formData as $rawKey => $value) {
                $normalized = $this->normalizeFormDataKey((string) $rawKey);
                if ($normalized === 'tags' || $normalized === 'tag') {
                    $tags = $value;
                    break;
                }
            }
        }

        if ($tags !== null) {
            if (is_string($tags)) {
                $tags = array_values(array_filter(array_map('trim', explode(',', $tags))));
            }

            if (is_array($tags)) {
                $data['tags'] = $tags;
            }
        }

        if (isset($formData['rooms']) && is_array($formData['rooms'])) {
            if (!array_key_exists('beds', $data) && isset($formData['rooms']['bedrooms'])) {
                $data['beds'] = $formData['rooms']['bedrooms'];
            }
            if (!array_key_exists('baths', $data) && isset($formData['rooms']['bathrooms'])) {
                $data['baths'] = $formData['rooms']['bathrooms'];
            }
        }

        $resolvedPrice = $this->resolveListingPriceFromFormData($formData);
        if ($resolvedPrice !== null) {
            $data['price'] = $resolvedPrice;
        }

        return $data;
    }

    /**
     * Actual listing price: price-sp (or price_sp) when present, otherwise price from form-data.
     *
     * @param  array<string, mixed>  $formData
     */
    private function resolveListingPriceFromFormData(array $formData): ?float
    {
        $priceSp = $this->findFormDataValueByNormalizedKeys($formData, ['price_sp']);
        if ($priceSp !== null && !$this->isBlankValue($priceSp)) {
            return $this->castFormDataPrice($priceSp);
        }

        $price = $this->findFormDataValueByNormalizedKeys($formData, ['price']);
        if ($price === null || $this->isBlankValue($price)) {
            return null;
        }

        return $this->castFormDataPrice($price);
    }

    /**
     * @param  array<string, mixed>  $formData
     * @param  list<string>  $normalizedKeys
     */
    private function findFormDataValueByNormalizedKeys(array $formData, array $normalizedKeys): mixed
    {
        foreach ($formData as $rawKey => $value) {
            if ($this->shouldSkipFormDataKey((string) $rawKey)) {
                continue;
            }

            $key = $this->normalizeFormDataKey((string) $rawKey);
            if (in_array($key, $normalizedKeys, true)) {
                return $value;
            }
        }

        return null;
    }

    private function castFormDataPrice(mixed $value): ?float
    {
        $normalized = $this->normalizeIncomingFieldValue('price', $value);
        if ($normalized === null || $normalized === '') {
            return null;
        }

        return (float) $normalized;
    }

    /**
     * @return array<string, int>
     */
    private function listingColumnsWritableFromFormData(): array
    {
        static $columns = null;

        if ($columns === null) {
            // `status` is post lifecycle (active/expired), not app "Status" (for rent / for sale).
            $exclude = ['created_by', 'views_count', 'clicks_count', 'leads_count', 'saves_count', 'status'];
            $columns = array_flip(array_diff((new Listing())->getFillable(), $exclude));
        }

        return $columns;
    }

    /**
     * @return array<string, int>
     */
    private function listingDetailColumnsWritableFromFormData(): array
    {
        static $columns = null;

        if ($columns === null) {
            $columns = array_flip(array_diff(
                (new ListingDetail())->getFillable(),
                ['listing_id', 'form_data', 'extra']
            ));
        }

        return $columns;
    }

    /**
     * @return array<string, string>
     */
    private function formDataFieldAliases(): array
    {
        return [
            'note' => 'notes',
            'description' => 'notes',
            'tag' => 'tags',
            'title' => 'property_type',
        ];
    }

    private function normalizeFormDataKey(string $key): string
    {
        $key = strtolower(trim($key));

        return str_replace(['-', ' '], '_', $key);
    }

    private function isValidListingLifecycleStatus(mixed $value): bool
    {
        if (!is_string($value)) {
            return false;
        }

        return in_array(strtolower(trim($value)), ['active', 'sold', 'rented', 'expired'], true);
    }

    /**
     * App "Status" (for rent / for sale / buy request) is listing intent, not DB lifecycle status.
     *
     * @param  array<string, mixed>  $payload
     */
    private function normalizeListingIntentInPayload(array &$payload): void
    {
        if (!array_key_exists('status', $payload) || $this->isBlankValue($payload['status'])) {
            return;
        }

        $status = $payload['status'];
        if ($this->isValidListingLifecycleStatus($status)) {
            return;
        }

        if (!array_key_exists('kind', $payload) || $this->isBlankValue($payload['kind'])) {
            $payload['kind'] = $status;
        }

        unset($payload['status']);
    }

    /**
     * Mobile/add-post payloads often send Status/Kind with different casing.
     *
     * @param  array<string, mixed>  $payload
     * @return array<string, mixed>
     */
    private function normalizeListingFieldKeysInPayload(array $payload): array
    {
        $normalized = [];

        foreach ($payload as $key => $value) {
            $canonical = match (strtolower(trim((string) $key))) {
                'status' => 'status',
                'kind' => 'kind',
                default => $key,
            };

            if (!array_key_exists($canonical, $normalized)) {
                $normalized[$canonical] = $value;
                continue;
            }

            if ($this->isBlankValue($normalized[$canonical]) && !$this->isBlankValue($value)) {
                $normalized[$canonical] = $value;
            }
        }

        return $normalized;
    }

    /**
     * Top-level posts[0][kind] or posts[0][status] sent on update (before form-data merge).
     *
     * @param  array<string, mixed>  $payload
     */
    private function extractExplicitListingIntentFromPayload(array $payload): ?string
    {
        if (array_key_exists('kind', $payload) && !$this->isBlankValue($payload['kind'])) {
            return trim((string) $payload['kind']);
        }

        if (array_key_exists('status', $payload)
            && !$this->isBlankValue($payload['status'])
            && !$this->isValidListingLifecycleStatus($payload['status'])) {
            return trim((string) $payload['status']);
        }

        return null;
    }

    /**
     * Resolve listing intent (for sale / for rent / buy request) for listing_details.extra.kind.
     *
     * @param  array<string, mixed>  $data
     * @param  array<string, mixed>  $formData
     */
    private function resolveKindForListingUpdate(array $data, array $formData): ?string
    {
        if (array_key_exists('kind', $data) && !$this->isBlankValue($data['kind'])) {
            return trim((string) $data['kind']);
        }

        foreach (['kind', 'status'] as $key) {
            if (!array_key_exists($key, $formData) || $this->isBlankValue($formData[$key])) {
                continue;
            }

            $value = $formData[$key];
            if ($this->isValidListingLifecycleStatus($value)) {
                continue;
            }

            return trim((string) $value);
        }

        return null;
    }

    private function syncListingIntentTags(Listing $listing, string $kind): void
    {
        $normalized = strtolower(trim(str_replace('_', ' ', $kind)));
        $tags = is_array($listing->tags) ? $listing->tags : [];

        $tags = array_values(array_filter($tags, function ($tag) {
            $upper = strtoupper(str_replace('_', ' ', (string) $tag));

            return !in_array($upper, ['RENT REQUEST', 'BUY REQUEST'], true);
        }));

        if (in_array($normalized, ['rent request', 'buy request'], true)) {
            $tags[] = strtoupper($normalized);
        }

        $listing->tags = $tags;
    }

    private function shouldSkipFormDataKey(string $key): bool
    {
        $normalized = $this->normalizeFormDataKey($key);

        return in_array($normalized, [
            'images',
            'videos',
            'documents',
            'attachments',
            'media',
            'photos',
            'files',
            'image',
            'video',
            'document',
            'rooms',
            'raw',
        ], true);
    }

    private function normalizeIncomingFieldValue(string $field, $value)
    {
        $arrayAllowedFields = ['tags', 'amenities', 'attachments'];
        if (in_array($field, $arrayAllowedFields, true)) {
            return $value;
        }

        if (is_array($value)) {
            if ($field === 'price') {
                if (array_key_exists('sp', $value) && !$this->isBlankValue($value['sp'])) {
                    return $value['sp'];
                }

                return $value['amount'] ?? null;
            }

            if ($field === 'beds') {
                return $value['bedrooms'] ?? $value['beds'] ?? null;
            }

            if ($field === 'baths') {
                return $value['bathrooms'] ?? $value['baths'] ?? null;
            }

            // Multipart form-data often sends scalar values as single-item arrays.
            if (array_is_list($value) && count($value) === 1) {
                return $this->normalizeIncomingFieldValue($field, $value[0]);
            }

            // Key/value structure fallback: [{key: "...", value: "..."}]
            if (isset($value['value'])) {
                return $this->normalizeIncomingFieldValue($field, $value['value']);
            }

            return null;
        }

        if (in_array($field, ['roi', 'commission'], true)) {
            return $this->normalizeDecimalField($value);
        }

        if ($field === 'price' && is_string($value)) {
            $decimal = $this->normalizeDecimalField($value);

            return $decimal ?? $value;
        }

        return $value;
    }

    /**
     * Strip %, commas, spaces — store decimals for DB (e.g. "8.0%" → 8.0).
     */
    private function normalizeDecimalField(mixed $value): ?float
    {
        if ($value === null || $value === '') {
            return null;
        }

        if (is_numeric($value)) {
            return (float) $value;
        }

        if (!is_string($value)) {
            return null;
        }

        $cleaned = preg_replace('/[^0-9.\-]/', '', str_replace(',', '', trim($value)));
        if ($cleaned === '' || $cleaned === '-' || $cleaned === '.') {
            return null;
        }

        return (float) $cleaned;
    }

    private function listingStoreValidationRules(): array
    {
        return [
            'form-data' => 'nullable',
            'form_data' => 'nullable',
            'formData' => 'nullable',
            'listing_type' => 'nullable|in:sale,rent,requirement',
            'kind' => 'nullable|string|max:255',
            'status' => 'nullable|string|max:255',
            'property_type' => 'nullable|string|max:255',
            'title' => 'nullable|string|max:255',
            'price' => 'nullable|numeric',
            'currency' => 'nullable|string|max:10',
            'size' => 'nullable|numeric',
            'beds' => 'nullable|integer|min:0',
            'baths' => 'nullable|integer|min:0',
            'area' => 'nullable|string|max:255',
            'city' => 'nullable|string|max:255',
            'project' => 'nullable|string|max:255',
            'developer' => 'nullable|string|max:255',
            'is_off_plan' => 'boolean',
            'off_plan' => 'required|in:0,1',
            'tags' => 'nullable|array',
            'tags.*' => 'string|max:100',
            'expires_at' => 'nullable|date',
            'post_expiry' => 'nullable|date',
            'description' => 'nullable|string',

            // details
            'payment_plan' => 'nullable|string',
            'ownership' => 'nullable|string|max:255',
            'furnished' => 'nullable|in:furnished,unfurnished,semi',
            'commission' => 'nullable|numeric',
            'commission_type' => 'nullable|in:covered,percentage,fixed,not_disclosed',
            'roi' => 'nullable|numeric',
            'notes' => 'sometimes|nullable|string',
            'additional_notes' => 'sometimes|nullable|string',
            'amenities' => 'nullable|array',
            'amenities.*' => 'string|max:100',

            // media
            'images' => 'nullable|array',
            'images.*' => 'file|mimes:jpg,jpeg,png,webp|max:20480',
            'videos' => 'nullable|array',
            'videos.*' => 'file|mimetypes:video/mp4,video/quicktime,video/x-msvideo,video/x-matroska|max:102400',
            'documents' => 'nullable|array',
            'documents.*' => 'file|mimes:pdf,doc,docx,xls,xlsx,ppt,pptx,txt|max:20480',
        ];
    }

    private function resolveIncomingPostPayloads(Request $request): array
    {
        $posts = $request->input('posts');
        if (is_string($posts)) {
            $decoded = json_decode($posts, true);
            if (json_last_error() === JSON_ERROR_NONE) {
                $posts = $decoded;
            }
        }

        if (is_array($posts) && !empty($posts)) {
            $normalized = $this->normalizePostsInput($posts);
            if (!empty($normalized)) {
                return $normalized;
            }
        }

        $objects = [];
        foreach ($request->all() as $key => $value) {
            if (!preg_match('/^object(\d+)$/i', (string) $key, $match)) {
                continue;
            }

            if (is_string($value)) {
                $decoded = json_decode($value, true);
                if (json_last_error() === JSON_ERROR_NONE) {
                    $value = $decoded;
                }
            }

            if (is_array($value)) {
                $objects[(int) $match[1]] = $value;
            }
        }

        if (!empty($objects)) {
            ksort($objects);

            return array_map(
                fn ($payload) => is_array($payload)
                    ? $this->normalizeListingFieldKeysInPayload($payload)
                    : $payload,
                array_values($objects)
            );
        }

        $bracketStyle = [];
        foreach ($request->all() as $key => $value) {
            if (!preg_match('/^posts\[(\d+)\]\[(.+)\]$/', (string) $key, $match)) {
                continue;
            }

            $index = (int) $match[1];
            $field = $this->normalizePostsBracketFieldName((string) $match[2]);
            if (!array_key_exists($field, $bracketStyle[$index] ?? [])) {
                $bracketStyle[$index][$field] = $value;
                continue;
            }

            $existing = $bracketStyle[$index][$field];
            $bracketStyle[$index][$field] = array_merge(
                (array) $existing,
                (array) $value
            );
        }

        if (!empty($bracketStyle)) {
            ksort($bracketStyle);

            return array_map(
                fn ($payload) => is_array($payload)
                    ? $this->normalizeListingFieldKeysInPayload($payload)
                    : $payload,
                array_values($bracketStyle)
            );
        }

        return [$this->normalizeListingFieldKeysInPayload($request->all())];
    }

    private function normalizePostsBracketFieldName(string $field): string
    {
        if (str_ends_with($field, '][]')) {
            $field = substr($field, 0, -3);
        } elseif (str_ends_with($field, '[]')) {
            $field = substr($field, 0, -2);
        }

        return match (strtolower(trim($field))) {
            'status' => 'status',
            'kind' => 'kind',
            default => $field,
        };
    }

    private function normalizePostsInput(array $posts): array
    {
        // Support numeric-index posts where each item is already an array
        // OR a JSON string object (common in multipart form-data).
        $indexedItems = [];
        foreach ($posts as $key => $value) {
            if (!is_numeric($key)) {
                continue;
            }

            if (is_array($value)) {
                $indexedItems[(int) $key] = $value;
                continue;
            }

            if (is_string($value)) {
                $decoded = json_decode($value, true);
                if (json_last_error() === JSON_ERROR_NONE && is_array($decoded)) {
                    $indexedItems[(int) $key] = $decoded;
                }
            }
        }

        if (!empty($indexedItems)) {
            ksort($indexedItems);

            return array_map(
                fn ($payload) => is_array($payload)
                    ? $this->normalizeListingFieldKeysInPayload($payload)
                    : $payload,
                array_values($indexedItems)
            );
        }

        $allItemsAreArrays = true;
        foreach ($posts as $value) {
            if (!is_array($value)) {
                $allItemsAreArrays = false;
                break;
            }
        }

        if ($allItemsAreArrays) {
            return array_map(
                fn ($payload) => is_array($payload)
                    ? $this->normalizeListingFieldKeysInPayload($payload)
                    : $payload,
                array_values(array_filter($posts, 'is_array'))
            );
        }

        // Support field-array structure:
        // posts[kind][0], posts[kind][1], posts[off_plan][0], posts[off_plan][1], ...
        $maxIndex = -1;
        foreach ($posts as $fieldValues) {
            if (!is_array($fieldValues)) {
                continue;
            }

            $keys = array_keys($fieldValues);
            foreach ($keys as $key) {
                if (is_numeric($key)) {
                    $maxIndex = max($maxIndex, (int) $key);
                }
            }
        }

        if ($maxIndex < 0) {
            return [];
        }

        $normalized = [];
        for ($i = 0; $i <= $maxIndex; $i++) {
            $item = [];
            foreach ($posts as $field => $fieldValues) {
                if (is_array($fieldValues) && array_key_exists($i, $fieldValues)) {
                    $item[$field] = $fieldValues[$i];
                }
            }

            if (!empty($item)) {
                $normalized[] = $this->normalizeListingFieldKeysInPayload($item);
            }
        }

        return $normalized;
    }

    private function createListingFromPayload(
        Request $request,
        int $userId,
        array $data,
        array $formData,
        bool $storeTopLevelMedia,
        array $mediaFiles = []
    ): Listing {
        if (empty($data['expires_at'])) {
            $data['expires_at'] = Carbon::now()->addMonth();
        }

        $listing = new Listing();
        $listing->created_by = $userId;
        $this->applyValidatedPayloadToListing($listing, $data, $formData, false);
        $listing->save();

        if ($storeTopLevelMedia) {
            $this->storeUploadedMedia($request, $listing);
        }
        if (!empty($mediaFiles)) {
            $this->storeUploadedMediaFromFiles($mediaFiles, $listing);
        }

        return $listing;
    }

    /**
     * Normalize add-post style body (posts[0][field], object0, or flat JSON) for update.
     *
     * @return array<string, mixed>
     */
    private function resolveUpdatePayload(Request $request): array
    {
        $payloads = $this->resolveIncomingPostPayloads($request);
        $payloadFiles = $this->resolveIncomingPostFiles($request);

        $payload = $payloads[0] ?? $this->mergeRequestPayload($request);

        if (!empty($payloadFiles[0])) {
            $payload = array_merge($payload, $payloadFiles[0]);
        }

        foreach (['images', 'videos', 'documents'] as $field) {
            if ($request->hasFile($field)) {
                $payload[$field] = $this->normalizeFileGroup($request->file($field));
            }
        }

        return $payload;
    }

    /**
     * @param  array<string, mixed>  $payload
     * @return array<string, mixed>
     */
    private function extractFormDataFromPostPayload(array $payload, Request $request): array
    {
        if (array_key_exists('form-data', $payload)) {
            return $this->parseFormDataField($payload['form-data']);
        }

        if (array_key_exists('form_data', $payload)) {
            return $this->parseFormDataField($payload['form_data']);
        }

        if (array_key_exists('formData', $payload)) {
            return $this->parseFormDataField($payload['formData']);
        }

        $topLevel = $this->parseFormDataField(
            $request->input('form-data', $request->input('form_data', $request->input('formData')))
        );

        if (!empty($topLevel) && !array_is_list($topLevel)) {
            return $topLevel;
        }

        return [];
    }

    /**
     * @param  array<string, mixed>  $payload
     */
    private function removeFormDataKeysFromPayload(array &$payload): void
    {
        unset($payload['form-data'], $payload['form_data'], $payload['formData'], $payload['posts']);
    }

    /**
     * @return array<string, mixed>
     */
    private function mergeRequestPayload(Request $request): array
    {
        $payload = $request->all();

        if ($request->isJson()) {
            $json = $request->json()->all();
            if (is_array($json)) {
                $payload = array_merge($payload, $json);
            }
        }

        return $payload;
    }

    /**
     * @param  array<string, mixed>  $payload
     */
    private function stripExpiryFieldsFromPayload(array &$payload): void
    {
        unset($payload['post_expiry'], $payload['expires_at']);
    }

    /**
     * @param  array<string, mixed>  $payload
     * @return array<string, mixed>
     */
    private function extractFormDataFromPayload(array &$payload): array
    {
        foreach (['form-data', 'form_data', 'formData'] as $key) {
            if (!array_key_exists($key, $payload)) {
                continue;
            }

            $parsed = $this->parseFormDataField($payload[$key]);
            unset($payload[$key]);

            return $parsed;
        }

        return [];
    }

    /**
     * Persist validated add-post fields onto a listing (create or partial update).
     *
     * @param  array<string, mixed>  $data
     * @param  array<string, mixed>  $formData
     */
    /**
     * Update only listings + listing_details DB columns (same mapping as add-post).
     *
     * @param  array<string, mixed>  $data
     * @param  array<string, mixed>  $formData  Raw form-data JSON from request (replaces column when sent)
     */
    private function applyUpdateToListing(Listing $listing, array $data, array $formData): void
    {
        $sent = static fn (string $key): bool => array_key_exists($key, $data);

        $resolvedKind = $this->resolveKindForListingUpdate($data, $formData);

        if ($sent('listing_type') || $resolvedKind !== null) {
            $listingType = $data['listing_type'] ?? $this->resolveListingType($resolvedKind ?? ($data['kind'] ?? null));
            if ($listingType) {
                $listing->listing_type = $listingType;
            }
        }

        if ($sent('off_plan')) {
            $listing->is_off_plan = (bool) ((int) $data['off_plan']);
        } elseif ($sent('is_off_plan')) {
            $listing->is_off_plan = (bool) $data['is_off_plan'];
        }

        if ($sent('title') || $sent('property_type')) {
            $propertyType = $data['property_type'] ?? $data['title'] ?? null;
            if ($propertyType !== null && $propertyType !== '') {
                $listing->property_type = $propertyType;
            }
        }

        foreach (array_keys($this->listingColumnsWritableFromFormData()) as $field) {
            if (in_array($field, ['is_off_plan', 'tags', 'expires_at', 'listing_type'], true)) {
                continue;
            }

            if ($sent($field)) {
                $listing->{$field} = $data[$field];
            }
        }

        if ($sent('tags')) {
            $listing->tags = $this->normalizeTags($data['tags'] ?? []);
        }

        if ($resolvedKind !== null) {
            $this->syncListingIntentTags($listing, $resolvedKind);
        }

        if ($sent('status') && $this->isValidListingLifecycleStatus($data['status'])) {
            $listing->status = $data['status'];
        }

        $listing->save();

        $detail = $listing->detail()->firstOrNew(['listing_id' => $listing->id]);
        $detailChanged = false;

        foreach (array_keys($this->listingDetailColumnsWritableFromFormData()) as $field) {
            if ($field === 'notes') {
                continue;
            }

            if ($sent($field)) {
                $detail->{$field} = $data[$field];
                $detailChanged = true;
            }
        }

        if ($sent('notes') || $sent('description')) {
            $detail->notes = $data['notes'] ?? $data['description'];
            $detailChanged = true;
        }

        $extra = is_array($detail->extra) ? $detail->extra : [];
        $extraChanged = false;

        if ($sent('commission_type')) {
            $extra['commission_type'] = $data['commission_type'];
            $extraChanged = true;
        }

        if ($resolvedKind !== null) {
            $extra['kind'] = $resolvedKind;
            $extraChanged = true;
        }

        if ($extraChanged) {
            $detail->extra = $extra;
            $detailChanged = true;
        }

        if ($formData !== []) {
            $existingFormData = is_array($detail->form_data) ? $detail->form_data : [];
            $detail->form_data = $this->formDataNormalizer->normalize(array_merge(
                $existingFormData,
                $this->stripMediaKeysFromFormData($formData)
            ));
            $detailChanged = true;
        }

        if ($detailChanged) {
            $detail->listing_id = $listing->id;
            $detail->save();
        }
    }

    private function applyValidatedPayloadToListing(
        Listing $listing,
        array $data,
        array $formData,
        bool $partial = false
    ): void {
        $shouldApply = static function (string $key) use ($data): bool {
            return array_key_exists($key, $data);
        };

        if ($shouldApply('listing_type') || $shouldApply('kind')) {
            $listingType = $data['listing_type'] ?? $this->resolveListingType($data['kind'] ?? $listing->listing_type);
            if ($listingType) {
                $listing->listing_type = $listingType;
            }
        }

        if ($shouldApply('off_plan')) {
            $listing->is_off_plan = (bool) ((int) $data['off_plan']);
        } elseif ($shouldApply('is_off_plan')) {
            $listing->is_off_plan = (bool) $data['is_off_plan'];
        } elseif (!$partial) {
            $listing->is_off_plan = false;
        }

        if ($shouldApply('title') || $shouldApply('property_type')) {
            $propertyType = $data['property_type'] ?? $data['title'] ?? null;
            if ($propertyType !== null && $propertyType !== '') {
                $listing->property_type = $propertyType;
            }
        }

        if ($shouldApply('currency')) {
            $listing->currency = $data['currency'] ?? $listing->currency ?? 'AED';
        }

        // Expiry is not updated via listing update API (use extend-expiry endpoint).
        if (!$partial && ($shouldApply('post_expiry') || $shouldApply('expires_at'))) {
            $expiresAt = $data['expires_at'] ?? $data['post_expiry'] ?? null;
            if ($expiresAt !== null) {
                $listing->expires_at = $expiresAt;
            }
        }

        $listingFields = [
            'price',
            'size',
            'beds',
            'baths',
            'area',
            'city',
            'project',
            'developer',
            'marked_as',
        ];

        foreach ($listingFields as $field) {
            if ($shouldApply($field) && array_key_exists($field, $data)) {
                $listing->{$field} = $data[$field];
            }
        }

        if ($shouldApply('status') && $this->isValidListingLifecycleStatus($data['status'])) {
            $listing->status = $data['status'];
        } elseif (!$partial && empty($listing->status)) {
            $listing->status = 'active';
        }

        if ($shouldApply('tags')) {
            $listing->tags = $this->normalizeTags($data['tags'] ?? []);
        }

        if ($shouldApply('kind') && !empty($data['kind']) && in_array($data['kind'], ['rent_request', 'buy_request'], true)) {
            $requestTag = strtoupper(str_replace('_', ' ', (string) $data['kind']));
            $tags = is_array($listing->tags) ? $listing->tags : [];
            if (!in_array($requestTag, $tags, true)) {
                $tags[] = $requestTag;
                $listing->tags = $tags;
            }
        }

        if (!$partial && empty($listing->property_type)) {
            $listing->property_type = $data['property_type'] ?? $data['title'] ?? 'Untitled Post';
        }

        if (!$partial && empty($listing->currency)) {
            $listing->currency = 'AED';
        }

        $listing->save();

        $detailFields = ['payment_plan', 'ownership', 'furnished', 'commission', 'roi', 'amenities', 'additional_notes'];
        $detailData = [];
        foreach ($detailFields as $field) {
            if ($shouldApply($field)) {
                $detailData[$field] = $data[$field];
            }
        }

        if ($shouldApply('notes')) {
            $detailData['notes'] = $data['notes'];
        } elseif ($shouldApply('description')) {
            $detailData['notes'] = $data['description'];
        }

        $detail = $listing->detail()->firstOrNew(['listing_id' => $listing->id]);
        $existingExtra = is_array($detail->extra) ? $detail->extra : [];

        if ($shouldApply('commission_type') && !empty($data['commission_type'])) {
            $existingExtra['commission_type'] = $data['commission_type'];
        }
        if ($shouldApply('kind') && !empty($data['kind'])) {
            $existingExtra['kind'] = (string) $data['kind'];
        }
        if (!empty($existingExtra)) {
            $detailData['extra'] = $existingExtra;
        }

        if (!empty($formData)) {
            $detailData['form_data'] = $this->formDataNormalizer->normalize(array_merge(
                $detail->form_data ?? [],
                $this->stripMediaKeysFromFormData($formData)
            ));
        } elseif ($partial && $shouldApply('form_data') && is_array($data['form_data'] ?? null)) {
            $detailData['form_data'] = $this->formDataNormalizer->normalize(array_merge(
                $detail->form_data ?? [],
                $data['form_data']
            ));
        }

        if (collect($detailData)->filter(fn ($value) => $value !== null && $value !== [])->isNotEmpty()) {
            $detail->fill($detailData);
            $detail->listing_id = $listing->id;
            $detail->save();
        }
    }

    private function listingUpdateValidationRules(): array
    {
        $rules = [];
        foreach ($this->listingStoreValidationRules() as $field => $rule) {
            if (preg_match('/^(images|videos|documents)\.\*$/', $field)) {
                // Update may send existing media URLs in posts[0][images][] to keep/remove.
                $rules[$field] = 'sometimes|nullable';
                continue;
            }

            if (str_contains($field, '.*')) {
                $rules[$field] = $rule;
                continue;
            }

            $rules[$field] = str_starts_with($rule, 'sometimes|') ? $rule : 'sometimes|' . $rule;
        }

        return $rules;
    }

    /**
     * Existing media URLs are synced separately; keep only new uploads for validation.
     *
     * @param  array<string, mixed>  $payload
     */
    private function stripNonUploadMediaFromPayload(array &$payload): void
    {
        foreach (['images', 'videos', 'documents'] as $field) {
            if (!array_key_exists($field, $payload)) {
                continue;
            }

            $items = $this->normalizeFileGroup($payload[$field]);
            $uploadsOnly = array_values(array_filter(
                $items,
                fn ($item) => $item instanceof UploadedFile
            ));

            if ($uploadsOnly === []) {
                unset($payload[$field]);
                continue;
            }

            $payload[$field] = $uploadsOnly;
        }
    }

    private function resolveIncomingPostFiles(Request $request): array
    {
        $resolved = [];

        $postsFiles = $request->file('posts');
        if (is_array($postsFiles)) {
            foreach ($postsFiles as $index => $files) {
                if (!is_array($files)) {
                    continue;
                }

                $resolved[(int) $index] = [
                    'images' => $this->normalizeFileGroup($files['images'] ?? null),
                    'videos' => $this->normalizeFileGroup($files['videos'] ?? null),
                    'documents' => $this->normalizeFileGroup($files['documents'] ?? null),
                ];
            }
        }

        return $resolved;
    }

    private function normalizeFileGroup($group): array
    {
        if ($group === null) {
            return [];
        }

        if (is_array($group)) {
            return array_values(array_filter($group));
        }

        return [$group];
    }

    private function storeUploadedMediaFromFiles(array $filesByGroup, Listing $listing, int $orderStart = 0): void
    {
        $groups = [
            'images' => 'image',
            'videos' => 'video',
            'documents' => 'doc',
        ];

        $order = $orderStart;
        foreach ($groups as $field => $type) {
            if (empty($filesByGroup[$field]) || !is_array($filesByGroup[$field])) {
                continue;
            }

            foreach ($filesByGroup[$field] as $file) {
                if (!$file) {
                    continue;
                }

                $path = $file->store('listing-media', 'public');
                ListingMedia::create([
                    'listing_id' => $listing->id,
                    'type' => $type,
                    'url' => Storage::url($path),
                    'order' => $order++,
                ]);
            }
        }
    }

    /**
     * On update: sync listing_media — keep posts[0][images][] URLs, remove omitted ones, add uploads.
     */
    private function syncListingMediaOnUpdate(Listing $listing, Request $request): void
    {
        $groups = [
            'images' => 'image',
            'videos' => 'video',
            'documents' => 'doc',
        ];

        foreach ($groups as $field => $type) {
            if (!$this->wasUpdateMediaFieldProvided($request, $field)) {
                continue;
            }

            $sync = $this->collectUpdateMediaSyncInputs($request, $field);
            $this->syncListingMediaType(
                $listing,
                $type,
                $field,
                $sync['keep_urls'],
                $sync['new_files']
            );
        }
    }

    private function wasUpdateMediaFieldProvided(Request $request, string $field): bool
    {
        if ($this->requestHasInputKey($request, "posts.0.{$field}") || $request->hasFile("posts.0.{$field}")) {
            return true;
        }

        if ($this->requestHasInputKey($request, $field) || $request->hasFile($field)) {
            return true;
        }

        foreach (array_keys($request->all()) as $key) {
            if (preg_match('/^posts\[\d+\]\[' . preg_quote($field, '/') . '\]/i', (string) $key)) {
                return true;
            }
        }

        $posts = $request->input('posts');
        if (is_array($posts)) {
            foreach ($posts as $post) {
                if (is_array($post) && array_key_exists($field, $post)) {
                    return true;
                }
            }
        }

        $payloads = $this->resolveIncomingPostPayloads($request);
        if (!empty($payloads[0]) && is_array($payloads[0]) && array_key_exists($field, $payloads[0])) {
            return true;
        }

        foreach ($this->resolveUpdateFormDataSources($request) as $formData) {
            if (array_key_exists($field, $formData)) {
                return true;
            }
        }

        return false;
    }

    private function requestHasInputKey(Request $request, string $key): bool
    {
        if (method_exists($request, 'exists')) {
            return $request->exists($key);
        }

        return $request->has($key);
    }

    /**
     * @return list<array<string, mixed>>
     */
    private function resolveUpdateFormDataSources(Request $request): array
    {
        $sources = [];

        foreach (['form-data', 'form_data', 'formData'] as $key) {
            $parsed = $this->parseFormDataField($request->input($key));
            if ($parsed !== [] && !array_is_list($parsed)) {
                $sources[] = $parsed;
            }
        }

        $posts = $request->input('posts');
        if (is_array($posts)) {
            foreach ($posts as $post) {
                if (!is_array($post)) {
                    continue;
                }

                foreach (['form-data', 'form_data', 'formData'] as $key) {
                    if (!array_key_exists($key, $post)) {
                        continue;
                    }

                    $parsed = $this->parseFormDataField($post[$key]);
                    if ($parsed !== [] && !array_is_list($parsed)) {
                        $sources[] = $parsed;
                    }
                }
            }
        }

        $payloads = $this->resolveIncomingPostPayloads($request);
        if (!empty($payloads[0]) && is_array($payloads[0])) {
            foreach (['form-data', 'form_data', 'formData'] as $key) {
                if (!array_key_exists($key, $payloads[0])) {
                    continue;
                }

                $parsed = $this->parseFormDataField($payloads[0][$key]);
                if ($parsed !== [] && !array_is_list($parsed)) {
                    $sources[] = $parsed;
                }
            }
        }

        return $sources;
    }

    /**
     * @return array{keep_urls: list<string>, new_files: list<UploadedFile>}
     */
    private function collectUpdateMediaSyncInputs(Request $request, string $field): array
    {
        $keepUrls = [];
        $newFiles = [];

        $valueSources = [
            $request->input("posts.0.{$field}"),
            $request->input($field),
        ];

        $posts = $request->input('posts');
        if (is_array($posts) && isset($posts[0]) && is_array($posts[0]) && array_key_exists($field, $posts[0])) {
            $valueSources[] = $posts[0][$field];
        }

        $payloads = $this->resolveIncomingPostPayloads($request);
        if (!empty($payloads[0]) && is_array($payloads[0]) && array_key_exists($field, $payloads[0])) {
            $valueSources[] = $payloads[0][$field];
        }

        foreach (array_keys($request->all()) as $key) {
            if (!preg_match('/^posts\[\d+\]\[' . preg_quote($field, '/') . '\](?:\[\])?$/i', (string) $key)) {
                continue;
            }

            $valueSources[] = $request->input((string) $key);
        }

        foreach ($this->resolveUpdateFormDataSources($request) as $formData) {
            if (array_key_exists($field, $formData)) {
                $valueSources[] = $formData[$field];
            }
        }

        foreach ($valueSources as $value) {
            foreach ($this->normalizeFileGroup($value) as $item) {
                if ($item instanceof UploadedFile) {
                    $newFiles[] = $item;
                    continue;
                }

                $url = $this->extractMediaUrlFromSyncItem($item);
                if ($url !== null) {
                    $keepUrls[] = $url;
                }
            }
        }

        $payloadFiles = $this->resolveIncomingPostFiles($request);
        $collectedFromPostsArray = !empty($payloadFiles[0]);

        $fileSources = [];
        if ($collectedFromPostsArray) {
            $fileSources[] = $payloadFiles[0][$field] ?? null;
        }

        if ($request->hasFile($field)) {
            $fileSources[] = $request->file($field);
        }

        if (!$collectedFromPostsArray) {
            $fileSources[] = $request->file("posts.0.{$field}");
        }

        foreach ($fileSources as $group) {
            foreach ($this->normalizeFileGroup($group) as $file) {
                if ($file instanceof UploadedFile) {
                    $newFiles[] = $file;
                }
            }
        }

        $deduped = $this->deduplicateUploadedFileGroups([$field => $newFiles]);

        return [
            'keep_urls' => array_values(array_unique($keepUrls)),
            'new_files' => $deduped[$field] ?? [],
        ];
    }

    /**
     * @param  list<string>  $keepUrls
     * @param  list<UploadedFile>  $newFiles
     */
    private function syncListingMediaType(
        Listing $listing,
        string $type,
        string $field,
        array $keepUrls,
        array $newFiles
    ): void {
        if ($keepUrls === [] && $newFiles !== []) {
            $this->deleteListingMediaByType($listing, $type);
            $this->storeUploadedMediaFromFiles([$field => $newFiles], $listing);

            return;
        }

        $normalizedKeep = [];
        foreach ($keepUrls as $url) {
            $normalized = $this->normalizeMediaUrlForComparison($url);
            if ($normalized !== null) {
                $normalizedKeep[$normalized] = true;
            }
        }

        $existing = $listing->media()->where('type', $type)->orderBy('order')->get();
        $order = 0;

        foreach ($existing as $media) {
            $rawUrl = $media->getRawOriginal('url') ?? $media->getAttributes()['url'] ?? null;
            $normalized = $this->normalizeMediaUrlForComparison(is_string($rawUrl) ? $rawUrl : null);

            if ($normalized !== null && isset($normalizedKeep[$normalized])) {
                if ((int) $media->order !== $order) {
                    $media->order = $order;
                    $media->save();
                }
                $order++;

                continue;
            }

            $this->deleteStoredMediaFile(is_string($rawUrl) ? $rawUrl : null);
            $media->delete();
        }

        if ($newFiles !== []) {
            $this->storeUploadedMediaFromFiles([$field => $newFiles], $listing, $order);
        }
    }

    private function extractMediaUrlFromSyncItem(mixed $item): ?string
    {
        if (is_string($item)) {
            $item = trim($item);

            return $item === '' ? null : $item;
        }

        if (!is_array($item)) {
            return null;
        }

        foreach (['url', 'path', 'src'] as $key) {
            if (!array_key_exists($key, $item) || !is_string($item[$key])) {
                continue;
            }

            $url = trim($item[$key]);
            if ($url !== '') {
                return $url;
            }
        }

        return null;
    }

    private function normalizeMediaUrlForComparison(?string $url): ?string
    {
        if (!is_string($url) || trim($url) === '') {
            return null;
        }

        $url = trim($url);
        $path = parse_url($url, PHP_URL_PATH);
        if (!is_string($path) || $path === '') {
            return strtolower($url);
        }

        $path = ltrim($path, '/');
        if (Str::startsWith($path, 'storage/')) {
            $path = Str::after($path, 'storage/');
        }

        return strtolower($path);
    }

    /**
     * @param  array{images: array, videos: array, documents: array}  $filesByGroup
     * @return array{images: array, videos: array, documents: array}
     */
    private function deduplicateUploadedFileGroups(array $filesByGroup): array
    {
        foreach ($filesByGroup as $field => $group) {
            $seen = [];
            $unique = [];

            foreach ($group as $file) {
                if (!$file) {
                    continue;
                }

                $key = $file instanceof UploadedFile
                    ? sha1($file->getRealPath() . '|' . $file->getClientOriginalName() . '|' . $file->getSize())
                    : spl_object_hash($file);

                if (isset($seen[$key])) {
                    continue;
                }

                $seen[$key] = true;
                $unique[] = $file;
            }

            $filesByGroup[$field] = $unique;
        }

        return $filesByGroup;
    }

    private function deleteListingMediaByType(Listing $listing, string $type): void
    {
        $listing->media()->where('type', $type)->get()->each(function (ListingMedia $media) {
            $this->deleteStoredMediaFile($media->getRawOriginal('url') ?? $media->url);
            $media->delete();
        });
    }

    private function deleteStoredMediaFile(?string $url): void
    {
        if (!is_string($url) || $url === '') {
            return;
        }

        $path = parse_url($url, PHP_URL_PATH);
        if (!is_string($path) || $path === '') {
            return;
        }

        $relative = Str::startsWith($path, '/storage/')
            ? Str::after($path, '/storage/')
            : ltrim($path, '/');

        if ($relative !== '') {
            Storage::disk('public')->delete($relative);
        }
    }

    /**
     * Media lives in listing_media table only — keep out of form_data JSON.
     *
     * @param  array<string, mixed>  $formData
     * @return array<string, mixed>
     */
    private function stripMediaKeysFromFormData(array $formData): array
    {
        foreach ([
            'images',
            'videos',
            'documents',
            'attachments',
            'media',
            'photos',
            'files',
            'image',
            'video',
            'document',
        ] as $key) {
            unset($formData[$key]);
        }

        return $formData;
    }
}


