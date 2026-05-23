import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // ==========================================
  // 1. LOGIN FUNCTION
  // ==========================================
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await AuthService.login(email, password);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', data['access_token']);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = data['message'] ?? 'Login failed';
      }
    } catch (e) {
      _errorMessage = "Connection error. Please try again.";
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // ==========================================
  // 2. REGISTER FUNCTION
  // ==========================================
  Future<bool> register(String username, String displayName, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await AuthService.register(username, displayName, email, password);
      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', data['access_token']);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = data['errors']?.toString() ?? data['message'] ?? 'Registration failed';
      }
    } catch (e) {
      _errorMessage = "Connection error. Please try again.";
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // ==========================================
  // 3. SEND OTP FUNCTION
  // ==========================================
  Future<bool> sendOtp(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await AuthService.sendOtp(email);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = data['message'] ?? 'Failed to send OTP';
      }
    } catch (e) {
      _errorMessage = "Connection error. Please try again.";
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // ==========================================
  // 4. VERIFY OTP FUNCTION
  // ==========================================
  Future<bool> verifyOtp(String email, String otp) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await AuthService.verifyOtp(email, otp);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = data['message'] ?? 'Invalid OTP code';
      }
    } catch (e) {
      _errorMessage = "Connection error. Please try again.";
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // ==========================================
  // 5. RESET PASSWORD FUNCTION
  // ==========================================
  Future<bool> resetPassword(String email, String otp, String newPassword) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await AuthService.resetPassword(email, otp, newPassword);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = data['message'] ?? 'Password reset failed';
      }
    } catch (e) {
      _errorMessage = "Connection error. Please try again.";
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }
}