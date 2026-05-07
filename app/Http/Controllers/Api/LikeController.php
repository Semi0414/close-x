<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Comment;
use App\Models\Like;
use App\Models\Listing;
use App\Models\Post;
use Illuminate\Http\Request;

class LikeController extends Controller
{
    public function storeListing(Request $request, Listing $listing)
    {
        return $this->storeLike($request, 'listing', $listing->id);
    }

    public function destroyListing(Request $request, Listing $listing)
    {
        return $this->destroyLike($request, 'listing', $listing->id);
    }

    public function storePost(Request $request, Post $post)
    {
        return $this->storeLike($request, 'post', $post->id);
    }

    public function destroyPost(Request $request, Post $post)
    {
        return $this->destroyLike($request, 'post', $post->id);
    }

    public function storeComment(Request $request, Comment $comment)
    {
        return $this->storeLike($request, 'comment', $comment->id);
    }

    public function destroyComment(Request $request, Comment $comment)
    {
        return $this->destroyLike($request, 'comment', $comment->id);
    }

    private function storeLike(Request $request, string $type, int $id)
    {
        $user = $request->user();

        $like = Like::firstOrCreate([
            'user_id' => $user->id,
            'likeable_type' => $type,
            'likeable_id' => $id,
        ]);

        return response()->json([
            'liked' => true,
            'like_id' => $like->id,
        ], $like->wasRecentlyCreated ? 201 : 200);
    }

    private function destroyLike(Request $request, string $type, int $id)
    {
        $user = $request->user();

        $deleted = Like::where('user_id', $user->id)
            ->where('likeable_type', $type)
            ->where('likeable_id', $id)
            ->delete();

        return response()->json([
            'liked' => false,
            'removed' => (bool) $deleted,
        ]);
    }
}
