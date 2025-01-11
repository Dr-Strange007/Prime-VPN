import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../routes/routes.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../../service/api/auth_service.dart';


void main() {
  runApp(const welcome_screen());
}

class welcome_screen extends StatelessWidget {
  const welcome_screen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const Spacer(flex: 1),
          // Logo
          Center(
            child: Image.asset(
              'assets/images/logo.png',
              width: 150,
              height: 150,
            ),
          ),
          const SizedBox(height: 30),
          // Title Text
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Similar to Stability\nand Speed',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Nunito',
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Subtitle Text
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'Best BDIX VPN Like Stable, like Speed. Fantastic performance, security, and quickness all together.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Nunito',
                color: Color(0xFF545454),
                height: 1.5,
              ),
            ),
          ),
          const Spacer(flex: 2),
          // Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Sign In Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Sign In Action
                      Get.toNamed(AppRoutes.signIn);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF393E7A),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        color: Color(0xFFE6E7EE),
                        fontSize: 16,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Sign Up Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Sign Up Action
                      Get.toNamed(AppRoutes.signUp1);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF080E59)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Color(0xFF080E59),
                        fontSize: 16,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Continue as Guest Button
          TextButton(
            onPressed: () async {
              DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
              AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

              String? deviceId = androidInfo.id; // Fetch unique device ID

              if (deviceId != null) {
                print('Device ID: $deviceId'); // Log or use it as needed

                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false, // Prevent dismissing the dialog by tapping outside
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );

                try {
                  // Call guestUser method
                  await AuthService().guestUser(deviceId: deviceId);

                  // Store the device ID locally in shared preferences
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setString('guest_device_id', deviceId);

                  // If successful, navigate to the guest home screen
                  Get.toNamed(AppRoutes.guestHome);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Guest access finished, please sign up to continue.'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                } finally {
                  // Dismiss the loading dialog
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setString('guest_device_id', deviceId);
                  Navigator.of(context).pop();
                  Get.toNamed(AppRoutes.guestHome);
                }
              } else {
                print('Failed to retrieve device ID');
              }
            },
            child: const Text(
              'Continue as a Guest',
              style: TextStyle(
                color: Color(0xFF9B9594),
                fontSize: 16,
                fontFamily: 'Nunito',
              ),
            ),
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
