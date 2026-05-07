<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;

class ListingFilterController extends Controller
{
    /**
     * Filter metadata for mobile UI (locations, property types, beds, tags, etc.).
     */
    public function index(): JsonResponse
    {
        $cities = [
            'Dubai',
            'Abu Dhabi',
        ];

        $areas = [
            'Dubai' => [
                'Downtown Dubai', 'Dubai Marina', 'JLT', 'JBR', 'Business Bay', 'Palm Jumeirah',
                'Arabian Ranches', 'Dubai Hills', 'Mirdif', 'Deira', 'Bur Dubai', 'DIFC',
                'City Walk', 'Al Barsha', 'Motor City', 'Sports City', 'Silicon Oasis',
                'International City', 'Discovery Gardens', 'Dubai South', 'JVC', 'JVT',
            ],
            'Abu Dhabi' => [
                'Al Reem Island', 'Saadiyat Island', 'Yas Island', 'Al Raha Beach',
                'Corniche', 'Khalifa City', 'Mohammed Bin Zayed City', 'Al Mushrif',
            ],
        ];

        $allCitiesCombined = [];
        foreach ($areas as $cityAreas) {
            foreach ($cityAreas as $cityArea) {
                $allCitiesCombined[] = $cityArea;
            }
        }

        return response()->json([
            'cities' => $cities,
            'areas' => $areas,
            // Combined list for a single location dropdown.
            'all_cities' => $allCitiesCombined,
            'property_types' => [
                'Apartment',
                'Villa',
                'Townhouse',
                'Penthouse',
                'Studio',
                'Duplex',
                'Plot',
                'Office',
                'Retail',
                'Warehouse',
            ],
            'beds' => range(1, 10),
            'baths' => range(1, 10),
            'listing_types' => [
                ['value' => 'sale', 'label' => 'FOR SALE'],
                ['value' => 'rent', 'label' => 'FOR RENT'],
                ['value' => 'requirement', 'label' => 'REQUIREMENT'],
            ],
            'tags' => [
                'EXCLUSIVE',
                'URGENT',
                'HOT DEAL',
                'DISTRESS',
                'NEW',
                'VERIFIED',
                'MOTIVATED SELLER',
                'LUXURY',
                'SEA VIEW',
                'PARK VIEW',
                'HIGH ROI',
                'INVESTOR DEAL',
            ],
            'price' => [
                'currency_default' => 'AED',
                'min_hint' => 0,
                'max_hint' => 500_000_000,
            ],
            'off_plan' => [
                'options' => [
                    ['value' => 0, 'label' => 'READY'],
                    ['value' => 1, 'label' => 'OFF PLAN'],
                ],
            ],
        ]);
    }
}
