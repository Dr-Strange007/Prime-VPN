import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:bdix_vpn/service/token_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final String? baseUrl = dotenv.env['BASE_URL'];
  final TokenService _tokenService = TokenService();

  Future<void> sendOTP({
    required String email,
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/auth/send-otp');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send OTP: ${response.body}');
    }
  }

  Future<void> sendOTPForForgetPassword({
    required String email,
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/auth//forget-password');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send OTP: ${response.body}');
    }
  }

  Future<void> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/auth/verify-otp');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'otp': otp,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to verify OTP: ${response.body}');
    }
  }

  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/auth/reset-password-app"');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'newPassword': newPassword,
        'confirmPassword' : newPassword,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to verify OTP: ${response.body}');
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required bool flag,
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/auth/signup');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'flag' : flag
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create account: ${response.body}');
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/api/v1/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 400) {
      final errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['message'] ?? 'Invalid email or password');
    }

    if (response.statusCode != 200) {
      throw Exception('Failed to sign in: ${response.body}');
    }

    final responseData = jsonDecode(response.body);
    final String? accessToken = responseData['data']?['token'];
    final String? userType = responseData['data']?['userType'];
    await _tokenService.storeToken(accessToken!);
    return userType;
  }

  Future<void> logout() async {
    final token = await _tokenService.getToken();

    if (token == null) {
      throw Exception('No token found');
    }

    final url = Uri.parse('$baseUrl/api/v1/auth/logout');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      final errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['message'] ?? 'Logout failed');
    }

    await _tokenService.removeToken();
  }

  Future<void> guestUser({required String deviceId}) async {
    final url = Uri.parse('$baseUrl/api/v1/guest/create');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'deviceId': deviceId,
      }),
    );

    if (response.statusCode != 201) {
      final errorResponse = jsonDecode(response.body);
      throw Exception(
          errorResponse['message'] ?? 'You have used once please sign in');
    }
  }
}
