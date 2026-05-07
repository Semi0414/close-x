<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\Listing;
use Illuminate\Http\Request;
use Carbon\Carbon;

class AdminListingController extends Controller
{
    public function index(Request $request)
    {
        $query = Listing::with([
            'creator.brokerProfile',
            'creator.agency',
            'detail',
            'media',
        ]);

        if ($request->filled('user_id')) {
            $query->where('created_by', (int) $request->input('user_id'));
        }

        $query->orderByDesc('created_at');
        $requestedPage = max(1, (int) $request->query('page', 1));
        $paginator = $query->paginate(20, ['*'], 'page', $requestedPage);
        if (count($paginator->items()) === 0 && $requestedPage > 1 && $paginator->lastPage() > 0) {
            $paginator = $query->paginate(20, ['*'], 'page', $paginator->lastPage());
        }

        $listings = $paginator->getCollection()->map(function (Listing $listing) {
            $creator = $listing->creator;
            $profile = optional($creator)->brokerProfile;

            $listingTags = (array) ($listing->tags ?? []);
            // Normalize tags for strict matching
            $listingTags = array_values(array_filter(array_map(function ($t) {
                return is_string($t) ? trim($t) : $t;
            }, $listingTags), fn ($t) => $t !== null && $t !== ''));

            $hasRentRequestTag =
                in_array('RENT REQUEST', $listingTags, true) ||
                in_array('RENT_REQUEST', $listingTags, true);

            $kind = match ($listing->listing_type) {
                'sale' => 'sale',
                'rent' => 'rent',
                'requirement' => $hasRentRequestTag ? 'rent_request' : 'required',
                default => $listing->listing_type,
            };

            $priceValue = $listing->price !== null ? (float) $listing->price : null;
            $priceText = null;
            $priceUnit = null;
            $compactPrice = $this->formatPriceCompact($priceValue, $listing->currency ?? 'AED');

            if ($priceValue !== null && $compactPrice !== null) {
                if ($listing->listing_type === 'rent') {
                    $priceText = $compactPrice . ' / yearly';
                    $priceUnit = 'yearly';
                } elseif ($listing->listing_type === 'requirement') {
                    if ($kind === 'rent_request') {
                        $priceText = 'Up to ' . $compactPrice . ' / year';
                        $priceUnit = 'yearly';
                    } else {
                        $priceText = 'Up to ' . $compactPrice;
                    }
                } else {
                    // sale
                    $priceText = $compactPrice;
                }
            }

            $areaText = $listing->listing_type === 'requirement'
                ? 'Requirement only'
                : ($listing->size
                    ? number_format((float) $listing->size, 0, '.', ',') . ' sq ft'
                    : null);

            $typeTag = match ($kind) {
                'sale' => 'FOR SALE',
                'rent' => 'FOR RENT',
                'required' => 'REQUIRED',
                'rent_request' => 'RENT REQUEST',
                default => null,
            };

            $tagsOrdered = [];
            $shouldAddNew = $listing->created_at
                && $listing->created_at->gt(now()->subDays(7))
                && in_array($listing->listing_type, ['sale', 'rent'], true);

            if ($shouldAddNew) {
                $tagsOrdered[] = 'NEW';
            }
            if ($typeTag) {
                $tagsOrdered[] = $typeTag;
            }
            foreach ($listingTags as $t) {
                if (!in_array($t, $tagsOrdered, true)) {
                    $tagsOrdered[] = $t;
                }
            }

            $detail = $listing->detail;
            $detailExtra = is_array($detail?->extra) ? $detail->extra : [];

            $customKind = isset($detailExtra['kind']) && is_string($detailExtra['kind'])
                ? trim($detailExtra['kind'])
                : null;

            $aiVerified = (bool) ($detailExtra['ai_verified'] ?? false);
            $aiExtracted = null;
            if ($aiVerified && $detail) {
                $aiExtracted = [
                    'currentStatus'  => $listing->status === 'active' ? 'Available' : ucfirst($listing->status),
                    'buildStatus'    => $listing->is_off_plan ? 'Off Plan' : 'Ready',
                    'paymentPlan'    => $detail->payment_plan,
                    'serviceCharges' => $detailExtra['service_charges'] ?? null,
                    'roiPotential'   => $detail->roi ? rtrim(rtrim((string) $detail->roi, '0'), '.') . '%' : null,
                    'completionDate' => $detailExtra['completion_date'] ?? null,
                ];
            }

            $map = null;
            if ($detail && isset($detailExtra['lat'], $detailExtra['lng'])) {
                $map = [
                    'lat' => (float) $detailExtra['lat'],
                    'lng' => (float) $detailExtra['lng'],
                ];
            }

            $description = optional($detail)->notes;

            $budgetLabel = null;
            if ($kind === 'required' && $priceText) {
                $budgetLabel = 'Budget • ' . $priceText;
            } elseif ($kind === 'rent_request' && $compactPrice) {
                $budgetLabel = 'Budget • Up to ' . $compactPrice . '/year';
            }

            $timelineLabel = null;
            $timelineRaw = $detailExtra['timeline_label'] ?? null;
            if ($timelineRaw) {
                $timelineRaw = (string) $timelineRaw;
                $timelineLabel = str_contains($timelineRaw, 'Timeline •')
                    ? $timelineRaw
                    : 'Timeline • ' . $timelineRaw;
            }

            $locationParts = array_values(array_filter([
                $listing->area ?: null,
                $listing->city ?: null,
            ]));
            $location = implode(', ', $locationParts);

            $allImages = $listing->media
                ->where('type', 'image')
                ->sortBy('order')
                ->pluck('url')
                ->values()
                ->all();
            $imageCount = count($allImages);

            $agencyName = optional($creator)->agency?->name ?: $profile?->company_name ?: null;
            $agentName = $creator?->name ?? null;
            $agentSubtitle = $profile?->company_name ?: 'Freelance Agent';

            return [
                'id' => (string) $listing->id,
                'kind' => $customKind !== '' ? $customKind : $kind,
                'title' => $listing->property_type ?: ('Listing #' . $listing->id),
                'expires_at' => optional($listing->expires_at)?->toIso8601String(),
                'post_expiry' => optional($listing->expires_at)?->toIso8601String(),
                'location' => $location,
                'price' => $priceText,
                'priceUnit' => $priceUnit,
                'off_plan' => (int) (bool) $listing->is_off_plan,
                'beds' => $listing->beds,
                'baths' => $listing->baths,
                'area' => $areaText,
                'tags' => $tagsOrdered,
                'description' => $description,
                'notes' => $detail?->notes,
                'additional_notes' => $detail?->additional_notes,
                'form-data' => $detail?->form_data ?? ($detailExtra['form-data'] ?? null),
                'budgetLabel' => $budgetLabel,
                'timelineLabel' => $timelineLabel,
                'agency' => $agencyName,
                'agencyImage' => $this->toAbsoluteMediaUrl(optional($creator?->agency)->logo),
                'postedAgo' => $this->formatPostedAgo($listing->created_at),
                'agentName' => $agentName,
                'agentPhone' => $creator?->phone,
                'agentImage' => $this->toAbsoluteMediaUrl($creator?->profile_photo),
                'agentSubtitle' => $agentSubtitle,
                'phone_notifications' => (int) (bool) ($creator?->phone_notifications ?? false),
                'messages_notifications' => (int) (bool) ($creator?->messages_notifications ?? false),
                'whatsapp_notifications' => (int) (bool) ($creator?->whatsapp_notifications ?? false),
                'details' => [
                    'images' => $allImages,
                    'imageCount' => $imageCount,
                    'stats' => [
                        'views' => (int) $listing->views_count,
                        'saves' => (int) $listing->saves_count,
                        'aiVerified' => $aiVerified,
                    ],
                    'aiExtracted' => $aiExtracted,
                    'map' => $map,
                ],
            ];
        })->values();

        return response()->json([
            'listings' => $listings,
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

    public function remove(Listing $listing)
    {
        $listing->delete();

        return response()->json([
            'message' => 'Listing removed.',
        ]);
    }

    public function markInactive(Listing $listing)
    {
        $listing->status = 'expired';
        $listing->save();

        return response()->json($listing);
    }

    private function formatPriceCompact(?float $price, string $currency): ?string
    {
        if ($price === null) {
            return null;
        }

        // sale me example format: 8.8M AED
        // rent me example format: 65k AED
        if ($price >= 1_000_000) {
            $m = $price / 1_000_000;
            $formatted = rtrim(rtrim(number_format($m, 1, '.', ''), '0'), '.');
            return $formatted . 'M ' . $currency;
        }

        if ($price >= 1_000) {
            $k = (int) round($price / 1_000);
            return $k . 'k ' . $currency;
        }

        return number_format($price, 0, '.', ',') . ' ' . $currency;
    }

    private function formatPostedAgo(?Carbon $createdAt): ?string
    {
        if (!$createdAt) {
            return null;
        }
        
        return 'Posted ' . $createdAt->diffForHumans();
    }

    private function toAbsoluteMediaUrl(?string $path): ?string
    {
        if (!$path) {
            return null;
        }

        if (preg_match('/^https?:\/\//i', $path)) {
            return $path;
        }

        return url($path);
    }
}

