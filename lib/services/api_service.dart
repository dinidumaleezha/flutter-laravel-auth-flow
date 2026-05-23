import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000/api";

  static Future<Map<String, String>> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    Map<String, String> info = {
      'device_id': 'unknown',
      'device_name': 'unknown',
      'brand': 'unknown',
      'model': 'unknown',
      'os_version': 'unknown',
      'app_version': '1.0.0',
    };

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        info['device_id'] = androidInfo.id;
        info['device_name'] = androidInfo.model;
        info['brand'] = androidInfo.brand;
        info['model'] = androidInfo.model;
        info['os_version'] = androidInfo.version.release;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        info['device_id'] = iosInfo.identifierForVendor ?? 'unknown';
        info['device_name'] = iosInfo.name;
        info['brand'] = 'Apple';
        info['model'] = iosInfo.model;
        info['os_version'] = iosInfo.systemVersion;
      }
    } catch (e) {
      print("Error getting device info: $e");
    }
    return info;
  }

  static Future<Map<String, String>> _getHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse("$baseUrl$endpoint");
    return await http.post(
      url,
      headers: await _getHeaders(),
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> get(String endpoint) async {
    final url = Uri.parse("$baseUrl$endpoint");
    return await http.get(
      url,
      headers: await _getHeaders(),
    );
  }
}