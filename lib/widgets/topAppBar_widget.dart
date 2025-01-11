import 'package:bdix_vpn/service/device_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/routes.dart';
import '../utils/scaffold_messenger_utils.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isPremium;
  final bool isGuest;

  TopAppBar({super.key, required this.isPremium, required this.isGuest});

  final DeviceService _deviceService = DeviceService();


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo and Text on the left
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'BDIX',
                        style: TextStyle(
                          color: Color(0xFF393E7A),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' VPN',
                        style: TextStyle(
                          color: Color(0xFF393E7A),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (isPremium)
              Row(
                children: [
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      if (isGuest) {
                        showScaffoldMessage(context, "You have to signup first to be premium user");
                      } else {
                        Get.toNamed(AppRoutes.premiumSubscriptionScreen);
                      }
                    },
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/go_pro.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
