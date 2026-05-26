<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Carbon;

class Listing extends Model
{
    use HasFactory;

    protected $fillable = [
        'created_by',
        'listing_type',
        'property_type',
        'price',
        'currency',
        'size',
        'beds',
        'baths',
        'area',
        'city',
        'project',
        'developer',
        'status',
        'marked_as',
        'is_off_plan',
        'tags',
        'views_count',
        'clicks_count',
        'leads_count',
        'saves_count',
        'expires_at',
    ];

    protected $casts = [
        'tags' => 'array',
        'is_off_plan' => 'boolean',
        'views_count' => 'integer',
        'clicks_count' => 'integer',
        'leads_count' => 'integer',
        'saves_count' => 'integer',
        'expires_at' => 'datetime',
    ];

    protected $appends = [
        'post_expiry',
    ];

    public function getPostExpiryAttribute(): ?string
    {
        $expiry = $this->expires_at;
        if (!$expiry instanceof Carbon) {
            return null;
        }

        return $expiry->toIso8601String();
    }

    /**
     * The broker (user) who created the listing.
     */
    public function creator()
    {
        return $this->belongsTo(User::class, 'created_by');
    }

    /**
     * Detailed information for the listing.
     */
    public function detail()
    {
        return $this->hasOne(ListingDetail::class);
    }

    /**
     * Media items associated with the listing.
     */
    public function media()
    {
        return $this->hasMany(ListingMedia::class);
    }

    /**
     * Favorites for this listing.
     */
    public function favorites()
    {
        return $this->hasMany(Favorite::class);
    }

    public function listingReviews()
    {
        return $this->hasMany(ListingReview::class);
    }

    public function comments()
    {
        return $this->morphMany(Comment::class, 'commentable');
    }

    public function likes()
    {
        return $this->morphMany(Like::class, 'likeable');
    }

    public function metricEvents()
    {
        return $this->hasMany(ListingMetricEvent::class);
    }
}


