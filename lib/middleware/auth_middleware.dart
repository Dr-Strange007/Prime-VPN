import 'package:bdix_vpn/service/device_service.dart';
import 'package:bdix_vpn/service/token_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  final TokenService _tokenService = TokenService();
  final DeviceService _deviceService = DeviceService();

  @override
  RouteSettings? redirect(String? route) {
    Future.sync(() async {
      final isAuthenticated = await _checkAuthStatus();
      if (!isAuthenticated) {
        Get.offAllNamed('/welcome');
      }
    });

    return null;
  }


  Future<bool> _checkAuthStatus() async {
    final token = await _tokenService.getToken();
    final deviceId = await _deviceService.checkGuestStatus();
    return (token != null && token.isNotEmpty) || deviceId;
  }
}

