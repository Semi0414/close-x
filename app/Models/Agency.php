<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Agency extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'logo',
        'orn',
        'ded_license',
        'address',
        'attachments',
        'city',
        'email',
        'phone',
        'whatsapp',
    ];

    protected $casts = [
        'attachments' => 'array',
    ];

    /**
     * Users that belong to this agency.
     */
    public function users()
    {
        return $this->hasMany(User::class);
    }

    /**
     * Broker profiles through users if needed.
     */
    public function brokerProfiles()
    {
        return $this->hasManyThrough(BrokerProfile::class, User::class);
    }
}


