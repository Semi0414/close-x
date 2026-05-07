<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Post;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class PostController extends Controller
{
    /**
     * Public / broker updates feed (social-style engagement fields).
     */
    public function index(Request $request)
    {
        $user = $request->user();

        $query = Post::with('creator.brokerProfile')
            ->withCount(['likes', 'comments'])
            ->orderByDesc('is_pinned')
            ->orderByDesc('created_at');

        if ($user) {
            $query->withExists([
                'likes as is_liked' => function ($q) use ($user) {
                    $q->where('user_id', $user->id);
                },
            ]);
        }

        $paginator = $query->paginate(20);

        $paginator->getCollection()->transform(function (Post $post) use ($user) {
            if (!$user) {
                $post->setAttribute('is_liked', false);
            } else {
                $post->setAttribute('is_liked', (bool) $post->getAttribute('is_liked'));
            }
            $post->setAttribute('likes_count', (int) $post->getAttribute('likes_count'));
            $post->setAttribute('comments_count', (int) $post->getAttribute('comments_count'));

            return $post;
        });

        return $paginator;
    }

    /**
     * Broker-created post (market update etc.).
     */
    public function store(Request $request)
    {
        $user = $request->user();

        $data = $request->validate([
            'title' => 'required|string|max:255',
            'content' => 'required|string',
            'images' => 'sometimes|array',
            'images.*' => 'nullable',
            'videos' => 'sometimes|array',
            'videos.*' => 'nullable',
        ]);

        $images = $this->resolvePostMedia($request, 'images', 'updates/images');
        $videos = $this->resolvePostMedia($request, 'videos', 'updates/videos');

        $post = Post::create([
            'created_by' => $user->id,
            'title' => $data['title'],
            'content' => $data['content'],
            'visibility' => 'all',
            'images' => $images,
            'videos' => $videos,
        ]);

        $post->load('creator.brokerProfile');
        $post->loadCount(['likes', 'comments']);
        $post->setAttribute('likes_count', (int) $post->likes_count);
        $post->setAttribute('comments_count', (int) $post->comments_count);
        $post->setAttribute('is_liked', false);

        return response()->json($post, 201);
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
}
