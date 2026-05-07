<?php

namespace App\Providers;

use App\Models\Comment;
use App\Models\Listing;
use App\Models\Post;
use App\Models\User;
use Illuminate\Database\Eloquent\Relations\Relation;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     *
     * @return void
     */
    public function register()
    {
        //
    }

    /**
     * Bootstrap any application services.
     *
     * @return void
     */
    public function boot()
    {
        Relation::enforceMorphMap([
            'listing' => Listing::class,
            'post' => Post::class,
            'comment' => Comment::class,
            'user' => User::class,
        ]);
    }
}
