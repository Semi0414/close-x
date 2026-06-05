<?php

namespace Tests\Feature;

use App\Models\Listing;
use App\Models\ListingMedia;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
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

    public function test_update_with_form_data_images_key_triggers_sync_without_using_form_data_urls(): void
    {
        $user = $this->actingBroker();
        $listing = $this->listingWithMedia($user);

        Sanctum::actingAs($user);

        $this->postJson("/api/listings/{$listing->id}/update", [
            'form-data' => json_encode([
                'images' => ['http://localhost/storage/listing-media/keep.jpg'],
            ]),
            'images' => ['http://localhost/storage/listing-media/keep.jpg'],
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

    public function test_multipart_file_upload_then_explicit_empty_images_removes_uploaded_image(): void
    {
        Storage::fake('public');

        $user = $this->actingBroker();
        $listing = Listing::factory()->create(['created_by' => $user->id]);

        Sanctum::actingAs($user);

        $file = UploadedFile::fake()->image('new-listing.jpg');

        $this->post("/api/listings/{$listing->id}/update", [
            'images' => [$file],
        ])->assertOk();

        $this->assertSame(1, $listing->media()->where('type', 'image')->count());

        $this->post("/api/listings/{$listing->id}/update", [
            'images' => [],
        ])->assertOk();

        $this->assertSame(0, $listing->media()->where('type', 'image')->count());
    }

    public function test_multipart_remove_without_images_field_skips_sync_and_keeps_image(): void
    {
        Storage::fake('public');

        $user = $this->actingBroker();
        $listing = Listing::factory()->create(['created_by' => $user->id]);

        Sanctum::actingAs($user);

        $file = UploadedFile::fake()->image('new-listing.jpg');

        $this->post("/api/listings/{$listing->id}/update", [
            'images' => [$file],
        ])->assertOk();

        $this->assertSame(1, $listing->media()->where('type', 'image')->count());

        $this->post("/api/listings/{$listing->id}/update", [
            'price' => 1500000,
        ])->assertOk();

        $this->assertSame(1, $listing->media()->where('type', 'image')->count());
    }

    public function test_multipart_upload_via_posts_array_then_remove_with_empty_posts_images(): void
    {
        Storage::fake('public');

        $user = $this->actingBroker();
        $listing = Listing::factory()->create(['created_by' => $user->id]);

        Sanctum::actingAs($user);

        $file = UploadedFile::fake()->image('upload.jpg');

        $this->post("/api/listings/{$listing->id}/update", [
            'posts' => [
                0 => [
                    'images' => [$file],
                ],
            ],
        ])->assertOk();

        $this->assertSame(1, $listing->media()->where('type', 'image')->count());

        $this->post("/api/listings/{$listing->id}/update", [
            'posts' => [
                0 => [
                    'images' => [],
                ],
            ],
        ])->assertOk();

        $this->assertSame(0, $listing->media()->where('type', 'image')->count());
    }

    public function test_multipart_remove_with_stale_form_data_images_removes_uploaded_image(): void
    {
        Storage::fake('public');

        $user = $this->actingBroker();
        $listing = Listing::factory()->create(['created_by' => $user->id]);

        Sanctum::actingAs($user);

        $file = UploadedFile::fake()->image('new-listing.jpg');

        $this->post("/api/listings/{$listing->id}/update", [
            'images' => [$file],
        ])->assertOk();

        $mediaUrl = $listing->media()->first()->url;

        $this->post("/api/listings/{$listing->id}/update", [
            'form-data' => json_encode([
                'images' => [$mediaUrl],
            ]),
            'price' => 1500000,
        ])->assertOk();

        $this->assertSame(0, $listing->media()->where('type', 'image')->count());
    }

    public function test_multipart_remove_with_empty_form_data_images_removes_image(): void
    {
        Storage::fake('public');

        $user = $this->actingBroker();
        $listing = Listing::factory()->create(['created_by' => $user->id]);

        Sanctum::actingAs($user);

        $file = UploadedFile::fake()->image('new-listing.jpg');

        $this->post("/api/listings/{$listing->id}/update", [
            'images' => [$file],
        ])->assertOk();

        $this->post("/api/listings/{$listing->id}/update", [
            'form-data' => json_encode([
                'images' => [],
            ]),
            'price' => 1500000,
        ])->assertOk();

        $this->assertSame(0, $listing->media()->where('type', 'image')->count());
    }

    public function test_update_with_posts_images_ids_keeps_listed_and_deletes_omitted_from_listing_media(): void
    {
        $user = $this->actingBroker();
        $listing = $this->listingWithMedia($user);

        $keepMedia = $listing->media()->orderBy('order')->first();
        $removeMedia = $listing->media()->orderBy('order')->skip(1)->first();

        Sanctum::actingAs($user);

        $this->post("/api/listings/{$listing->id}/update", [
            'posts' => [
                0 => [
                    'images' => [(string) $keepMedia->id],
                ],
            ],
        ])->assertOk();

        $this->assertSame(1, $listing->media()->where('type', 'image')->count());
        $this->assertTrue($listing->media()->whereKey($keepMedia->id)->exists());
        $this->assertFalse($listing->media()->whereKey($removeMedia->id)->exists());
    }

    public function test_update_with_flat_posts_bracket_image_ids_syncs_listing_media(): void
    {
        $user = $this->actingBroker();
        $listing = $this->listingWithMedia($user);

        $keepMedia = $listing->media()->orderBy('order')->first();

        Sanctum::actingAs($user);

        $this->call('POST', "/api/listings/{$listing->id}/update", [
            "posts[0][images][]" => (string) $keepMedia->id,
        ])->assertOk();

        $this->assertSame(1, $listing->media()->where('type', 'image')->count());
        $this->assertTrue($listing->media()->whereKey($keepMedia->id)->exists());
    }

    public function test_update_with_empty_posts_images_ids_deletes_all_listing_media_rows(): void
    {
        $user = $this->actingBroker();
        $listing = $this->listingWithMedia($user);

        Sanctum::actingAs($user);

        $this->post("/api/listings/{$listing->id}/update", [
            'posts' => [
                0 => [
                    'images' => [],
                ],
            ],
        ])->assertOk();

        $this->assertSame(0, $listing->media()->where('type', 'image')->count());
    }

    public function test_update_with_remove_media_ids_removes_specific_image(): void
    {
        $user = $this->actingBroker();
        $listing = $this->listingWithMedia($user);

        Sanctum::actingAs($user);

        $removeId = $listing->media()->orderBy('order')->skip(1)->value('id');

        $this->postJson("/api/listings/{$listing->id}/update", [
            'remove_media_ids' => [$removeId],
        ])->assertOk();

        $this->assertSame(1, $listing->media()->where('type', 'image')->count());
        $this->assertStringContainsString(
            'keep.jpg',
            (string) $listing->media()->first()->getRawOriginal('url')
        );
    }
}
