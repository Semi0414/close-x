<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ListingDetail extends Model
{
    use HasFactory;

    protected $fillable = [
        'listing_id',
        'payment_plan',
        'ownership',
        'furnished',
        'commission',
        'roi',
        'notes',
        'additional_notes',
        'amenities',
        'form_data',
        'extra',
    ];

    protected $casts = [
        'amenities' => 'array',
        'form_data' => 'array',
        'extra' => 'array',
        'commission' => 'float',
        'roi' => 'float',
    ];

    /**
     * The listing that owns these details.
     */
    public function listing()
    {
        return $this->belongsTo(Listing::class);
    }
}


