<?php

namespace App\Services;

use App\Models\Listing;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\Request;

class ListingQueryService
{
    /**
     * Base query for public active listings with common relations & aggregates.
     */
    public function baseListingQuery(Request $request, bool $activeOnly = true): Builder
    {
        $user = $request->user();

        $query = Listing::query()
            ->with(['creator.brokerProfile', 'media', 'detail']);

        if ($activeOnly) {
            $query->where('status', 'active');
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
        $filters = $request->all();
        $this->applyFiltersArray($query, $filters);

        return $query;
    }

    /**
     * @param  array<string, mixed>  $filters
     */
    public function applyFiltersArray(Builder $query, array $filters): void
    {
        if (!empty($filters['status'])) {
            $statusAliases = $this->listingTypeAliases(
                $this->normalizeListingTypeFilterValues((string) $filters['status'])
            );

            $query->whereHas('detail', function (Builder $detailQuery) use ($statusAliases) {
                $detailQuery->where(function (Builder $statusQuery) use ($statusAliases) {
                    foreach ($statusAliases as $alias) {
                        $statusQuery->orWhereRaw(
                            "LOWER(TRIM(JSON_UNQUOTE(JSON_EXTRACT(form_data, '$.status')))) = ?",
                            [$alias]
                        );
                    }
                });
            });
        }

        if (!empty($filters['listing_type']) && empty($filters['status'])) {
            $normalizedTypes = $this->normalizeListingTypeFilterValues((string) $filters['listing_type']);
            $typeAliases = $this->listingTypeAliases($normalizedTypes);
            $allTypeAliases = $this->listingTypeAliases(['sale', 'rent', 'requirement']);

            $query->where(function (Builder $typeQuery) use ($normalizedTypes, $typeAliases, $allTypeAliases) {
                $typeQuery->whereHas('detail', function (Builder $detailQuery) use ($typeAliases) {
                    $detailQuery->where(function (Builder $statusQuery) use ($typeAliases) {
                        foreach ($typeAliases as $alias) {
                            $statusQuery
                                ->orWhereRaw(
                                    "LOWER(TRIM(JSON_UNQUOTE(JSON_EXTRACT(form_data, '$.status')))) = ?",
                                    [$alias]
                                )
                                ->orWhereRaw(
                                    "LOWER(TRIM(JSON_UNQUOTE(JSON_EXTRACT(extra, '$.kind')))) = ?",
                                    [$alias]
                                );
                        }
                    });
                })->orWhere(function (Builder $fallbackTypeQuery) use ($normalizedTypes, $allTypeAliases) {
                    $fallbackTypeQuery
                        ->whereIn('listing_type', $normalizedTypes)
                        ->whereDoesntHave('detail', function (Builder $detailQuery) use ($allTypeAliases) {
                            $detailQuery->where(function (Builder $statusQuery) use ($allTypeAliases) {
                                foreach ($allTypeAliases as $alias) {
                                    $statusQuery
                                        ->orWhereRaw(
                                            "LOWER(TRIM(JSON_UNQUOTE(JSON_EXTRACT(form_data, '$.status')))) = ?",
                                            [$alias]
                                        )
                                        ->orWhereRaw(
                                            "LOWER(TRIM(JSON_UNQUOTE(JSON_EXTRACT(extra, '$.kind')))) = ?",
                                            [$alias]
                                        );
                                }
                            });
                        });
                });
            });
        }

        if (!empty($filters['city'])) {
            $query->whereRaw('LOWER(TRIM(city)) = ?', [strtolower(trim((string) $filters['city']))]);
        }

        if (!empty($filters['area'])) {
            $query->whereRaw('LOWER(TRIM(area)) = ?', [strtolower(trim((string) $filters['area']))]);
        }

        if (!empty($filters['property_type'])) {
            $query->whereRaw('LOWER(TRIM(property_type)) = ?', [strtolower(trim((string) $filters['property_type']))]);
        }

        if (isset($filters['min_price']) && $filters['min_price'] !== '' && $filters['min_price'] !== null) {
            $query->where(function (Builder $priceQuery) use ($filters) {
                $priceQuery->where('price', '>=', $filters['min_price'])
                    ->orWhereHas('detail', function (Builder $detailQuery) use ($filters) {
                        $detailQuery->whereRaw(
                            "CAST(JSON_UNQUOTE(JSON_EXTRACT(form_data, '$.price.sp')) AS DECIMAL(15,2)) >= ?",
                            [(float) $filters['min_price']]
                        );
                    });
            });
        }

        if (isset($filters['max_price']) && $filters['max_price'] !== '' && $filters['max_price'] !== null) {
            $query->where(function (Builder $priceQuery) use ($filters) {
                $priceQuery->where('price', '<=', $filters['max_price'])
                    ->orWhereHas('detail', function (Builder $detailQuery) use ($filters) {
                        $detailQuery->whereRaw(
                            "CAST(JSON_UNQUOTE(JSON_EXTRACT(form_data, '$.price.sp')) AS DECIMAL(15,2)) <= ?",
                            [(float) $filters['max_price']]
                        );
                    });
            });
        }

        if (isset($filters['beds']) && $filters['beds'] !== '' && $filters['beds'] !== null) {
            $query->where(function (Builder $bedsQuery) use ($filters) {
                $bedsQuery->where('beds', $filters['beds'])
                    ->orWhereHas('detail', function (Builder $detailQuery) use ($filters) {
                        $detailQuery->whereRaw(
                            "CAST(JSON_UNQUOTE(JSON_EXTRACT(form_data, '$.rooms.bedrooms')) AS UNSIGNED) = ?",
                            [(int) $filters['beds']]
                        );
                    });
            });
        }

        if (isset($filters['min_beds']) && $filters['min_beds'] !== '' && $filters['min_beds'] !== null) {
            $query->where(function (Builder $bedsQuery) use ($filters) {
                $bedsQuery->where('beds', '>=', $filters['min_beds'])
                    ->orWhereHas('detail', function (Builder $detailQuery) use ($filters) {
                        $detailQuery->whereRaw(
                            "CAST(JSON_UNQUOTE(JSON_EXTRACT(form_data, '$.rooms.bedrooms')) AS UNSIGNED) >= ?",
                            [(int) $filters['min_beds']]
                        );
                    });
            });
        }

        if (isset($filters['baths']) && $filters['baths'] !== '' && $filters['baths'] !== null) {
            $query->where('baths', $filters['baths']);
        }

        if (array_key_exists('is_off_plan', $filters) && $filters['is_off_plan'] !== null && $filters['is_off_plan'] !== '') {
            $query->where('is_off_plan', filter_var($filters['is_off_plan'], FILTER_VALIDATE_BOOLEAN));
        }

        if (array_key_exists('off_plan', $filters) && $filters['off_plan'] !== null && $filters['off_plan'] !== '') {
            $query->where('is_off_plan', filter_var($filters['off_plan'], FILTER_VALIDATE_BOOLEAN, FILTER_NULL_ON_FAILURE) ?? (bool) (int) $filters['off_plan']);
        }

        $tags = $filters['tags'] ?? null;
        if (is_string($tags)) {
            $tags = array_filter(array_map('trim', explode(',', $tags)));
        }
        if (is_array($tags) && count($tags) > 0) {
            foreach ($tags as $tag) {
                if (!is_string($tag) || $tag === '') {
                    continue;
                }
                $normalized = strtoupper(trim($tag));
                $query->whereJsonContains('tags', $normalized);
            }
        }

        if (!empty($filters['keyword'])) {
            $rawKeyword = trim((string) $filters['keyword']);
            $keyword = '%' . str_replace(['%', '_'], ['\\%', '\\_'], strtolower($rawKeyword)) . '%';

            $query->where(function (Builder $q) use ($keyword, $rawKeyword) {
                $q->whereRaw('LOWER(property_type) LIKE ?', [$keyword])
                    ->orWhereRaw('LOWER(listing_type) LIKE ?', [$keyword])
                    ->orWhereRaw('LOWER(status) LIKE ?', [$keyword])
                    ->orWhereRaw('LOWER(area) LIKE ?', [$keyword])
                    ->orWhereRaw('LOWER(city) LIKE ?', [$keyword])
                    ->orWhereRaw('LOWER(project) LIKE ?', [$keyword])
                    ->orWhereRaw('LOWER(developer) LIKE ?', [$keyword])
                    ->orWhereHas('detail', function (Builder $dq) use ($keyword) {
                        $dq->whereRaw('LOWER(COALESCE(notes, "")) LIKE ?', [$keyword])
                            ->orWhereRaw('LOWER(COALESCE(additional_notes, "")) LIKE ?', [$keyword])
                            ->orWhereRaw('LOWER(COALESCE(payment_plan, "")) LIKE ?', [$keyword])
                            ->orWhereRaw('LOWER(COALESCE(ownership, "")) LIKE ?', [$keyword])
                            ->orWhereRaw('LOWER(COALESCE(furnished, "")) LIKE ?', [$keyword])
                            ->orWhereRaw('LOWER(COALESCE(JSON_UNQUOTE(JSON_EXTRACT(form_data, "$.title")), "")) LIKE ?', [$keyword])
                            ->orWhereRaw('LOWER(COALESCE(JSON_UNQUOTE(JSON_EXTRACT(form_data, "$.status")), "")) LIKE ?', [$keyword])
                            ->orWhereRaw('LOWER(COALESCE(JSON_UNQUOTE(JSON_EXTRACT(form_data, "$.property_type")), "")) LIKE ?', [$keyword])
                            ->orWhereRaw('LOWER(COALESCE(JSON_UNQUOTE(JSON_EXTRACT(form_data, "$.plot_location")), "")) LIKE ?', [$keyword])
                            ->orWhereRaw('LOWER(COALESCE(JSON_UNQUOTE(JSON_EXTRACT(extra, "$.kind")), "")) LIKE ?', [$keyword]);
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

                if ($rawKeyword !== '') {
                    $q->orWhereJsonContains('tags', strtoupper($rawKeyword));
                    $q->orWhereHas('detail', function (Builder $dq) use ($rawKeyword) {
                        $dq->whereRaw('JSON_SEARCH(form_data, "one", ?, NULL, "$.tags[*]") IS NOT NULL', [$rawKeyword]);
                    });
                }
            });
        }
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
            'rent request', 'sale request', 'requirement', 'required', 'wanted' => ['requirement'],
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
                'requirement' => ['requirement', 'rent request', 'sale request', 'required', 'wanted'],
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
    }

    public function transformPaginatorCollection(\Illuminate\Contracts\Pagination\LengthAwarePaginator $paginator, ?\App\Models\User $user): void
    {
        $paginator->getCollection()->transform(function (Listing $listing) use ($user) {
            $this->transformListingForResponse($listing, $user);

            return $listing;
        });
    }
}
