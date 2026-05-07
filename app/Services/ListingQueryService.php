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
        if (!empty($filters['listing_type'])) {
            $query->where('listing_type', $filters['listing_type']);
        }

        if (!empty($filters['city'])) {
            $query->where('city', $filters['city']);
        }

        if (!empty($filters['area'])) {
            $query->where('area', 'like', '%' . $filters['area'] . '%');
        }

        if (!empty($filters['property_type'])) {
            $query->where('property_type', 'like', '%' . $filters['property_type'] . '%');
        }

        if (isset($filters['min_price']) && $filters['min_price'] !== '' && $filters['min_price'] !== null) {
            $query->where('price', '>=', $filters['min_price']);
        }

        if (isset($filters['max_price']) && $filters['max_price'] !== '' && $filters['max_price'] !== null) {
            $query->where('price', '<=', $filters['max_price']);
        }

        if (isset($filters['beds']) && $filters['beds'] !== '' && $filters['beds'] !== null) {
            $query->where('beds', $filters['beds']);
        }

        if (isset($filters['min_beds']) && $filters['min_beds'] !== '' && $filters['min_beds'] !== null) {
            $query->where('beds', '>=', $filters['min_beds']);
        }

        if (isset($filters['baths']) && $filters['baths'] !== '' && $filters['baths'] !== null) {
            $query->where('baths', $filters['baths']);
        }

        if (array_key_exists('is_off_plan', $filters) && $filters['is_off_plan'] !== null && $filters['is_off_plan'] !== '') {
            $query->where('is_off_plan', filter_var($filters['is_off_plan'], FILTER_VALIDATE_BOOLEAN));
        }

        if (array_key_exists('off_plan', $filters) && $filters['off_plan'] !== null && $filters['off_plan'] !== '') {
            $query->where('is_off_plan', (bool) (int) $filters['off_plan']);
        }

        $tags = $filters['tags'] ?? null;
        if (is_string($tags)) {
            $tags = array_filter(array_map('trim', explode(',', $tags)));
        }
        if (is_array($tags) && count($tags) > 0) {
            $query->where(function (Builder $q) use ($tags) {
                foreach ($tags as $tag) {
                    if (!is_string($tag) || $tag === '') {
                        continue;
                    }
                    $normalized = strtoupper($tag);
                    $q->orWhereJsonContains('tags', $normalized);
                }
            });
        }

        if (!empty($filters['keyword'])) {
            $rawKeyword = trim((string) $filters['keyword']);
            $keyword = '%' . str_replace(['%', '_'], ['\\%', '\\_'], $rawKeyword) . '%';
            $query->where(function (Builder $q) use ($keyword, $rawKeyword) {
                $q->where('property_type', 'like', $keyword)
                    ->orWhere('listing_type', 'like', $keyword)
                    ->orWhere('status', 'like', $keyword)
                    ->orWhere('area', 'like', $keyword)
                    ->orWhere('city', 'like', $keyword)
                    ->orWhere('project', 'like', $keyword)
                    ->orWhere('developer', 'like', $keyword)
                    ->orWhereHas('detail', function (Builder $dq) use ($keyword) {
                        $dq->where('notes', 'like', $keyword)
                            ->orWhere('additional_notes', 'like', $keyword)
                            ->orWhere('payment_plan', 'like', $keyword)
                            ->orWhere('ownership', 'like', $keyword)
                            ->orWhere('furnished', 'like', $keyword);
                    })
                    ->orWhereHas('creator', function (Builder $cq) use ($keyword) {
                        $cq->where('name', 'like', $keyword)
                            ->orWhere('first_name', 'like', $keyword)
                            ->orWhere('last_name', 'like', $keyword)
                            ->orWhere('phone', 'like', $keyword)
                            ->orWhere('email', 'like', $keyword)
                            ->orWhereHas('brokerProfile', function (Builder $bpq) use ($keyword) {
                                $bpq->where('company_name', 'like', $keyword)
                                    ->orWhere('bio', 'like', $keyword)
                                    ->orWhere('brn_number', 'like', $keyword);
                            });
                    })
                    ->orWhereHas('listingReviews', function (Builder $rq) use ($keyword) {
                        $rq->where('review_text', 'like', $keyword);
                    });
                if ($rawKeyword !== '') {
                    $q->orWhereJsonContains('tags', strtoupper($rawKeyword));
                }
            });
        }
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
