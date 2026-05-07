<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateListingsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('listings', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('created_by');
            $table->enum('listing_type', ['sale', 'rent', 'requirement']);
            $table->string('property_type')->nullable();
            $table->decimal('price', 15, 2)->nullable();
            $table->string('currency', 10)->default('AED');
            $table->decimal('size', 10, 2)->nullable();
            $table->unsignedTinyInteger('beds')->nullable();
            $table->unsignedTinyInteger('baths')->nullable();
            $table->string('area')->nullable();
            $table->string('city')->nullable();
            $table->string('project')->nullable();
            $table->string('developer')->nullable();
            $table->enum('status', ['active', 'sold', 'rented', 'expired'])->default('active');
            $table->boolean('is_off_plan')->default(false);
            $table->json('tags')->nullable();
            $table->unsignedBigInteger('views_count')->default(0);
            $table->unsignedBigInteger('saves_count')->default(0);
            $table->timestamp('expires_at')->nullable();
            $table->timestamps();

            $table->foreign('created_by')
                ->references('id')
                ->on('users')
                ->onDelete('cascade');

            $table->index(['listing_type', 'status']);
            $table->index(['city', 'area']);
            $table->index(['created_at']);
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('listings');
    }
}


