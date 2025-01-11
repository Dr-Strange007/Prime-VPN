import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../routes/routes.dart';

void main() {
  runApp(const one_time_splash_screen());
}

class one_time_splash_screen extends StatelessWidget {
  const one_time_splash_screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: OneTimeSplashScreen(),
    );
  }
}

class OneTimeSplashScreen extends StatelessWidget {
  const OneTimeSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const Spacer(),
          // Logo
          Center(
              child: Image.asset(
    'assets/images/logo.png', // Update the path to match your file
    width: 150,
    height: 150,
  ),
          ),
          const SizedBox(height: 30),
          // Terms and Conditions Text
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'By tapping "Agree & Continue," you confirm that you have read and accept our Terms & Conditions and Privacy Policy. We are committed to protecting your data with end-to-end encryption and a strict no-logs policy. You agree to use the VPN responsibly and in compliance with applicable laws. Some features, such as premium server access, are available through paid subscription plans, and payments may involve trusted third-party providers. By proceeding, you also agree to receive service-related updates and notifications.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontFamily: 'Nunito',
                color: Color(0xFF8A8A8A),
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Agree & Continue Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF393E7A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  // Add functionality here
                  Get.toNamed(AppRoutes.welcome);
                },
                child: const Text(
                  'Agree & Continue',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Nunito',
                    color: Color(0xFFE6E7EE),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Footer Text with Links
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'For full details, please check our ',
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'Nunito',
                      color: Color(0xFF8A8A8A),
                    ),
                  ),
                  TextSpan(
                    text: 'Terms & Conditions',
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'Nunito',
                      color: Color(0xFFEC8304),
                    ),
                  ),
                  TextSpan(
                    text: ' and ',
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'Nunito',
                      color: Color(0xFF8A8A8A),
                    ),
                  ),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'Nunito',
                      color: Color(0xFFEC8304),
                    ),
                  ),
                  TextSpan(
                    text: ' before continuing.',
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'Nunito',
                      color: Color(0xFF8A8A8A),
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
