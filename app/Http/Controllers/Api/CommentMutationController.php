<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Comment;
use Illuminate\Http\Request;

class CommentMutationController extends Controller
{
    public function update(Request $request, Comment $comment)
    {
        $user = $request->user();

        if ($comment->user_id !== $user->id) {
            abort(403, 'You cannot edit this comment.');
        }

        $data = $request->validate([
            'body' => 'required|string|max:5000',
        ]);

        $comment->update($data);

        return response()->json($comment->load(['user:id,name,first_name,last_name,profile_photo'])->loadCount('likes'));
    }

    public function destroy(Request $request, Comment $comment)
    {
        $user = $request->user();

        if ($comment->user_id !== $user->id) {
            abort(403, 'You cannot delete this comment.');
        }

        $comment->delete();

        return response()->json(['message' => 'Comment deleted.']);
    }
}
