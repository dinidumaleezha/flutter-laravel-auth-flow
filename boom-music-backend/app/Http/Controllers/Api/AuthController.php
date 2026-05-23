<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\PasswordResetOtp;
use App\Mail\SendOtpMail;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Validator;

class AuthController extends Controller
{
    // ==========================================
    // 1. REGISTER API
    // ==========================================
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'username' => 'required|string|max:50|unique:users',
            'display_name' => 'required|string|max:100',
            'email' => 'required|string|email|max:100|unique:users',
            'password' => 'required|string|min:6',
            'device_id' => 'nullable|string',
            'device_name' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $user = User::create([
            'username' => $request->username,
            'display_name' => $request->display_name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            // Device metrics fields automatically updated from request
            'device_id' => $request->device_id,
            'device_name' => $request->device_name,
            'brand' => $request->brand,
            'model' => $request->model,
            'os_version' => $request->os_version,
            'app_version' => $request->app_version,
            'ip_address' => $request->ip(),
            'last_login' => now(),
            'login_count' => 1,
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'message' => 'User registered successfully!',
            'access_token' => $token,
            'token_type' => 'Bearer',
            'user' => $user
        ], 201);
    }

    // ==========================================
    // 2. LOGIN API
    // ==========================================
    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);
    

        $user = User::where('email', $request->email)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json(['message' => 'Invalid credentials'], 401);
        }

        if ($user->account_status === 'banned') {
            return response()->json(['message' => 'Your account has been banned.'], 403);
        }
        
        $user->tokens()->delete();
        
        $user->increment('login_count');

        $user->update([
            'is_online' => true,
            'last_login' => now(),
            'ip_address' => $request->ip()
        ]);
        
        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'access_token' => $token,
            'token_type' => 'Bearer',
            'user' => $user
        ]);
    }

    // ==========================================
    // 3. SEND OTP API (FORGOT PASSWORD)
    // ==========================================
    public function sendResetOtp(Request $request)
    {
        $request->validate(['email' => 'required|email|exists:users,email']);

        $email = $request->email;
        $otp = rand(100000, 999999); 
        $expiresAt = now()->addMinutes(15);

        PasswordResetOtp::where('email', $email)->delete();

        PasswordResetOtp::create([
            'email' => $email,
            'otp' => $otp,
            'expires_at' => $expiresAt
        ]);

        Mail::to($email)->send(new SendOtpMail($otp));

        return response()->json(['message' => 'OTP sent successfully to your email.']);
    }

    // ==========================================
    // 4. VERIFY OTP API
    // ==========================================
    public function verifyOtp(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'otp' => 'required|string|size:6'
        ]);

        $resetRecord = PasswordResetOtp::where('email', $request->email)
                                        ->where('otp', $request->otp)
                                        ->first();

        if (!$resetRecord) {
            return response()->json(['message' => 'Invalid OTP code.'], 422);
        }

        if (now()->isAfter($resetRecord->expires_at)) {
            return response()->json(['message' => 'OTP has expired.'], 422);
        }

        return response()->json(['message' => 'OTP verified successfully.']);
    }

    // ==========================================
    // 5. RESET PASSWORD API
    // ==========================================
    public function resetPassword(Request $request)
    {
        $request->validate([
            'email' => 'required|email|exists:users,email',
            'otp' => 'required|string|size:6',
            'password' => 'required|string|min:6|confirmed'
        ]);

        $resetRecord = PasswordResetOtp::where('email', $request->email)
                                        ->where('otp', $request->otp)
                                        ->first();

        if (!$resetRecord || now()->isAfter($resetRecord->expires_at)) {
            return response()->json(['message' => 'Unauthorized request.'], 422);
        }

        $user = User::where('email', $request->email)->first();
        $user->update([
            'password' => Hash::make($request->password)
        ]);

        $resetRecord->delete();

        return response()->json(['message' => 'Your password has been reset successfully!']);
    }
}