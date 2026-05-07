<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Favorite extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'listing_id',
    ];

    /**
     * The user who favorited the listing.
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * The listing that was favorited.
     */
    public function listing()
    {
        return $this->belongsTo(Listing::class);
    }
}


