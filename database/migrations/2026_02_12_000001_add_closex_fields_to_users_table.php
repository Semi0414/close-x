<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddClosexFieldsToUsersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('users', function (Blueprint $table) {
            $table->string('phone')->nullable()->unique()->after('email');
            $table->string('whatsapp')->nullable()->after('phone');
            $table->enum('role', ['broker', 'admin'])->default('broker')->after('whatsapp');
            $table->enum('status', ['active', 'suspended', 'pending'])->default('pending')->after('role');
            $table->string('language', 10)->nullable()->after('status');
            $table->string('profile_photo')->nullable()->after('language');
            $table->timestamp('last_active')->nullable()->after('profile_photo');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn([
                'phone',
                'whatsapp',
                'role',
                'status',
                'language',
                'profile_photo',
                'last_active',
            ]);
        });
    }
}


