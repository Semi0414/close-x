<?php

namespace Database\Factories;

use App\Models\Listing;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

class ListingFactory extends Factory
{
    protected $model = Listing::class;

    public function definition()
    {
        return [
            'created_by' => User::factory(),
            'listing_type' => 'sale',
            'property_type' => 'Apartment',
            'price' => $this->faker->numberBetween(500000, 5_000_000),
            'currency' => 'AED',
            'size' => $this->faker->numberBetween(400, 4000),
            'beds' => $this->faker->numberBetween(1, 4),
            'baths' => $this->faker->numberBetween(1, 3),
            'area' => 'JLT',
            'city' => 'Dubai',
            'project' => null,
            'developer' => null,
            'status' => 'active',
            'marked_as' => null,
            'is_off_plan' => false,
            'tags' => ['NEW'],
            'views_count' => 0,
            'clicks_count' => 0,
            'leads_count' => 0,
            'saves_count' => 0,
            'expires_at' => now()->addMonth(),
        ];
    }
}
