<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateListingMediaTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('listing_media', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('listing_id');
            $table->enum('type', ['image', 'video', 'doc'])->default('image');
            $table->string('url');
            $table->unsignedInteger('order')->default(0);
            $table->timestamps();

            $table->foreign('listing_id')
                ->references('id')
                ->on('listings')
                ->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('listing_media');
    }
}


