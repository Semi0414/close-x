<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateListingMetricEventsTable extends Migration
{
    public function up()
    {
        Schema::create('listing_metric_events', function (Blueprint $table) {
            $table->id();
            $table->foreignId('listing_id')->constrained('listings')->cascadeOnDelete();
            $table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            $table->enum('metric', ['view', 'click', 'lead']);
            $table->timestamps();

            $table->index(['listing_id', 'metric']);
            $table->index(['user_id', 'metric']);
        });
    }

    public function down()
    {
        Schema::dropIfExists('listing_metric_events');
    }
}
