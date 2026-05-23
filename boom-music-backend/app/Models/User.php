<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable, HasUuids;

    public $incrementing = false;
    protected $keyType = 'string';

    protected $fillable = [
        'username', 'display_name', 'role', 'email', 'password',
        'is_verified', 'is_private', 'bio', 'profile_pic_url', 'profile_pic_thumb_url',
        'followers_count', 'following_count', 'posts_count', 'is_disabled',
        'account_status', 'banned_until', 'report_count', 'warning_count',
        'is_online', 'last_seen_at', 'fcm_token', 'device_id', 'device_name',
        'brand', 'model', 'os_version', 'app_version', 'ip_address',
        'login_count', 'last_login', 'is_creator', 'earnings_balance',
        'subscription_type', 'language', 'country', 'date_of_birth', 'gender'
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected $casts = [
        'email_verified_at' => 'datetime',
        'password' => 'hashed',
        'banned_until' => 'datetime',
        'last_seen_at' => 'datetime',
        'last_login' => 'datetime',
        'date_of_birth' => 'date',
        'is_verified' => 'boolean',
        'is_private' => 'boolean',
        'is_disabled' => 'boolean',
        'is_online' => 'boolean',
        'is_creator' => 'boolean',
    ];
}