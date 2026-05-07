<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class ListingMedia extends Model
{
    use HasFactory;

    protected $fillable = [
        'listing_id',
        'type',
        'url',
        'order',
    ];

    /**
     * The listing this media belongs to.
     */
    public function listing()
    {
        return $this->belongsTo(Listing::class);
    }

    public function getUrlAttribute($value): ?string
    {
        if (!is_string($value) || $value === '') {
            return $value;
        }

        $request = request();
        if (!$request) {
            return $value;
        }

        $currentHost = (string) $request->getSchemeAndHttpHost();
        if ($currentHost === '') {
            return $value;
        }

        if (Str::startsWith($value, '/')) {
            return rtrim($currentHost, '/') . $value;
        }

        if (!preg_match('/^https?:\/\//i', $value)) {
            return rtrim($currentHost, '/') . '/' . ltrim($value, '/');
        }

        $parsed = parse_url($value);
        if (!is_array($parsed) || empty($parsed['host'])) {
            return $value;
        }

        $host = strtolower((string) $parsed['host']);
        $appHost = strtolower((string) parse_url((string) config('app.url'), PHP_URL_HOST));
        $shouldReplaceHost = in_array($host, ['localhost', '127.0.0.1'], true)
            || ($appHost !== '' && $host === $appHost);

        if (!$shouldReplaceHost) {
            return $value;
        }

        $path = $parsed['path'] ?? '';
        $query = isset($parsed['query']) ? '?' . $parsed['query'] : '';
        $fragment = isset($parsed['fragment']) ? '#' . $parsed['fragment'] : '';

        return rtrim($currentHost, '/') . $path . $query . $fragment;
    }
}


