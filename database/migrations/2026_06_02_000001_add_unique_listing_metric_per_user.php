<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddUniqueListingMetricPerUser extends Migration
{
    public function up()
    {
        Schema::table('listing_metric_events', function (Blueprint $table) {
            $table->unique(['listing_id', 'user_id', 'metric'], 'listing_metric_events_listing_user_metric_unique');
        });
    }

    public function down()
    {
        Schema::table('listing_metric_events', function (Blueprint $table) {
            $table->dropUnique('listing_metric_events_listing_user_metric_unique');
        });
    }
}
