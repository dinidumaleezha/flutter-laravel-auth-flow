<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('users', function (Blueprint $table) {
            // Primary Key as UUID
            $table->uuid('id')->primary();
            
            // Authentication & Profile Info
            $table->string('username', 50)->unique();
            $table->string('display_name', 100);
            $table->enum('role', ['user', 'admin'])->default('user');
            $table->string('email', 100)->unique();
            $table->timestamp('email_verified_at')->nullable();
            $table->string('password', 255);
            $table->rememberToken();
            
            // Status Flags
            $table->boolean('is_verified')->default(false);
            $table->boolean('is_private')->default(false);
            $table->text('bio')->nullable();
            $table->text('profile_pic_url')->nullable();
            $table->text('profile_pic_thumb_url')->nullable();
            
            // Counts
            $table->integer('followers_count')->default(0);
            $table->integer('following_count')->default(0);
            $table->integer('posts_count')->default(0);
            
            // Moderation & Security
            $table->boolean('is_disabled')->default(false);
            $table->enum('account_status', ['active', 'limited', 'banned', 'deleted'])->default('active');
            $table->timestamp('banned_until')->nullable();
            $table->integer('report_count')->default(0);
            $table->integer('warning_count')->default(0);
            
            // Online Status & Push Notifications
            $table->boolean('is_online')->default(false);
            $table->timestamp('last_seen_at')->nullable();
            $table->text('fcm_token')->nullable();
            
            // Device Tracking
            $table->string('device_id', 255)->nullable();
            $table->string('device_name', 100)->nullable();
            $table->string('brand', 100)->nullable();
            $table->string('model', 100)->nullable();
            $table->string('os_version', 50)->nullable();
            $table->string('app_version', 50)->nullable();
            $table->string('ip_address', 45)->nullable();
            
            // Analytics
            $table->integer('login_count')->default(0);
            $table->timestamp('last_login')->nullable();
            
            // Creator & Earnings
            $table->boolean('is_creator')->default(false);
            $table->decimal('earnings_balance', 10, 2)->default(0.00);
            $table->enum('subscription_type', ['free', 'premium'])->default('free');
            
            // Localization & Demographics
            $table->string('language', 20)->default('en');
            $table->string('country', 50)->nullable();
            $table->date('date_of_birth')->nullable();
            $table->string('gender', 20)->nullable();
            
            // Timestamps
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('users');
    }
};