<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Comment;
use App\Models\Listing;
use Illuminate\Http\Request;

class ListingCommentController extends Controller
{
    public function index(Request $request, Listing $listing)
    {
        $query = Comment::with([
            'user:id,name,first_name,last_name,profile_photo',
            'replies.user:id,name,first_name,last_name,profile_photo',
        ])
            ->withCount('likes')
            ->where('commentable_type', 'listing')
            ->where('commentable_id', $listing->id)
            ->whereNull('parent_id')
            ->orderByDesc('created_at');

        return $query->paginate(20);
    }

    public function store(Request $request, Listing $listing)
    {
        $user = $request->user();

        $data = $request->validate([
            'body' => 'required|string|max:5000',
            'parent_id' => 'nullable|exists:comments,id',
        ]);

        if (!empty($data['parent_id'])) {
            Comment::where('id', $data['parent_id'])
                ->where('commentable_type', 'listing')
                ->where('commentable_id', $listing->id)
                ->firstOrFail();
        }

        $comment = Comment::create([
            'user_id' => $user->id,
            'commentable_type' => 'listing',
            'commentable_id' => $listing->id,
            'parent_id' => $data['parent_id'] ?? null,
            'body' => $data['body'],
        ]);

        return response()->json(
            $comment->load(['user:id,name,first_name,last_name,profile_photo'])->loadCount('likes'),
            201
        );
    }
}
