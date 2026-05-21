<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Comment;
use App\Models\Post;
use Illuminate\Http\Request;

class PostCommentController extends Controller
{
    public function index(Request $request, Post $post)
    {
        $query = Comment::with([
            'user:id,name,first_name,last_name,profile_photo',
            'replies' => function ($replyQuery) {
                $replyQuery
                    ->with('user:id,name,first_name,last_name,profile_photo')
                    ->withCount('likes')
                    ->orderBy('created_at');
            },
        ])
            ->withCount('likes')
            ->where('commentable_type', 'post')
            ->where('commentable_id', $post->id)
            ->whereNull('parent_id')
            ->orderByDesc('created_at');

        return $query->paginate(20);
    }

    public function store(Request $request, Post $post)
    {
        $user = $request->user();

        $data = $request->validate([
            'body' => 'required|string|max:5000',
            'parent_id' => 'nullable|exists:comments,id',
        ]);

        if (!empty($data['parent_id'])) {
            Comment::where('id', $data['parent_id'])
                ->where('commentable_type', 'post')
                ->where('commentable_id', $post->id)
                ->whereNull('parent_id')
                ->firstOrFail();
        }

        $payload = [
            'user_id' => $user->id,
            'commentable_type' => 'post',
            'commentable_id' => $post->id,
            'parent_id' => $data['parent_id'] ?? null,
            'body' => trim($data['body']),
        ];

        // Prevent immediate double-submit duplicates from clients.
        $comment = Comment::where('user_id', $payload['user_id'])
            ->where('commentable_type', $payload['commentable_type'])
            ->where('commentable_id', $payload['commentable_id'])
            ->where('parent_id', $payload['parent_id'])
            ->where('body', $payload['body'])
            ->where('created_at', '>=', now()->subSeconds(3))
            ->first();

        if (!$comment) {
            $comment = Comment::create($payload);
        }

        return response()->json(
            $comment->load(['user:id,name,first_name,last_name,profile_photo'])->loadCount('likes'),
            201
        );
    }
}
