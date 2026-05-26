<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddClicksAndLeadsCountToListingsTable extends Migration
{
    public function up()
    {
        Schema::table('listings', function (Blueprint $table) {
            $table->unsignedBigInteger('clicks_count')->default(0)->after('views_count');
            $table->unsignedBigInteger('leads_count')->default(0)->after('clicks_count');
        });
    }

    public function down()
    {
        Schema::table('listings', function (Blueprint $table) {
            $table->dropColumn(['clicks_count', 'leads_count']);
        });
    }
}
