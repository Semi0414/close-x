<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Favorite;
use App\Models\Listing;
use Illuminate\Http\Request;

class FavoriteController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();

        $favorites = Favorite::with('listing.detail', 'listing.media')
            ->where('user_id', $user->id)
            ->orderByDesc('created_at')
            ->get();

        return response()->json($favorites);
    }

    public function store(Request $request)
    {
        $user = $request->user();

        $data = $request->validate([
            'listing_id' => 'required|exists:listings,id',
        ]);

        $favorite = Favorite::firstOrCreate([
            'user_id' => $user->id,
            'listing_id' => $data['listing_id'],
        ]);

        if ($favorite->wasRecentlyCreated) {
            Listing::where('id', $data['listing_id'])->increment('saves_count');
        }

        return response()->json([
            'message' => $favorite->wasRecentlyCreated
                ? 'Listing added to favorites.'
                : 'Listing is already in favorites.',
            'favorited' => true,
            'favorite_id' => $favorite->id,
        ], $favorite->wasRecentlyCreated ? 201 : 200);
    }

    /**
     * Favorite a listing (explicit route).
     */
    public function storeForListing(Request $request, Listing $listing)
    {
        $user = $request->user();

        $favorite = Favorite::firstOrCreate([
            'user_id' => $user->id,
            'listing_id' => $listing->id,
        ]);

        if ($favorite->wasRecentlyCreated) {
            Listing::where('id', $listing->id)->increment('saves_count');
        }

        return response()->json([
            'message' => $favorite->wasRecentlyCreated
                ? 'Listing added to favorites.'
                : 'Listing is already in favorites.',
            'favorited' => true,
            'favorite_id' => $favorite->id,
        ], $favorite->wasRecentlyCreated ? 201 : 200);
    }

    public function destroy(Request $request, Listing $listing)
    {
        $user = $request->user();

        $deleted = Favorite::where('user_id', $user->id)
            ->where('listing_id', $listing->id)
            ->delete();

        if ($deleted) {
            Listing::where('id', $listing->id)
                ->where('saves_count', '>', 0)
                ->decrement('saves_count');
        }

        return response()->json([
            'message' => $deleted
                ? 'Listing removed from favorites.'
                : 'Listing was not in favorites.',
            'favorited' => false,
        ]);
    }
}


