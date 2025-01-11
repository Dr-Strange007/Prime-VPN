import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static const _key = 'accessToken';

  Future<void> storeToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, token);
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_key);
    return token;
  }

  Future<void> removeToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  Future<String?> decodeUserId() async {
    final String? token = await getToken();
    if (token == null) return null;

    try {
      final List<String> parts = token.split('.');
      if (parts.length != 3) {
        throw const FormatException('Invalid JWT format');
      }

      final String payload = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );

      final Map<String, dynamic> payloadMap = json.decode(payload);


      return payloadMap['id'] as String?;
    } catch (e) {

      return null;
    }
  }
}