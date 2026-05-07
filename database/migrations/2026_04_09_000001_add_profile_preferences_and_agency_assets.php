<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddProfilePreferencesAndAgencyAssets extends Migration
{
    public function up()
    {
        Schema::table('users', function (Blueprint $table) {
            $table->boolean('phone_notifications')->default(true)->after('profile_photo');
            $table->boolean('messages_notifications')->default(true)->after('phone_notifications');
            $table->boolean('whatsapp_notifications')->default(true)->after('messages_notifications');
            $table->enum('account_type', ['personal', 'agency'])->default('personal')->after('whatsapp_notifications');
        });

        Schema::table('agencies', function (Blueprint $table) {
            $table->string('logo')->nullable()->after('name');
            $table->json('attachments')->nullable()->after('address');
        });
    }

    public function down()
    {
        Schema::table('agencies', function (Blueprint $table) {
            $table->dropColumn(['logo', 'attachments']);
        });

        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn([
                'phone_notifications',
                'messages_notifications',
                'whatsapp_notifications',
                'account_type',
            ]);
        });
    }
}

