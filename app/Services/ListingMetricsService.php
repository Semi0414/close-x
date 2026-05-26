<?php

namespace App\Services;

use App\Models\Listing;
use App\Models\ListingMetricEvent;
use App\Models\Post;
use App\Support\CompactCountFormatter;
use Illuminate\Support\Facades\DB;

class ListingMetricsService
{
    /**
     * Record metric from another user (owner actions are ignored).
     */
    public function recordFromUser(Listing $listing, int $actorUserId, string $metric): bool
    {
        if ($listing->created_by === $actorUserId) {
            return false;
        }

        if (!in_array($metric, [
            ListingMetricEvent::METRIC_VIEW,
            ListingMetricEvent::METRIC_CLICK,
            ListingMetricEvent::METRIC_LEAD,
        ], true)) {
            return false;
        }

        ListingMetricEvent::create([
            'listing_id' => $listing->id,
            'user_id' => $actorUserId,
            'metric' => $metric,
        ]);

        $column = match ($metric) {
            ListingMetricEvent::METRIC_VIEW => 'views_count',
            ListingMetricEvent::METRIC_CLICK => 'clicks_count',
            ListingMetricEvent::METRIC_LEAD => 'leads_count',
            default => null,
        };

        if ($column !== null) {
            $listing->increment($column);
        }

        return true;
    }

    /**
     * External-user totals for all listings owned by a broker.
     *
     * @return array{
     *   views: array{count: int, count_formatted: string},
     *   clicks: array{count: int, count_formatted: string},
     *   leads: array{count: int, count_formatted: string}
     * }
     */
    public function externalTotalsForOwner(int $ownerId): array
    {
        $listingIds = Listing::query()
            ->where('created_by', $ownerId)
            ->pluck('id');

        if ($listingIds->isEmpty()) {
            return [
                'views' => CompactCountFormatter::payload(0),
                'clicks' => CompactCountFormatter::payload(0),
                'leads' => CompactCountFormatter::payload(0),
            ];
        }

        $rows = ListingMetricEvent::query()
            ->whereIn('listing_id', $listingIds)
            ->where('user_id', '!=', $ownerId)
            ->select('metric', DB::raw('COUNT(*) as total'))
            ->groupBy('metric')
            ->pluck('total', 'metric');

        return [
            'views' => CompactCountFormatter::payload((int) ($rows[ListingMetricEvent::METRIC_VIEW] ?? 0)),
            'clicks' => CompactCountFormatter::payload((int) ($rows[ListingMetricEvent::METRIC_CLICK] ?? 0)),
            'leads' => CompactCountFormatter::payload((int) ($rows[ListingMetricEvent::METRIC_LEAD] ?? 0)),
        ];
    }

    /**
     * External-user totals for a single listing.
     *
     * @return array{
     *   views: array{count: int, count_formatted: string},
     *   clicks: array{count: int, count_formatted: string},
     *   leads: array{count: int, count_formatted: string}
     * }
     */
    public function externalTotalsForListing(Listing $listing): array
    {
        $ownerId = (int) $listing->created_by;

        $rows = ListingMetricEvent::query()
            ->where('listing_id', $listing->id)
            ->where('user_id', '!=', $ownerId)
            ->select('metric', DB::raw('COUNT(*) as total'))
            ->groupBy('metric')
            ->pluck('total', 'metric');

        return [
            'views' => CompactCountFormatter::payload((int) ($rows[ListingMetricEvent::METRIC_VIEW] ?? 0)),
            'clicks' => CompactCountFormatter::payload((int) ($rows[ListingMetricEvent::METRIC_CLICK] ?? 0)),
            'leads' => CompactCountFormatter::payload((int) ($rows[ListingMetricEvent::METRIC_LEAD] ?? 0)),
        ];
    }

    /**
     * Total listings created by user (all statuses: active, expired, sold/rented marked, etc.).
     */
    public function allListingsCountForUser(int $userId): int
    {
        return Listing::query()
            ->where('created_by', $userId)
            ->count();
    }

    /**
     * Dashboard payload for /listings/my/metrics.
     *
     * @return array<string, mixed>
     */
    public function dashboardForUser(int $userId): array
    {
        $external = $this->externalTotalsForOwner($userId);

        return [
            'user_id' => $userId,
            'my_listings_count' => CompactCountFormatter::payload(
                $this->allListingsCountForUser($userId)
            ),
            'my_updates_count' => CompactCountFormatter::payload(
                Post::query()->where('created_by', $userId)->count()
            ),
            'views' => $external['views'],
            'clicks' => $external['clicks'],
            'leads' => $external['leads'],
            'note' => 'Views, clicks, and leads exclude your own activity on your listings.',
        ];
    }

    /**
     * @deprecated Use externalTotalsForOwner() for owner dashboards.
     */
    public function totalsForUser(int $userId): array
    {
        return $this->externalTotalsForOwner($userId);
    }
}
