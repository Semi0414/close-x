<?php

namespace Tests\Feature;

use App\Models\Comment;
use App\Models\Like;
use App\Models\Listing;
use App\Models\Post;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class ListingsSocialExpansionTest extends TestCase
{
    use RefreshDatabase;

    private function actingBroker(): User
    {
        $user = User::factory()->create(['status' => 'active']);

        return $user;
    }

    public function test_listings_index_includes_engagement_and_favorite_state()
    {
        $user = $this->actingBroker();
        $listing = Listing::factory()->create(['created_by' => $user->id]);

        Sanctum::actingAs($user);

        $response = $this->getJson('/api/listings');

        $response->assertStatus(200);
        $response->assertJsonStructure([
            'data' => [
                '*' => [
                    'id',
                    'is_favorited',
                    'avg_rating',
                    'ratings_count',
                    'comments_count',
                    'likes_count',
                    'views_count',
                ],
            ],
        ]);

        $row = collect($response->json('data'))->firstWhere('id', $listing->id);
        $this->assertNotNull($row);
        $this->assertFalse($row['is_favorited']);
    }

    public function test_explicit_favorite_and_unfavorite_adjust_saves_count()
    {
        $user = $this->actingBroker();
        $listing = Listing::factory()->create(['created_by' => $user->id, 'saves_count' => 0]);

        Sanctum::actingAs($user);

        $this->postJson("/api/listings/{$listing->id}/favorite")->assertStatus(201);
        $listing->refresh();
        $this->assertSame(1, (int) $listing->saves_count);

        $this->postJson("/api/listings/{$listing->id}/favorite")->assertStatus(200);
        $listing->refresh();
        $this->assertSame(1, (int) $listing->saves_count);

        $this->deleteJson("/api/listings/{$listing->id}/favorite")->assertStatus(200);
        $listing->refresh();
        $this->assertSame(0, (int) $listing->saves_count);
    }

    public function test_listings_filters_metadata_endpoint()
    {
        $user = $this->actingBroker();
        Sanctum::actingAs($user);

        $this->getJson('/api/listings/filters')
            ->assertStatus(200)
            ->assertJsonStructure(['cities', 'areas', 'property_types', 'beds', 'tags']);
    }

    public function test_listing_reviews_and_comments_and_likes()
    {
        $user = $this->actingBroker();
        $listing = Listing::factory()->create(['created_by' => $user->id]);

        Sanctum::actingAs($user);

        $this->postJson("/api/listings/{$listing->id}/reviews", [
            'rating' => 5,
            'review_text' => 'Great broker',
        ])->assertStatus(201);

        $this->getJson("/api/listings/{$listing->id}/reviews/me")->assertStatus(200);

        $this->postJson("/api/listings/{$listing->id}/comments", [
            'body' => 'Interested in viewing',
        ])->assertStatus(201);

        $this->postJson("/api/listings/{$listing->id}/likes")->assertStatus(201);

        $detail = $this->getJson("/api/listings/{$listing->id}")->assertStatus(200);
        $this->assertSame(5.0, (float) $detail->json('avg_rating'));
        $this->assertSame(1, (int) $detail->json('ratings_count'));
        $this->assertFalse((bool) $detail->json('is_favorited'));
    }

    public function test_saved_search_lifecycle_and_run()
    {
        $user = $this->actingBroker();
        Listing::factory()->create([
            'created_by' => $user->id,
            'city' => 'Dubai',
            'listing_type' => 'sale',
        ]);

        Sanctum::actingAs($user);

        $create = $this->postJson('/api/saved-searches', [
            'name' => 'Dubai sales',
            'filters' => ['city' => 'Dubai', 'listing_type' => 'sale'],
        ])->assertStatus(201);

        $id = $create->json('id');

        $this->putJson("/api/saved-searches/{$id}", [
            'name' => 'Updated',
        ])->assertStatus(200);

        $this->postJson("/api/saved-searches/{$id}/toggle-alerts")->assertStatus(200);

        $run = $this->getJson("/api/saved-searches/{$id}/run")->assertStatus(200);
        $this->assertGreaterThanOrEqual(1, count($run->json('data')));

        $this->deleteJson("/api/saved-searches/{$id}")->assertStatus(200);
    }

    public function test_updates_feed_like_and_comment()
    {
        $user = $this->actingBroker();
        $post = Post::factory()->create(['created_by' => $user->id]);

        Sanctum::actingAs($user);

        $feed = $this->getJson('/api/updates')->assertStatus(200);
        $this->assertArrayHasKey('data', $feed->json());

        $this->postJson("/api/updates/{$post->id}/likes")->assertStatus(201);
        $this->postJson("/api/updates/{$post->id}/comments", [
            'body' => 'Nice update',
        ])->assertStatus(201);

        $this->assertSame(1, Like::where('likeable_type', 'post')->where('likeable_id', $post->id)->count());
        $this->assertSame(1, Comment::where('commentable_type', 'post')->where('commentable_id', $post->id)->count());
    }
}
