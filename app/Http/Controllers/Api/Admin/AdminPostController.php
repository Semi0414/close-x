<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\Post;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class AdminPostController extends Controller
{
    public function index()
    {
        return Post::with('creator')
            ->orderByDesc('is_pinned')
            ->orderByDesc('created_at')
            ->paginate(20);
    }

    public function store(Request $request)
    {
        $user = $request->user();

        $data = $request->validate([
            'title' => 'required|string|max:255',
            'content' => 'required|string',
            'visibility' => 'nullable|string|max:50',
            'is_pinned' => 'boolean',
            'images' => 'sometimes|array',
            'images.*' => 'nullable',
            'videos' => 'sometimes|array',
            'videos.*' => 'nullable',
        ]);

        $post = Post::create([
            'created_by' => $user->id,
            'title' => $data['title'],
            'content' => $data['content'],
            'visibility' => $data['visibility'] ?? 'all',
            'is_pinned' => $data['is_pinned'] ?? false,
            'images' => $this->resolvePostMedia($request, 'images', 'updates/images'),
            'videos' => $this->resolvePostMedia($request, 'videos', 'updates/videos'),
        ]);

        return response()->json($post, 201);
    }

    public function update(Request $request, Post $post)
    {
        $data = $request->validate([
            'title' => 'sometimes|string|max:255',
            'content' => 'sometimes|string',
            'visibility' => 'sometimes|string|max:50',
            'is_pinned' => 'sometimes|boolean',
            'images' => 'sometimes|array',
            'images.*' => 'nullable',
            'videos' => 'sometimes|array',
            'videos.*' => 'nullable',
        ]);

        if ($request->has('images') || $request->hasFile('images')) {
            $data['images'] = $this->resolvePostMedia($request, 'images', 'updates/images');
        }

        if ($request->has('videos') || $request->hasFile('videos')) {
            $data['videos'] = $this->resolvePostMedia($request, 'videos', 'updates/videos');
        }

        $post->fill($data);
        $post->save();

        return response()->json($post);
    }

    private function resolvePostMedia(Request $request, string $field, string $directory): array
    {
        if ($request->hasFile($field)) {
            $request->validate([
                $field => 'array',
                $field . '.*' => $field === 'images'
                    ? 'file|image|mimes:jpg,jpeg,png,webp|max:10240'
                    : 'file|mimetypes:video/mp4,video/quicktime,video/x-msvideo,video/x-matroska|max:51200',
            ]);

            $stored = [];
            foreach ($request->file($field, []) as $file) {
                if (!$file) {
                    continue;
                }
                $stored[] = Storage::url($file->store($directory, 'public'));
            }

            return $stored;
        }

        $incoming = $request->input($field, []);
        if (!is_array($incoming)) {
            return [];
        }

        return array_values(array_filter($incoming, function ($item) {
            return is_string($item) && trim($item) !== '';
        }));
    }

    public function destroy(Post $post)
    {
        $post->delete();

        return response()->json([
            'message' => 'Post deleted.',
        ]);
    }
}


