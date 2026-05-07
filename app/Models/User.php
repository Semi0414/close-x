<?php

namespace App\Models;

use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',
        'first_name',
        'last_name',
        'email',
        'phone',
        'whatsapp',
        'google_id',
        'facebook_id',
        'apple_id',
        'role',
        'status',
        'language',
        'profile_photo',
        'phone_notifications',
        'messages_notifications',
        'whatsapp_notifications',
        'account_type',
        'profile_completion_percent',
        'password',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
        'last_active' => 'datetime',
        'phone_notifications' => 'boolean',
        'messages_notifications' => 'boolean',
        'whatsapp_notifications' => 'boolean',
        'profile_completion_percent' => 'integer',
    ];

    /**
     * Get the broker profile associated with the user.
     */
    public function brokerProfile()
    {
        return $this->hasOne(BrokerProfile::class);
    }

    /**
     * Get the agency that the user belongs to.
     */
    public function agency()
    {
        return $this->belongsTo(Agency::class);
    }

    /**
     * Listings created by the user.
     */
    public function listings()
    {
        return $this->hasMany(Listing::class, 'created_by');
    }

    /**
     * Listings favorited by the user.
     */
    public function favorites()
    {
        return $this->hasMany(Favorite::class);
    }
}
