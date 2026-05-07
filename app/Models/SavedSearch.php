<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SavedSearch extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'name',
        'filters',
        'alerts_enabled',
    ];

    protected $casts = [
        'filters' => 'array',
        'alerts_enabled' => 'boolean',
    ];

    /**
     * The user who owns the saved search.
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}


