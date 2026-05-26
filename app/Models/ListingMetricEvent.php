<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ListingMetricEvent extends Model
{
    public const METRIC_VIEW = 'view';
    public const METRIC_CLICK = 'click';
    public const METRIC_LEAD = 'lead';

    protected $fillable = [
        'listing_id',
        'user_id',
        'metric',
    ];

    public function listing(): BelongsTo
    {
        return $this->belongsTo(Listing::class);
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
