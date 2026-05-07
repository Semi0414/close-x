<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Listing;
use App\Models\ListingReview;
use Illuminate\Http\Request;

class ListingReviewController extends Controller
{
    public function index(Request $request, Listing $listing)
    {
        $reviews = ListingReview::with('user:id,name,first_name,last_name,profile_photo')
            ->where('listing_id', $listing->id)
            ->orderByDesc('created_at')
            ->paginate(20);

        return $reviews;
    }

    public function store(Request $request, Listing $listing)
    {
        $user = $request->user();

        $data = $request->validate([
            'rating' => 'required|integer|min:1|max:5',
            'review_text' => 'nullable|string|max:5000',
        ]);

        $already = ListingReview::where('listing_id', $listing->id)
            ->where('user_id', $user->id)
            ->exists();

        $review = ListingReview::updateOrCreate(
            [
                'listing_id' => $listing->id,
                'user_id' => $user->id,
            ],
            [
                'rating' => $data['rating'],
                'review_text' => $data['review_text'] ?? null,
            ]
        );

        return response()->json(
            $review->load('user:id,name,first_name,last_name,profile_photo'),
            $already ? 200 : 201
        );
    }

    public function forCurrentUser(Request $request, Listing $listing)
    {
        $user = $request->user();

        $review = ListingReview::with('user:id,name,first_name,last_name,profile_photo')
            ->where('listing_id', $listing->id)
            ->where('user_id', $user->id)
            ->first();

        if (!$review) {
            return response()->json(['message' => 'No review found for this listing.'], 404);
        }

        return response()->json($review);
    }

    public function updateForCurrentUser(Request $request, Listing $listing)
    {
        $user = $request->user();

        $review = ListingReview::where('listing_id', $listing->id)
            ->where('user_id', $user->id)
            ->firstOrFail();

        $data = $request->validate([
            'rating' => 'sometimes|integer|min:1|max:5',
            'review_text' => 'sometimes|nullable|string|max:5000',
        ]);

        $review->fill($data);
        $review->save();

        return response()->json($review->load('user:id,name,first_name,last_name,profile_photo'));
    }

    public function destroyForCurrentUser(Request $request, Listing $listing)
    {
        $user = $request->user();

        ListingReview::where('listing_id', $listing->id)
            ->where('user_id', $user->id)
            ->delete();

        return response()->json(['message' => 'Review removed.']);
    }
}
