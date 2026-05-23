import 'package:http/http.dart' as http;
import 'api_service.dart';

class AuthService {
  // 1. REGISTER API
  static Future<http.Response> register(String username, String displayName, String email, String password) async {
    Map<String, String> deviceInfo = await ApiService.getDeviceInfo();

    Map<String, dynamic> body = {
      'username': username,
      'display_name': displayName,
      'email': email,
      'password': password,
      ...deviceInfo,
    };

    return await ApiService.post('/register', body);
  }

  // 2. LOGIN API
  static Future<http.Response> login(String email, String password) async {
    return await ApiService.post('/login', {
      'email': email,
      'password': password,
    });
  }

  // 3. FORGOT PASSWORD (SEND OTP)
  static Future<http.Response> sendOtp(String email) async {
    return await ApiService.post('/password/forgot', {
      'email': email,
    });
  }

  // 4. VERIFY OTP
  static Future<http.Response> verifyOtp(String email, String otp) async {
    return await ApiService.post('/password/verify-otp', {
      'email': email,
      'otp': otp,
    });
  }

  // 5. RESET PASSWORD
  static Future<http.Response> resetPassword(String email, String otp, String password) async {
    return await ApiService.post('/password/reset', {
      'email': email,
      'otp': otp,
      'password': password,
      'password_confirmation': password,
    });
  }
}