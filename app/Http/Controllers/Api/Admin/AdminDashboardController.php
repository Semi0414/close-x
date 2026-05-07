<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\Listing;
use App\Models\User;
use Illuminate\Http\Request;

class AdminDashboardController extends Controller
{
    public function index()
    {
        $totalUsers = User::count();
        $totalListings = Listing::count();
        $activeListings = Listing::where('status', 'active')->count();
        $soldListings = Listing::where('status', 'sold')->count();
        $rentedListings = Listing::where('status', 'rented')->count();

        $mostActiveBrokers = User::withCount('listings')
            ->orderByDesc('listings_count')
            ->take(5)
            ->get();

        $mostSearchedAreas = Listing::selectRaw('city, area, COUNT(*) as listings_count')
            ->groupBy('city', 'area')
            ->orderByDesc('listings_count')
            ->take(5)
            ->get();

        return response()->json([
            'total_users' => $totalUsers,
            'total_listings' => $totalListings,
            'active_listings' => $activeListings,
            'sold_listings' => $soldListings,
            'rented_listings' => $rentedListings,
            'most_active_brokers' => $mostActiveBrokers,
            'most_searched_areas' => $mostSearchedAreas,
        ]);
    }
}


