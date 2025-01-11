import 'dart:async';

import 'package:bdix_vpn/service/device_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../../models/user_preferences.dart';
import '../../providers/timer_provider.dart';
import '../../routes/routes.dart';
import '../../service/database/database_helper.dart';
import '../../service/user_service.dart';
import '../../widgets/bottomNavigationBar_widget.dart';
import '../../widgets/topAppBar_widget.dart';
import '../../controllers/openvpn_controller.dart';
import 'guest_home_screen.dart';

class GuestHome extends ConsumerStatefulWidget {
  const GuestHome({super.key});

  @override
  ConsumerState<GuestHome> createState() => _GuestHomeState();
}

class _GuestHomeState extends ConsumerState<GuestHome> {
  final OpenVPNController vpnController =
  Get.find<OpenVPNController>();
  final UserService _userService = UserService();
  final DeviceService _deviceService = DeviceService();
  bool isPremium = false;
  bool isCurrentScreen = true;
  bool isGuest = false;


  @override
  void initState() {
    super.initState();
    _loadConfig();
    _observeConnection();
    _loadUserType();
    _conditionalStartVPN();
    _initializeGuestStatus();
  }

  @override
  void dispose() {
    super.dispose();
    isCurrentScreen = false;
  }

  Future<void> _initializeGuestStatus() async {
    isGuest = await _deviceService.checkGuestStatus();
    setState(() {});
  }

  Future<void> _loadUserType() async {
    bool userType = await _userService.getUserType();
    setState(() {
      isPremium = userType;
    });
  }

  Future<void> _loadConfig() async {
    final loadedConfig =
    await DefaultAssetBundle.of(context).loadString('assets/VPNFile/client1.ovpn');
    vpnController.vpnConfig.value = loadedConfig;
  }

  void _observeConnection() {
    vpnController.isConnected.listen((connected) {
      print("connected status $connected");
      if (connected ) {
        //isCurrentScreen= false;
        ref.read(timerProvider.notifier).startTimer();
        Get.offAll(const GuestHomeScreen());
      }
    });
  }

  Future<void> _conditionalStartVPN() async {
    try{
      final DatabaseHelper dbHelper = DatabaseHelper();
      final String? userId = await _userService.getUserId();
      final UserPreferences? preferences = await dbHelper.getUserPreferences(userId!);

      if (preferences?.connectOnStart == true){
        vpnController.connect();
      }
    } catch (e) {
      print("Error starting VPN: $e");
    }
  }

  Future<void> _startVPN() async {
    try {
      vpnController.connect();
      print("VPN Connection Started...");
    } catch (e) {
      print("Error starting VPN: $e");
    }
  }

  void _stopVPN() {
    vpnController.disconnect();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopAppBar(isPremium: isPremium,isGuest: isGuest),
      body: Obx(() {
        return Column(
          children: [
            const SizedBox(height: 20),

            // Map Image or Placeholder
            Container(
              width: double.infinity,
              height: 300,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/normal_map.png'), // Replace with your map image asset
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Status Text
            Text(
              'Status: ${vpnController.vpnStage.value}',
              style: const TextStyle(
                color: Color(0xFF070D51),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),

            const Spacer(),

            // Connect Button with Loading Indicator
            Center(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      if (vpnController.isConnected.value) {
                        _stopVPN();
                      } else {
                        _startVPN();
                      }
                    },
                    borderRadius:
                    BorderRadius.circular(50), // Circular ripple effect
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: vpnController.isConnected.value
                                ? Colors.green
                                : const Color(0xFF080E59),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFE6E7EE),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            vpnController.isConnected.value
                                ? Icons.check
                                : Icons.bolt,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        if (vpnController.vpnStage.value == "Connecting...")
                          const SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    vpnController.isConnected.value
                        ? 'Connected'
                        : (vpnController.vpnStage.value == "Connecting..."
                        ? 'Connecting...'
                        : 'Tap to Connect'),
                    style: const TextStyle(
                      color: Color(0xFF080E59),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Bottom Navigation Bar
          ],
        );
      }),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          // Handle navigation between tabs
        },
      ),
    );
  }
}