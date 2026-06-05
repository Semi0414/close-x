<?php

namespace App\Services;

use App\Models\Listing;
use App\Support\CompactPriceSearch;
use App\Support\ListingFormDataNormalizer;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\Request;

class ListingQueryService
{
    public function __construct(
        private ListingFormDataNormalizer $formDataNormalizer,
        private ListingMetricsService $metricsService
    ) {
    }

    /**
     * Base query for public active listings with common relations & aggregates.
     */
    public function baseListingQuery(Request $request, bool $activeOnly = true): Builder
    {
        $user = $request->user();

        $query = Listing::query()
            ->with(['creator.brokerProfile', 'creator.agency', 'media', 'detail']);

        if ($activeOnly) {
            $query->where('status', 'active')
                ->whereNull('marked_as');
        }

        $query
            ->withCount([
                'listingReviews as ratings_count',
                'comments as comments_count',
                'likes as likes_count',
            ])
            ->withAvg('listingReviews', 'rating');

        if ($user) {
            $query->withExists([
                'favorites as is_favorited' => function (Builder $q) use ($user) {
                    $q->where('user_id', $user->id);
                },
            ]);
        }

        return $query;
    }

    public function applyFilters(Builder $query, Request $request): Builder
    {
        $this->applyFiltersArray($query, $this->resolveListingFiltersFromRequest($request));

        return $query;
    }

    /**
     * Flat query params and nested ?filters[city]=… or ?filters={"city":"Dubai"}.
     *
     * @return array<string, mixed>
     */
    public function resolveListingFiltersFromRequest(Request $request): array
    {
        $filters = array_merge(
            $request->query(),
            $request->request->all()
        );
        unset($filters['page']);

        if ($request->isJson()) {
            $json = $request->json()->all();
            if (is_array($json)) {
                $filters = array_merge($filters, $json);
            }
        }

        foreach (['filters', 'filter', 'data', 'params'] as $containerKey) {
            if (!isset($filters[$containerKey])) {
                continue;
            }

            $nested = $filters[$containerKey];
            unset($filters[$containerKey]);

            if (is_string($nested)) {
                $decoded = json_decode($nested, true);
                $nested = json_last_error() === JSON_ERROR_NONE && is_array($decoded) ? $decoded : [];
            }

            if (is_array($nested)) {
                $filters = array_merge($filters, $nested);
            }
        }

        return $this->normalizeFilterPayload($filters);
    }

    /**
     * @param  array<string, mixed>  $filters
     */
    public function applyFiltersArray(Builder $query, array $filters): void
    {
        if ($this->hasFilterValue($filters, 'status')) {
            $this->applyListingIntentFilter($query, (string) $filters['status']);
        } elseif ($this->hasFilterValue($filters, 'listing_type')) {
            $this->applyListingIntentFilter($query, (string) $filters['listing_type']);
        }

        if ($this->hasFilterValue($filters, 'location')) {
            $this->applyLocationFilter($query, (string) $filters['location']);
        }

        if ($this->hasFilterValue($filters, 'city')) {
            $city = (string) $filters['city'];
            if (str_contains(trim($city), ' ')) {
                $this->applyLocationFilter($query, $city);
            } else {
                $this->applyLikeFilterOnListingOrFormData($query, $city, [
                    'city',
                ]);
            }
        }

        if ($this->hasFilterValue($filters, 'area')) {
            $this->applyLikeFilterOnListingOrFormData($query, (string) $filters['area'], [
                'area',
            ]);
        }

        if ($this->hasFilterValue($filters, 'property_type')) {
            $this->applyLikeFilterOnListingOrFormData($query, (string) $filters['property_type'], [
                'property_type',
            ]);
        }

        if ($this->hasFilterValue($filters, 'min_price')) {
            $query->whereRaw($this->effectiveListingPriceSql() . ' >= ?', [(float) $filters['min_price']]);
        }

        if ($this->hasFilterValue($filters, 'max_price')) {
            $query->whereRaw($this->effectiveListingPriceSql() . ' <= ?', [(float) $filters['max_price']]);
        }

        if ($this->hasFilterValue($filters, 'min_beds')) {
            $query->whereRaw($this->effectiveListingBedsSql() . ' >= ?', [(int) $filters['min_beds']]);
        }

        if ($this->hasFilterValue($filters, 'beds')) {
            $query->whereRaw($this->effectiveListingBedsSql() . ' = ?', [(int) $filters['beds']]);
        }

        if ($this->hasFilterValue($filters, 'baths')) {
            $query->where('baths', (int) $filters['baths']);
        }

        if ($this->hasFilterValue($filters, 'is_off_plan')) {
            $query->where('is_off_plan', filter_var($filters['is_off_plan'], FILTER_VALIDATE_BOOLEAN));
        }

        if ($this->hasFilterValue($filters, 'off_plan')) {
            $query->where(
                'is_off_plan',
                filter_var($filters['off_plan'], FILTER_VALIDATE_BOOLEAN, FILTER_NULL_ON_FAILURE)
                    ?? (bool) (int) $filters['off_plan']
            );
        }

        $tags = $filters['tags'] ?? null;
        if (is_string($tags)) {
            $tags = array_filter(array_map('trim', explode(',', $tags)));
        }
        if (is_array($tags) && count($tags) > 0) {
            $query->where(function (Builder $tagQuery) use ($tags) {
                foreach ($tags as $tag) {
                    if (!is_string($tag) || trim($tag) === '') {
                        continue;
                    }

                    $normalized = strtoupper(trim($tag));
                    $like = '%' . str_replace(['%', '_'], ['\\%', '\\_'], strtolower($normalized)) . '%';

                    $tagQuery->orWhere(function (Builder $match) use ($normalized, $like) {
                        $match->whereJsonContains('tags', $normalized)
                            ->orWhereHas('detail', function (Builder $detailQuery) use ($like) {
                                $detailQuery->whereRaw(
                                    'LOWER(COALESCE(CAST(form_data AS CHAR), "")) LIKE ?',
                                    [$like]
                                );
                            });
                    });
                }
            });
        }

        $searchTerm = $filters['keyword'] ?? $filters['q'] ?? $filters['search'] ?? null;
        if (is_string($searchTerm) && trim($searchTerm) !== '') {
            $this->applyKeywordFilter($query, trim($searchTerm));
        }
    }

    /**
     * @param  array<string, mixed>  $filters
     */
    private function normalizeFilterPayload(array $filters): array
    {
        $keyAliases = [
            'propertyType' => 'property_type',
            'property_type' => 'property_type',
            'listingType' => 'listing_type',
            'listing_type' => 'listing_type',
            'minPrice' => 'min_price',
            'maxPrice' => 'max_price',
            'offPlan' => 'off_plan',
            'isOffPlan' => 'is_off_plan',
            'minBeds' => 'min_beds',
            'min_beds' => 'min_beds',
            'keyword' => 'keyword',
        ];

        $normalized = [];

        foreach ($filters as $key => $value) {
            $key = $keyAliases[$key] ?? $key;

            if ($this->shouldSkipFilterValue($value)) {
                continue;
            }

            $normalized[$key] = $value;
        }

        foreach (['tab', 'category', 'type'] as $tabKey) {
            if (!$this->hasFilterValue($normalized, $tabKey)) {
                continue;
            }

            $mapped = $this->mapUiTabToStatusFilter((string) $normalized[$tabKey]);
            unset($normalized[$tabKey]);

            if ($mapped !== null && !$this->hasFilterValue($normalized, 'status')) {
                $normalized['status'] = $mapped;
            }
        }

        // Mobile "Min Beds" dropdown usually sends `beds` but means minimum (>=), not exact match.
        if ($this->hasFilterValue($normalized, 'beds') && !$this->hasFilterValue($normalized, 'min_beds')) {
            $bedsExact = filter_var($normalized['beds_exact'] ?? false, FILTER_VALIDATE_BOOLEAN);
            if (!$bedsExact) {
                $normalized['min_beds'] = $normalized['beds'];
                unset($normalized['beds']);
            }
        }

        unset($normalized['beds_exact']);

        return $normalized;
    }

    private function mapUiTabToStatusFilter(string $tab): ?string
    {
        $normalized = strtolower(trim(str_replace('_', ' ', $tab)));

        return match ($normalized) {
            'all', '' => null,
            'for sale', 'sale' => 'for sale',
            'for rent', 'rent' => 'for rent',
            'buy request', 'buy_request' => 'buy request',
            'rent request', 'rent_request' => 'rent request',
            default => $tab,
        };
    }

    private function shouldSkipFilterValue(mixed $value): bool
    {
        if ($value === null) {
            return true;
        }

        if (is_string($value)) {
            $trimmed = strtolower(trim($value));

            return $trimmed === ''
                || in_array($trimmed, ['all', 'any', 'null', 'undefined', 'none'], true);
        }

        if (is_array($value) && $value === []) {
            return true;
        }

        return false;
    }

    /**
     * @param  array<string, mixed>  $filters
     */
    private function hasFilterValue(array $filters, string $key): bool
    {
        return array_key_exists($key, $filters) && !$this->shouldSkipFilterValue($filters[$key]);
    }

    /**
     * Match sale / rent / requirement from listings.listing_type or detail form_data / extra.
     */
    private function applyListingIntentFilter(Builder $query, string $rawValue): void
    {
        $normalizedTypes = $this->normalizeListingTypeFilterValues($rawValue);
        $typeAliases = $this->listingTypeAliases($normalizedTypes);

        $query->where(function (Builder $outer) use ($normalizedTypes, $typeAliases) {
            $outer->whereIn('listing_type', $normalizedTypes);

            if ($typeAliases === []) {
                return;
            }

            $outer->orWhereHas('detail', function (Builder $detailQuery) use ($typeAliases) {
                $detailQuery->where(function (Builder $match) use ($typeAliases) {
                    foreach ($typeAliases as $alias) {
                        $like = '%' . str_replace(['%', '_'], ['\\%', '\\_'], $alias) . '%';
                        $match
                            ->orWhereRaw(
                                'LOWER(TRIM(JSON_UNQUOTE(JSON_EXTRACT(form_data, "$.kind")))) LIKE ?',
                                [$like]
                            )
                            ->orWhereRaw(
                                'LOWER(TRIM(JSON_UNQUOTE(JSON_EXTRACT(form_data, "$.status")))) LIKE ?',
                                [$like]
                            )
                            ->orWhereRaw(
                                'LOWER(TRIM(JSON_UNQUOTE(JSON_EXTRACT(extra, "$.kind")))) LIKE ?',
                                [$like]
                            )
                            ->orWhereRaw('LOWER(COALESCE(CAST(form_data AS CHAR), "")) LIKE ?', [$like]);
                    }
                });
            });
        });
    }

    /**
     * COALESCE(listings.price, form_data price-sp, scalar form_data price).
     */
    private function effectiveListingPriceSql(): string
    {
        return 'COALESCE(
            listings.price,
            (SELECT CAST(JSON_UNQUOTE(JSON_EXTRACT(ld.form_data, "$.price.sp")) AS DECIMAL(15,2))
                FROM listing_details ld WHERE ld.listing_id = listings.id LIMIT 1),
            (SELECT CAST(JSON_UNQUOTE(JSON_EXTRACT(ld.form_data, "$.price")) AS DECIMAL(15,2))
                FROM listing_details ld WHERE ld.listing_id = listings.id LIMIT 1)
        )';
    }

    /**
     * COALESCE(listings.beds, form_data rooms.bedrooms / beds).
     */
    private function effectiveListingBedsSql(): string
    {
        return 'COALESCE(
            listings.beds,
            (SELECT CAST(JSON_UNQUOTE(JSON_EXTRACT(ld.form_data, "$.rooms.bedrooms")) AS UNSIGNED)
                FROM listing_details ld WHERE ld.listing_id = listings.id LIMIT 1),
            (SELECT CAST(JSON_UNQUOTE(JSON_EXTRACT(ld.form_data, "$.beds")) AS UNSIGNED)
                FROM listing_details ld WHERE ld.listing_id = listings.id LIMIT 1)
        )';
    }

    /**
     * Location filter: match area names (e.g. Dubai Hills) without returning every Dubai listing.
     */
    private function applyLocationFilter(Builder $query, string $location): void
    {
        $phrase = trim($location);
        if ($phrase === '') {
            return;
        }

        $query->where(function (Builder $outer) use ($phrase) {
            $this->applyLocationPhraseMatch($outer, $phrase);
        });
    }

    /**
     * Multi-word AI/keyword searches that look like a place name (Dubai Hills, Downtown Dubai).
     */
    private function shouldUseLocationFocusedKeywordSearch(string $rawKeyword): bool
    {
        $trimmed = trim($rawKeyword);
        if ($trimmed === '' || !str_contains($trimmed, ' ')) {
            return false;
        }

        return (bool) preg_match('/^[a-zA-Z][a-zA-Z\\s.,\\-\\\']+$/', $trimmed);
    }

    private function applyKeywordLocationFocusedFilter(Builder $q, string $rawKeyword): void
    {
        $keyword = '%' . str_replace(['%', '_'], ['\\%', '\\_'], strtolower(trim($rawKeyword))) . '%';

        $q->where(function (Builder $outer) use ($rawKeyword, $keyword) {
            $this->applyLocationPhraseMatch($outer, $rawKeyword);

            $outer->orWhereRaw('LOWER(COALESCE(property_type, "")) LIKE ?', [$keyword])
                ->orWhereRaw('LOWER(COALESCE(project, "")) LIKE ?', [$keyword]);
        });
    }

    private function applyLocationPhraseMatch(Builder $query, string $phrase): void
    {
        $needle = '%' . str_replace(['%', '_'], ['\\%', '\\_'], strtolower(trim($phrase))) . '%';

        $query->where(function (Builder $q) use ($needle) {
            $q->whereRaw("LOWER(COALESCE(area, '')) LIKE ?", [$needle])
                ->orWhereRaw("LOWER(COALESCE(city, '')) LIKE ?", [$needle])
                ->orWhereRaw("LOWER(COALESCE(project, '')) LIKE ?", [$needle])
                ->orWhereRaw("LOWER(CONCAT(COALESCE(city, ''), ' ', COALESCE(area, ''))) LIKE ?", [$needle])
                ->orWhereRaw("LOWER(CONCAT(COALESCE(area, ''), ' ', COALESCE(city, ''))) LIKE ?", [$needle])
                ->orWhereHas('detail', function (Builder $detailQuery) use ($needle) {
                    $detailQuery->where(function (Builder $formMatch) use ($needle) {
                        foreach (['$.city', '$.area', '$.project', '$.location', '$.City', '$.Area'] as $jsonPath) {
                            $formMatch->orWhereRaw(
                                "LOWER(TRIM(JSON_UNQUOTE(JSON_EXTRACT(form_data, ?)))) LIKE ?",
                                [$jsonPath, $needle]
                            );
                        }
                    });
                });
        });
    }

    /**
     * @param  list<string>  $listingColumns
     */
    private function applyLikeFilterOnListingOrFormData(Builder $query, string $value, array $listingColumns): void
    {
        $needle = '%' . str_replace(['%', '_'], ['\\%', '\\_'], strtolower(trim($value))) . '%';

        $query->where(function (Builder $outer) use ($listingColumns, $needle) {
            foreach ($listingColumns as $column) {
                $outer->orWhereRaw("LOWER(COALESCE({$column}, '')) LIKE ?", [$needle]);
            }

            $outer->orWhereHas('detail', function (Builder $detailQuery) use ($needle) {
                $detailQuery->whereRaw('LOWER(COALESCE(CAST(form_data AS CHAR), "")) LIKE ?', [$needle]);
            });
        });
    }

    /**
     * Full-text style match across listings, listing_details.form_data, broker, and reviews.
     * Also supports compact prices in the keyword (12k, 22M, 12k AED, $22M USD).
     */
    private function applyKeywordFilter(Builder $query, string $rawKeyword): void
    {
        $extracted = CompactPriceSearch::extract($rawKeyword);
        $textKeyword = $extracted['text'] !== '' ? $extracted['text'] : (
            $extracted['prices'] === [] ? $rawKeyword : ''
        );

        $query->where(function (Builder $q) use ($textKeyword, $rawKeyword, $extracted) {
            $hasCondition = false;

            if ($textKeyword !== '') {
                $q->where(function (Builder $textQ) use ($textKeyword) {
                    $this->applyKeywordTextFilter($textQ, $textKeyword);
                });
                $hasCondition = true;
            }

            foreach ($extracted['prices'] as $priceSpec) {
                $method = $hasCondition ? 'orWhere' : 'where';
                $q->{$method}(function (Builder $priceQ) use ($priceSpec) {
                    $this->applyKeywordPriceFilter($priceQ, $priceSpec);
                });
                $hasCondition = true;
            }

            if (!$hasCondition) {
                $this->applyKeywordTextFilter($q, $rawKeyword);
            }
        });
    }

    private function applyKeywordTextFilter(Builder $q, string $rawKeyword): void
    {
        if ($this->shouldUseLocationFocusedKeywordSearch($rawKeyword)) {
            $this->applyKeywordLocationFocusedFilter($q, $rawKeyword);

            return;
        }

        $keyword = '%' . str_replace(['%', '_'], ['\\%', '\\_'], strtolower($rawKeyword)) . '%';
        $exactTag = strtoupper($rawKeyword);

        $q->whereRaw('LOWER(COALESCE(property_type, "")) LIKE ?', [$keyword])
            ->orWhereRaw('LOWER(COALESCE(listing_type, "")) LIKE ?', [$keyword])
            ->orWhereRaw('LOWER(COALESCE(area, "")) LIKE ?', [$keyword])
            ->orWhereRaw('LOWER(COALESCE(city, "")) LIKE ?', [$keyword])
            ->orWhereRaw('LOWER(COALESCE(project, "")) LIKE ?', [$keyword])
            ->orWhereRaw('LOWER(COALESCE(developer, "")) LIKE ?', [$keyword])
            ->orWhereRaw('LOWER(COALESCE(currency, "")) LIKE ?', [$keyword])
            ->orWhereRaw('LOWER(COALESCE(marked_as, "")) LIKE ?', [$keyword])
            ->orWhereRaw('CAST(COALESCE(price, 0) AS CHAR) LIKE ?', [$keyword])
            ->orWhereRaw('CAST(COALESCE(beds, 0) AS CHAR) LIKE ?', [$keyword])
            ->orWhereRaw('CAST(COALESCE(baths, 0) AS CHAR) LIKE ?', [$keyword])
            ->orWhereRaw('CAST(COALESCE(size, 0) AS CHAR) LIKE ?', [$keyword])
            ->orWhereRaw('LOWER(COALESCE(CAST(tags AS CHAR), "")) LIKE ?', [$keyword])
            ->orWhereJsonContains('tags', $exactTag);

        if (ctype_digit($rawKeyword)) {
            $q->orWhere('listings.id', (int) $rawKeyword);
        }

        $q->orWhereHas('detail', function (Builder $dq) use ($keyword) {
            $dq->whereRaw('LOWER(COALESCE(notes, "")) LIKE ?', [$keyword])
                ->orWhereRaw('LOWER(COALESCE(additional_notes, "")) LIKE ?', [$keyword])
                ->orWhereRaw('LOWER(COALESCE(payment_plan, "")) LIKE ?', [$keyword])
                ->orWhereRaw('LOWER(COALESCE(ownership, "")) LIKE ?', [$keyword])
                ->orWhereRaw('LOWER(COALESCE(furnished, "")) LIKE ?', [$keyword])
                ->orWhereRaw('LOWER(COALESCE(CAST(form_data AS CHAR), "")) LIKE ?', [$keyword])
                ->orWhereRaw('LOWER(COALESCE(CAST(extra AS CHAR), "")) LIKE ?', [$keyword]);
        })
            ->orWhereHas('creator', function (Builder $cq) use ($keyword) {
                $cq->whereRaw('LOWER(COALESCE(name, "")) LIKE ?', [$keyword])
                    ->orWhereRaw('LOWER(COALESCE(first_name, "")) LIKE ?', [$keyword])
                    ->orWhereRaw('LOWER(COALESCE(last_name, "")) LIKE ?', [$keyword])
                    ->orWhereRaw('LOWER(COALESCE(phone, "")) LIKE ?', [$keyword])
                    ->orWhereRaw('LOWER(COALESCE(email, "")) LIKE ?', [$keyword])
                    ->orWhereHas('brokerProfile', function (Builder $bpq) use ($keyword) {
                        $bpq->whereRaw('LOWER(COALESCE(company_name, "")) LIKE ?', [$keyword])
                            ->orWhereRaw('LOWER(COALESCE(bio, "")) LIKE ?', [$keyword])
                            ->orWhereRaw('LOWER(COALESCE(brn_number, "")) LIKE ?', [$keyword]);
                    });
            })
            ->orWhereHas('listingReviews', function (Builder $rq) use ($keyword) {
                $rq->whereRaw('LOWER(COALESCE(review_text, "")) LIKE ?', [$keyword]);
            });
    }

    /**
     * @param  array{amount: float, suffix: ?string, currency: ?string}  $spec
     */
    private function applyKeywordPriceFilter(Builder $q, array $spec): void
    {
        $priceSql = $this->effectiveListingPriceSql();

        $q->where(function (Builder $priceQ) use ($spec, $priceSql) {
            if ($spec['suffix'] === 'k') {
                $kValue = $spec['amount'] / 1_000;
                $priceQ->whereRaw("ROUND({$priceSql} / 1000) = ?", [$kValue])
                    ->orWhereRaw("ROUND({$priceSql} / 1000, 1) = ?", [$kValue]);
            } elseif ($spec['suffix'] === 'm') {
                $mValue = $spec['amount'] / 1_000_000;
                $priceQ->whereRaw("ROUND({$priceSql} / 1000000, 1) = ?", [$mValue])
                    ->orWhereRaw("ROUND({$priceSql} / 1000000) = ?", [$mValue]);
            } elseif ($spec['suffix'] === 'b') {
                $bValue = $spec['amount'] / 1_000_000_000;
                $priceQ->whereRaw("ROUND({$priceSql} / 1000000000, 2) = ?", [$bValue]);
            } else {
                $margin = max($spec['amount'] * 0.05, 1_000);
                $priceQ->whereRaw("{$priceSql} BETWEEN ? AND ?", [
                    $spec['amount'] - $margin,
                    $spec['amount'] + $margin,
                ]);
            }

            if (!empty($spec['currency'])) {
                $priceQ->whereRaw('LOWER(COALESCE(listings.currency, "")) = ?', [
                    strtolower($spec['currency']),
                ]);
            }
        });
    }

    /**
     * @return array<int, string>
     */
    private function normalizeListingTypeFilterValues(string $rawValue): array
    {
        $value = strtolower(trim($rawValue));

        return match ($value) {
            'for sale', 'sale' => ['sale'],
            'for rent', 'rent' => ['rent'],
            'rent request', 'sale request', 'requirement', 'required', 'wanted',
            'buy request', 'buy_request' => ['requirement'],
            default => [$value],
        };
    }

    /**
     * @param  array<int, string>  $normalizedTypes
     * @return array<int, string>
     */
    private function listingTypeAliases(array $normalizedTypes): array
    {
        $aliases = [];

        foreach ($normalizedTypes as $type) {
            $typeAliases = match ($type) {
                'sale' => ['sale', 'for sale'],
                'rent' => ['rent', 'for rent'],
                'requirement' => [
                    'requirement',
                    'rent request',
                    'sale request',
                    'buy request',
                    'required',
                    'wanted',
                ],
                default => [$type],
            };

            foreach ($typeAliases as $alias) {
                $aliases[] = strtolower(trim($alias));
            }
        }

        return array_values(array_unique($aliases));
    }

    /**
     * Normalize listing model attributes for JSON (short keys, booleans for guests).
     */
    public function transformListingForResponse(Listing $listing, ?\App\Models\User $user): void
    {
        $avg = $listing->getAttribute('listing_reviews_avg_rating');
        $listing->setAttribute('avg_rating', $avg !== null ? round((float) $avg, 2) : null);
        $listing->makeHidden(['listing_reviews_avg_rating']);

        if (!$user) {
            $listing->setAttribute('is_favorited', false);
        } else {
            $listing->setAttribute('is_favorited', (bool) $listing->getAttribute('is_favorited'));
        }

        $listing->setAttribute('likes_count', (int) $listing->getAttribute('likes_count'));
        $listing->setAttribute('comments_count', (int) $listing->getAttribute('comments_count'));
        $listing->setAttribute('ratings_count', (int) $listing->getAttribute('ratings_count'));

        $externalMetrics = $this->metricsService->externalTotalsForListing($listing);
        $listing->setAttribute('views_count', $externalMetrics['views']['count']);
        $listing->setAttribute('clicks_count', $externalMetrics['clicks']['count']);
        $listing->setAttribute('leads_count', $externalMetrics['leads']['count']);

        if ($listing->relationLoaded('detail') && $listing->detail !== null) {
            $formData = $listing->detail->form_data;
            if (is_array($formData) && $formData !== []) {
                $listing->detail->setAttribute(
                    'form_data',
                    $this->formDataNormalizer->normalize($formData)
                );
            }
        }

        if ($listing->relationLoaded('creator') && $listing->creator !== null) {
            $this->transformCreatorForResponse($listing->creator);
        }
    }

    private function transformCreatorForResponse(\App\Models\User $creator): void
    {
        $creator->loadMissing(['brokerProfile', 'agency']);

        $accountType = $creator->account_type ?? 'personal';
        $agencyName = ($accountType === 'agency') ? ($creator->agency?->name) : null;

        $creator->setAttribute('agency_name', $agencyName);

        if ($accountType === 'agency' && $creator->relationLoaded('agency') && $creator->agency !== null) {
            $creator->agency->setAttribute('agency_name', $creator->agency->name);
        }

        if ($creator->relationLoaded('brokerProfile') && $creator->brokerProfile !== null) {
            $creator->brokerProfile->setAttribute('account_type', $accountType);
            $creator->brokerProfile->setAttribute('agency_name', $agencyName);
        }
    }

    public function transformPaginatorCollection(\Illuminate\Contracts\Pagination\LengthAwarePaginator $paginator, ?\App\Models\User $user): void
    {
        $paginator->getCollection()->transform(function (Listing $listing) use ($user) {
            $this->transformListingForResponse($listing, $user);

            return $listing;
        });
    }
}
