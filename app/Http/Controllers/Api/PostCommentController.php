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
            'replies.user:id,name,first_name,last_name,profile_photo',
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
                ->firstOrFail();
        }

        $comment = Comment::create([
            'user_id' => $user->id,
            'commentable_type' => 'post',
            'commentable_id' => $post->id,
            'parent_id' => $data['parent_id'] ?? null,
            'body' => $data['body'],
        ]);

        return response()->json(
            $comment->load(['user:id,name,first_name,last_name,profile_photo'])->loadCount('likes'),
            201
        );
    }
}
