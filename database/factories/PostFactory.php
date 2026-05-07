<?php

namespace Database\Factories;

use App\Models\Post;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

class PostFactory extends Factory
{
    protected $model = Post::class;

    public function definition()
    {
        return [
            'created_by' => User::factory(),
            'title' => $this->faker->sentence(4),
            'content' => $this->faker->paragraph(),
            'is_pinned' => false,
            'visibility' => 'all',
            'images' => [],
            'videos' => [],
        ];
    }
}
