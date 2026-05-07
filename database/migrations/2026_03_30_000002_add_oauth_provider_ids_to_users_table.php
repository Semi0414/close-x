<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddOauthProviderIdsToUsersTable extends Migration
{
    public function up()
    {
        Schema::table('users', function (Blueprint $table) {
            $table->string('google_id', 255)->nullable()->unique()->after('phone');
            $table->string('facebook_id', 255)->nullable()->unique()->after('google_id');
            $table->string('apple_id', 255)->nullable()->unique()->after('facebook_id');
        });
    }

    public function down()
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn(['google_id', 'facebook_id', 'apple_id']);
        });
    }
}

