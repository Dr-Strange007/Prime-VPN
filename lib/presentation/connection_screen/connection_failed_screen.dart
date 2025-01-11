import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:bdix_vpn/routes/routes.dart'; // Import routes to navigate

class ConnectionFailedScreen extends StatefulWidget {
  const ConnectionFailedScreen({super.key});

  @override
  State<ConnectionFailedScreen> createState() => _ConnectionFailedScreenState();
}

class _ConnectionFailedScreenState extends State<ConnectionFailedScreen> {
  bool _isLoading = false;  // To show loading spinner while checking connectivity

  // Method to check connectivity when the "Try Again" button is pressed
  Future<void> _tryAgain() async {
    setState(() {
      _isLoading = true;  // Show loading while checking connectivity
    });

    // Check connectivity status
    final connectivityResult = await Connectivity().checkConnectivity();

    // If connected to the internet, navigate to the next screen
    if (connectivityResult != ConnectivityResult.none) {
      // Replace this with your actual navigation logic (for example, to the home screen)
      Get.offAllNamed(AppRoutes.splash);  // Replace with appropriate screen
    } else {
      // If still not connected, show a message or stay on the same screen
      setState(() {
        _isLoading = false;  // Hide loading spinner
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Implement back navigation if needed
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 130),
          Center(
            child: SvgPicture.asset(
              'assets/images/world_image.svg',
              height: 261.46,
              width: 352,
            ),
          ),
          const SizedBox(height: 43.54),
          const Text(
            'Connection Failed',
            style: TextStyle(
                fontSize: 28,
                color: Color(0xFF080E59),
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 18),
          _isLoading
              ? const CircularProgressIndicator()  // Show a loading indicator while checking
              : SizedBox(
            width: 90, // Button width
            height: 36, // Button height
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF1D1D7D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: _tryAgain,  // When button pressed, try checking again
              child: const Text(
                'Try Again',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
