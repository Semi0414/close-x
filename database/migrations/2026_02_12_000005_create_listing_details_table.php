<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateListingDetailsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('listing_details', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('listing_id');
            $table->text('payment_plan')->nullable();
            $table->string('ownership')->nullable();
            $table->enum('furnished', ['furnished', 'unfurnished', 'semi'])->nullable();
            $table->decimal('commission', 10, 2)->nullable();
            $table->decimal('roi', 5, 2)->nullable();
            $table->text('notes')->nullable();
            $table->json('amenities')->nullable();
            $table->json('extra')->nullable();
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
        Schema::dropIfExists('listing_details');
    }
}


