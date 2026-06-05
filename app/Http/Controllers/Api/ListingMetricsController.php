<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Listing;
use App\Models\ListingMetricEvent;
use App\Services\ListingMetricsService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ListingMetricsController extends Controller
{
    public function __construct(
        private ListingMetricsService $metricsService
    ) {
    }

    public function getMyViews(Request $request): JsonResponse
    {
        return $this->myMetricResponse($request, 'views', ListingMetricEvent::METRIC_VIEW);
    }

    public function getMyClicks(Request $request): JsonResponse
    {
        return $this->myMetricResponse($request, 'clicks', ListingMetricEvent::METRIC_CLICK);
    }

    public function getMyLeads(Request $request): JsonResponse
    {
        return $this->myMetricResponse($request, 'leads', ListingMetricEvent::METRIC_LEAD);
    }

    public function getMyAll(Request $request): JsonResponse
    {
        return response()->json($this->metricsService->dashboardForUser($request->user()->id));
    }

    public function getViews(Request $request, Listing $listing): JsonResponse
    {
        return $this->listingMetricResponse($listing, 'views', ListingMetricEvent::METRIC_VIEW);
    }

    public function postViews(Request $request, Listing $listing): JsonResponse
    {
        return $this->recordMetric($request, $listing, ListingMetricEvent::METRIC_VIEW, 'view');
    }

    public function getClicks(Request $request, Listing $listing): JsonResponse
    {
        return $this->listingMetricResponse($listing, 'clicks', ListingMetricEvent::METRIC_CLICK);
    }

    public function postClicks(Request $request, Listing $listing): JsonResponse
    {
        return $this->recordMetric($request, $listing, ListingMetricEvent::METRIC_CLICK, 'click');
    }

    public function getLeads(Request $request, Listing $listing): JsonResponse
    {
        return $this->listingMetricResponse($listing, 'leads', ListingMetricEvent::METRIC_LEAD);
    }

    public function postLeads(Request $request, Listing $listing): JsonResponse
    {
        return $this->recordMetric($request, $listing, ListingMetricEvent::METRIC_LEAD, 'lead');
    }

    private function recordMetric(Request $request, Listing $listing, string $metric, string $label): JsonResponse
    {
        $actor = $request->user();
        $result = $this->metricsService->recordFromUser($listing, $actor->id, $metric);
        $listing->refresh();

        $message = match ($result['reason']) {
            'listing_owner' => 'Your own ' . $label . ' on your listing is not tracked.',
            'already_counted' => 'This ' . $label . ' was already counted for your account on this listing.',
            'new' => ucfirst($label) . ' recorded.',
            default => ucfirst($label) . ' was not recorded.',
        };

        return response()->json([
            'message' => $message,
            'recorded' => $result['recorded'],
            'reason' => $result['reason'],
            'listing_id' => $listing->id,
            'external_metrics' => $this->metricsService->externalTotalsForListing($listing),
            'my_listings_totals' => $this->metricsService->dashboardForUser(
                $listing->created_by === $actor->id ? $actor->id : $listing->created_by
            ),
        ]);
    }

    private function listingMetricResponse(Listing $listing, string $metricKey, string $metric): JsonResponse
    {
        $external = $this->metricsService->externalTotalsForListing($listing);

        return response()->json(array_merge(
            $external[$metricKey],
            [
                'listing_id' => $listing->id,
                'listing_owner_id' => $listing->created_by,
                'metric' => $metric,
                'source' => 'other_users_only',
                'excludes_listing_owner' => true,
            ]
        ));
    }

    private function myMetricResponse(Request $request, string $metricKey, string $metric): JsonResponse
    {
        $dashboard = $this->metricsService->dashboardForUser($request->user()->id);

        return response()->json(array_merge(
            $dashboard[$metricKey],
            [
                'user_id' => $request->user()->id,
                'metric' => $metric,
                'my_listings_count' => $dashboard['my_listings_count'],
                'my_updates_count' => $dashboard['my_updates_count'],
                'source' => 'other_users_only',
            ]
        ));
    }

}
