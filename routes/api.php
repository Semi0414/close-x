<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\AiListingController;
use App\Http\Controllers\Api\CommentMutationController;
use App\Http\Controllers\Api\FavoriteController;
use App\Http\Controllers\Api\LikeController;
use App\Http\Controllers\Api\ListingCommentController;
use App\Http\Controllers\Api\ListingController;
use App\Http\Controllers\Api\ListingFilterController;
use App\Http\Controllers\Api\ListingReviewController;
use App\Http\Controllers\Api\PostCommentController;
use App\Http\Controllers\Api\PostController;
use App\Http\Controllers\Api\ProfileController;
use App\Http\Controllers\Api\SavedSearchController;
use App\Http\Controllers\Api\Admin\AdminBrokerController;
use App\Http\Controllers\Api\Admin\AdminDashboardController;
use App\Http\Controllers\Api\Admin\AdminListingController;
use App\Http\Controllers\Api\Admin\AdminPostController;
use App\Http\Controllers\Api\AiProductListingGeneratorController;
use App\Http\Controllers\Api\OAuthController;
use App\Http\Controllers\Auth\GoogleController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Mobile app + admin panel ke saare JSON APIs yahan define honge.
|
*/

// Auth routes (public)
Route::prefix('auth')->group(function () {
    Route::post('/login', [AuthController::class, 'login']);
    Route::post('/signup', [AuthController::class, 'signup']);
    Route::post('/register', [AuthController::class, 'signup']);
    Route::post('/verify-otp', [AuthController::class, 'verifyOtp']);

    Route::get('auth/google', [GoogleController::class, 'redirect']);
    Route::get('auth/google/callback', [GoogleController::class, 'callback']);

    // OAuth (Google / Facebook / Apple) login + signup
    Route::post('/google', [OAuthController::class, 'google'])->middleware('throttle:10,1');
    Route::post('/facebook', [OAuthController::class, 'facebook'])->middleware('throttle:10,1');
    Route::post('/apple', [OAuthController::class, 'apple'])->middleware('throttle:10,1');

    // OAuth challenge (state + nonce) for CSRF protection
    Route::post('/oauth/challenge', [OAuthController::class, 'challenge'])->middleware('throttle:10,1');
});
// Backward-compatible alias for older clients.
Route::post('/login', [AuthController::class, 'login']);
Route::post('/google-login', [GoogleController::class, 'googleLogin']);

// Public endpoint to trigger n8n workflow: AI Product Listing Generator
Route::post('/ai/product-listing-generator', [AiProductListingGeneratorController::class, 'generate']);

// Protected routes (broker/admin)
Route::middleware(['auth:sanctum', 'approved'])
    ->group(function () {
        // Auth
        Route::post('/auth/logout', [AuthController::class, 'logout']);

        // Profile & onboarding
        Route::get('/me', [ProfileController::class, 'me']);
        Route::get('/profile/edit', [ProfileController::class, 'getEditProfile']);
        Route::post('/profile/edit', [ProfileController::class, 'editProfile']);
        Route::put('/me/profile', [ProfileController::class, 'updateProfile']);
        Route::put('/me/agency', [ProfileController::class, 'updateAgency']);
        Route::delete('/me', [ProfileController::class, 'deleteAccount']);

        // Listings
        Route::get('/listings', [ListingController::class, 'index']);
        Route::get('/listings/my', [ListingController::class, 'myListings']);
        Route::get('/listings/add-post', [ListingController::class, 'addPostForm']);
        Route::get('/listings/filters', [ListingFilterController::class, 'index']);
        Route::get('/listings/search', [ListingController::class, 'search']);
        Route::post('/listings', [ListingController::class, 'store']);
        Route::post('/listings/add-post', [ListingController::class, 'store']);

        Route::post('/listings/{listing}/favorite', [FavoriteController::class, 'storeForListing']);
        Route::delete('/listings/{listing}/favorite', [FavoriteController::class, 'destroy']);

        Route::get('/listings/{listing}/reviews', [ListingReviewController::class, 'index']);
        Route::post('/listings/{listing}/reviews', [ListingReviewController::class, 'store']);
        Route::get('/listings/{listing}/reviews/me', [ListingReviewController::class, 'forCurrentUser']);
        Route::put('/listings/{listing}/reviews/me', [ListingReviewController::class, 'updateForCurrentUser']);
        Route::delete('/listings/{listing}/reviews/me', [ListingReviewController::class, 'destroyForCurrentUser']);

        Route::get('/listings/{listing}/comments', [ListingCommentController::class, 'index']);
        Route::post('/listings/{listing}/comments', [ListingCommentController::class, 'store']);

        Route::post('/listings/{listing}/likes', [LikeController::class, 'storeListing']);
        Route::delete('/listings/{listing}/likes', [LikeController::class, 'destroyListing']);

        Route::put('/listings/{listing}', [ListingController::class, 'update']);
        Route::delete('/listings/{listing}', [ListingController::class, 'destroy']);
        Route::post('/listings/{listing}/mark-sold', [ListingController::class, 'markSold']);
        Route::post('/listings/{listing}/mark-rented', [ListingController::class, 'markRented']);
        Route::get('/listings/{listing}', [ListingController::class, 'show']);

        // Favorites
        Route::get('/favorites', [FavoriteController::class, 'index']);
        Route::post('/favorites', [FavoriteController::class, 'store']);
        Route::delete('/favorites/{listing}', [FavoriteController::class, 'destroy']);

        // Saved searches
        Route::get('/saved-searches', [SavedSearchController::class, 'index']);
        Route::post('/saved-searches', [SavedSearchController::class, 'store']);
        Route::get('/saved-searches/{savedSearch}', [SavedSearchController::class, 'show']);
        Route::put('/saved-searches/{savedSearch}', [SavedSearchController::class, 'update']);
        Route::delete('/saved-searches/{savedSearch}', [SavedSearchController::class, 'destroy']);
        Route::post('/saved-searches/{savedSearch}/toggle-alerts', [SavedSearchController::class, 'toggleAlerts']);
        Route::get('/saved-searches/{savedSearch}/run', [SavedSearchController::class, 'run']);

        // AI listing parsing (text / image / voice)
        Route::post('/ai/listings/parse-text', [AiListingController::class, 'parseText']);
        Route::post('/ai/listings/parse-image', [AiListingController::class, 'parseImage']);
        Route::post('/ai/listings/parse-voice', [AiListingController::class, 'parseVoice']);

        // Updates / information feed
        Route::get('/updates', [PostController::class, 'index']);
        Route::post('/updates', [PostController::class, 'store']);
        Route::post('/updates/{post}/likes', [LikeController::class, 'storePost']);
        Route::delete('/updates/{post}/likes', [LikeController::class, 'destroyPost']);
        Route::get('/updates/{post}/comments', [PostCommentController::class, 'index']);
        Route::post('/updates/{post}/comments', [PostCommentController::class, 'store']);

        Route::put('/comments/{comment}', [CommentMutationController::class, 'update']);
        Route::delete('/comments/{comment}', [CommentMutationController::class, 'destroy']);
        Route::post('/comments/{comment}/likes', [LikeController::class, 'storeComment']);
        Route::delete('/comments/{comment}/likes', [LikeController::class, 'destroyComment']);
    });

// Admin panel APIs
// NOTE: auth middleware temporarily removed so you can test easily.
// Later you should wrap this group in ->middleware(['auth:sanctum', 'admin']).
Route::prefix('admin')
    ->group(function () {
        Route::get('/dashboard', [AdminDashboardController::class, 'index']);

        // Broker management
        Route::get('/brokers', [AdminBrokerController::class, 'index']);
        Route::put('/brokers/{user}/status', [AdminBrokerController::class, 'updateStatus']);
        Route::post('/brokers/{user}/toggle-verified', [AdminBrokerController::class, 'toggleVerified']);

        // Listing moderation
        Route::get('/listings', [AdminListingController::class, 'index']);
        Route::delete('/listings/{listing}', [AdminListingController::class, 'remove']);
        Route::post('/listings/{listing}/mark-inactive', [AdminListingController::class, 'markInactive']);

        // Updates / posts management
        Route::get('/posts', [AdminPostController::class, 'index']);
        Route::post('/posts', [AdminPostController::class, 'store']);
        Route::put('/posts/{post}', [AdminPostController::class, 'update']);
        Route::delete('/posts/{post}', [AdminPostController::class, 'destroy']);
    });



