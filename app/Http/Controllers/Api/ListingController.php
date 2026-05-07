<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Listing;
use App\Models\ListingDetail;
use App\Models\ListingMedia;
use App\Services\ListingQueryService;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\ValidationException;

class ListingController extends Controller
{
    public function __construct(
        private ListingQueryService $listingQuery
    ) {
    }

    /**
     * Home feed + filters.
     */
    public function index(Request $request)
    {
        return $this->paginatedListings($request, true);
    }

    /**
     * Search listings (same filters + pagination as index).
     */
    public function search(Request $request)
    {
        return $this->paginatedListings($request, true);
    }

    private function paginatedListings(Request $request, bool $activeOnly)
    {
        $query = $this->listingQuery->baseListingQuery($request, $activeOnly);
        $this->listingQuery->applyFilters($query, $request);
        $query->orderByDesc('created_at');

        $requestedPage = max(1, (int) $request->query('page', 1));
        $paginator = $query->paginate(20, ['*'], 'page', $requestedPage);
        if (count($paginator->items()) === 0 && $requestedPage > 1 && $paginator->lastPage() > 0) {
            $paginator = $query->paginate(20, ['*'], 'page', $paginator->lastPage());
        }

        $this->listingQuery->transformPaginatorCollection($paginator, $request->user());

        return response()->json([
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
        ]);
    }

    /**
     * Add-post screen: optional fields the client may send on create (GET /listings/add-post).
     */
    public function addPostForm()
    {
        return response()->json([
            'additional_notes' => null,
        ]);
    }

    /**
     * Listing detail.
     */
    public function show(Request $request, Listing $listing)
    {
        $listingId = $listing->id;

        $this->listingQuery->baseListingQuery($request, false)
            ->whereKey($listingId)
            ->firstOrFail()
            ->increment('views_count');

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
     * Update listing (owner only).
     */
    public function update(Request $request, Listing $listing)
    {
        $this->authorizeListing($request, $listing);

        $data = $request->validate([
            'property_type' => 'sometimes|string|max:255',
            'price' => 'sometimes|nullable|numeric',
            'currency' => 'sometimes|nullable|string|max:10',
            'size' => 'sometimes|nullable|numeric',
            'beds' => 'sometimes|nullable|integer|min:0',
            'baths' => 'sometimes|nullable|integer|min:0',
            'area' => 'sometimes|nullable|string|max:255',
            'city' => 'sometimes|nullable|string|max:255',
            'project' => 'sometimes|nullable|string|max:255',
            'developer' => 'sometimes|nullable|string|max:255',
            'is_off_plan' => 'sometimes|boolean',
            'tags' => 'sometimes|array',
            'expires_at' => 'sometimes|nullable|date',

            // details
            'payment_plan' => 'sometimes|nullable|string',
            'ownership' => 'sometimes|nullable|string|max:255',
            'furnished' => 'sometimes|nullable|in:furnished,unfurnished,semi',
            'commission' => 'sometimes|nullable|numeric',
            'roi' => 'sometimes|nullable|numeric',
            'notes' => 'sometimes|nullable|string',
            'additional_notes' => 'sometimes|nullable|string',
            'amenities' => 'sometimes|nullable|array',
        ]);

        $listing->fill($data);
        $listing->save();

        $detailData = collect($data)->only([
            'payment_plan',
            'ownership',
            'furnished',
            'commission',
            'roi',
            'notes',
            'additional_notes',
            'amenities',
        ])->toArray();

        if (!empty($detailData)) {
            $listing->detail()
                ->updateOrCreate(
                    ['listing_id' => $listing->id],
                    $detailData
                );
        }

        return response()->json(
            $listing->load(['creator.brokerProfile', 'detail'])
        );
    }

    /**
     * Delete listing (owner only).
     */
    public function destroy(Request $request, Listing $listing)
    {
        $this->authorizeListing($request, $listing);
        $listing->delete();

        return response()->json([
            'message' => 'Listing deleted.',
        ]);
    }

    /**
     * Mark as sold.
     */
    public function markSold(Request $request, Listing $listing)
    {
        $this->authorizeListing($request, $listing);
        $listing->status = 'sold';
        $listing->save();

        return response()->json($listing);
    }

    /**
     * Mark as rented.
     */
    public function markRented(Request $request, Listing $listing)
    {
        $this->authorizeListing($request, $listing);
        $listing->status = 'rented';
        $listing->save();

        return response()->json($listing);
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

    protected function authorizeListing(Request $request, Listing $listing): void
    {
        if ($listing->created_by !== $request->user()->id) {
            abort(403, 'You are not allowed to modify this listing.');
        }
    }

    private function resolveListingType(?string $kind): ?string
    {
        return match ($kind) {
            'sale' => 'sale',
            'rent' => 'rent',
            'required', 'rent_request', 'buy_request' => 'requirement',
            default => 'requirement',
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

    private function applyFormDataToListingPayload(array $data, array $formData): array
    {
        $assignableFields = [
            'listing_type',
            'kind',
            'property_type',
            'title',
            'price',
            'currency',
            'size',
            'beds',
            'baths',
            'area',
            'city',
            'project',
            'developer',
            'off_plan',
            'expires_at',
            'description',
            'payment_plan',
            'ownership',
            'furnished',
            'commission',
            'commission_type',
            'roi',
            'notes',
            'additional_notes',
            'amenities',
            'post_expiry',
        ];

        foreach ($assignableFields as $field) {
            if (array_key_exists($field, $formData)) {
                $data[$field] = $this->normalizeIncomingFieldValue($field, $formData[$field]);
            }
        }

        // `post_expiry` is the app field; persist in DB as `expires_at`.
        if (array_key_exists('post_expiry', $formData) && !array_key_exists('expires_at', $data)) {
            $data['expires_at'] = $formData['post_expiry'];
        }

        $tags = $formData['tags'] ?? ($formData['tag'] ?? null);
        if (is_string($tags)) {
            $tags = array_values(array_filter(array_map('trim', explode(',', $tags))));
        }

        if (is_array($tags)) {
            $data['tags'] = $tags;
        }

        return $data;
    }

    private function normalizeIncomingFieldValue(string $field, $value)
    {
        $arrayAllowedFields = ['tags', 'amenities', 'attachments'];
        if (in_array($field, $arrayAllowedFields, true)) {
            return $value;
        }

        if (is_array($value)) {
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

        return $value;
    }

    private function listingStoreValidationRules(): array
    {
        return [
            'form-data' => 'nullable',
            'form_data' => 'nullable',
            'formData' => 'nullable',
            'listing_type' => 'nullable|in:sale,rent,requirement',
            'kind' => 'nullable|string|max:255',
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
            'notes' => 'nullable|string',
            'additional_notes' => 'nullable|string',
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
            return array_values($objects);
        }

        $bracketStyle = [];
        foreach ($request->all() as $key => $value) {
            if (!preg_match('/^posts\[(\d+)\]\[(.+)\]$/', (string) $key, $match)) {
                continue;
            }

            $index = (int) $match[1];
            $field = (string) $match[2];
            $bracketStyle[$index][$field] = $value;
        }

        if (!empty($bracketStyle)) {
            ksort($bracketStyle);
            return array_values($bracketStyle);
        }

        return [$request->all()];
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
            return array_values($indexedItems);
        }

        $allItemsAreArrays = true;
        foreach ($posts as $value) {
            if (!is_array($value)) {
                $allItemsAreArrays = false;
                break;
            }
        }

        if ($allItemsAreArrays) {
            return array_values(array_filter($posts, 'is_array'));
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
                $normalized[] = $item;
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
        $listingType = $data['listing_type'] ?? $this->resolveListingType($data['kind'] ?? null);
        if (!$listingType) {
            $listingType = 'requirement';
        }

        $data['is_off_plan'] = (bool) ((int) $data['off_plan']);
        unset($data['off_plan']);

        if (!empty($data['title']) && empty($data['property_type'])) {
            $data['property_type'] = $data['title'];
        }

        if (empty($data['currency'])) {
            $data['currency'] = 'AED';
        }

        if (empty($data['expires_at']) && !empty($data['post_expiry'])) {
            $data['expires_at'] = $data['post_expiry'];
        }
        if (empty($data['expires_at'])) {
            $data['expires_at'] = Carbon::now()->addMonth();
        }

        $propertyType = $data['property_type'] ?? $data['title'] ?? 'Untitled Post';
        $detailNotes = $data['notes'] ?? $data['description'] ?? null;
        $normalizedTags = $this->normalizeTags($data['tags'] ?? []);

        if (!empty($data['kind']) && in_array($data['kind'], ['rent_request', 'buy_request'], true)) {
            $requestTag = strtoupper(str_replace('_', ' ', (string) $data['kind']));
            if (!in_array($requestTag, $normalizedTags, true)) {
                $normalizedTags[] = $requestTag;
            }
        }

        $listing = new Listing();
        $listing->fill(array_merge($data, [
            'listing_type' => $listingType,
            'property_type' => $propertyType,
            'tags' => $normalizedTags,
        ]));
        $listing->created_by = $userId;
        $listing->save();

        $detailData = collect($data)->only([
            'payment_plan',
            'ownership',
            'furnished',
            'commission',
            'roi',
            'amenities',
            'additional_notes',
        ])->toArray();
        $detailData['notes'] = $detailNotes;
        if (!empty($formData)) {
            $detailData['form_data'] = $formData;
        }

        $extra = [];
        if (!empty($data['commission_type'])) {
            $extra['commission_type'] = $data['commission_type'];
        }
        if (!empty($data['kind'])) {
            $extra['kind'] = (string) $data['kind'];
        }
        if (!empty($data['description']) && empty($detailData['notes'])) {
            $detailData['notes'] = $data['description'];
        }
        if (!empty($extra)) {
            $detailData['extra'] = $extra;
        }

        if (collect($detailData)->filter(fn ($value) => $value !== null)->isNotEmpty()) {
            $detail = new ListingDetail($detailData);
            $detail->listing_id = $listing->id;
            $detail->save();
        }

        if ($storeTopLevelMedia) {
            $this->storeUploadedMedia($request, $listing);
        }
        if (!empty($mediaFiles)) {
            $this->storeUploadedMediaFromFiles($mediaFiles, $listing);
        }

        return $listing;
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

    private function storeUploadedMediaFromFiles(array $filesByGroup, Listing $listing): void
    {
        $groups = [
            'images' => 'image',
            'videos' => 'video',
            'documents' => 'doc',
        ];

        $order = 0;
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
}


