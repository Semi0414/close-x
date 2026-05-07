<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('listing_details', function (Blueprint $table) {
            $table->json('form_data')->nullable()->after('amenities');
        });
    }

    public function down(): void
    {
        Schema::table('listing_details', function (Blueprint $table) {
            $table->dropColumn('form_data');
        });
    }
};
