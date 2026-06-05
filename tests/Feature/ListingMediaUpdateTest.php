<?php

namespace Tests\Feature;

use App\Models\Listing;
use App\Models\ListingMedia;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class ListingMediaUpdateTest extends TestCase
{
    use RefreshDatabase;

    private function actingBroker(): User
    {
        return User::factory()->create(['status' => 'active']);
    }

    private function listingWithMedia(User $user): Listing
    {
        $listing = Listing::factory()->create(['created_by' => $user->id]);

        ListingMedia::create([
            'listing_id' => $listing->id,
            'type' => 'image',
            'url' => '/storage/listing-media/keep.jpg',
            'order' => 0,
        ]);

        ListingMedia::create([
            'listing_id' => $listing->id,
            'type' => 'image',
            'url' => '/storage/listing-media/remove.jpg',
            'order' => 1,
        ]);

        return $listing;
    }

    public function test_update_with_top_level_empty_images_array_removes_all_images(): void
    {
        $user = $this->actingBroker();
        $listing = $this->listingWithMedia($user);

        Sanctum::actingAs($user);

        $this->putJson("/api/listings/{$listing->id}", [
            'images' => [],
        ])->assertOk();

        $this->assertSame(0, $listing->media()->where('type', 'image')->count());
    }

    public function test_update_with_partial_image_list_removes_omitted_images(): void
    {
        $user = $this->actingBroker();
        $listing = $this->listingWithMedia($user);

        Sanctum::actingAs($user);

        $this->putJson("/api/listings/{$listing->id}", [
            'images' => ['http://localhost/storage/listing-media/keep.jpg'],
        ])->assertOk();

        $urls = $listing->media()->where('type', 'image')->orderBy('order')->pluck('url')->all();
        $this->assertCount(1, $urls);
        $this->assertStringContainsString('keep.jpg', $urls[0]);
    }

    public function test_update_with_form_data_images_syncs_listing_media(): void
    {
        $user = $this->actingBroker();
        $listing = $this->listingWithMedia($user);

        Sanctum::actingAs($user);

        $this->postJson("/api/listings/{$listing->id}/update", [
            'form-data' => json_encode([
                'images' => ['http://localhost/storage/listing-media/keep.jpg'],
            ]),
        ])->assertOk();

        $urls = $listing->media()->where('type', 'image')->orderBy('order')->pluck('url')->all();
        $this->assertCount(1, $urls);
        $this->assertStringContainsString('keep.jpg', $urls[0]);
    }

    public function test_update_with_media_objects_removes_omitted_images(): void
    {
        $user = $this->actingBroker();
        $listing = $this->listingWithMedia($user);

        Sanctum::actingAs($user);

        $this->putJson("/api/listings/{$listing->id}", [
            'images' => [[
                'id' => 1,
                'url' => 'http://localhost/storage/listing-media/keep.jpg',
                'type' => 'image',
            ]],
        ])->assertOk();

        $this->assertSame(1, $listing->media()->where('type', 'image')->count());
    }
}
