<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class BrokerProfile extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'company_name',
        'bio',
        'brn_number',
        'experience_years',
        'verified',
        'is_active',
        'show_whatsapp',
    ];

    /**
     * The user that owns this broker profile.
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}


