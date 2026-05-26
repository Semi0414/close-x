<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

class AddMarkedAsToListingsTable extends Migration
{
    public function up()
    {
        Schema::table('listings', function (Blueprint $table) {
            $table->string('marked_as', 20)->nullable()->after('status');
        });

        // Move legacy sold/rented values from status into marked_as.
        DB::table('listings')->where('status', 'sold')->update([
            'marked_as' => 'sold',
            'status' => 'active',
        ]);
        DB::table('listings')->where('status', 'rented')->update([
            'marked_as' => 'rented',
            'status' => 'active',
        ]);
    }

    public function down()
    {
        Schema::table('listings', function (Blueprint $table) {
            $table->dropColumn('marked_as');
        });
    }
}
