<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Post extends Model
{
    use HasFactory;

    protected $fillable = [
        'created_by',
        'title',
        'content',
        'is_pinned',
        'visibility',
        'images',
        'videos',
    ];

    protected $casts = [
        'is_pinned' => 'boolean',
        'images' => 'array',
        'videos' => 'array',
    ];

    /**
     * The user who created the post.
     */
    public function creator()
    {
        return $this->belongsTo(User::class, 'created_by');
    }

    public function comments()
    {
        return $this->morphMany(Comment::class, 'commentable');
    }

    public function likes()
    {
        return $this->morphMany(Like::class, 'likeable');
    }
}


