import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/openvpn_controller.dart';
import '../routes/routes.dart';
import '../service/device_service.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final DeviceService _deviceService = DeviceService();

  BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  bool isGuest = false;
  final OpenVPNController vpnController = Get.find<OpenVPNController>();

  @override
  void initState() {
    super.initState();
    _initializeGuestStatus();
  }

  Future<void> _initializeGuestStatus() async {
    isGuest = await widget._deviceService.checkGuestStatus();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: (index) {
        _handleTap(context, index); // Custom tap handler for each item
        widget.onTap(index); // Pass the tap event to the parent
      },
      selectedItemColor: const Color(0xFF080E59),
      unselectedItemColor: const Color(0xFF9B9594),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.cloud_outlined),
          label: 'Server',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }

  void _handleTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        vpnController.isConnected.value
            ? Get.toNamed(AppRoutes.guestHomeScreen)
            : Get.toNamed(AppRoutes.guestHome);
        break;
      case 1:
        if (isGuest) {
          Get.toNamed(AppRoutes.guestServerScreen);
        } else {
          Get.toNamed(AppRoutes.normalServerScreen);
        }
        break;
      case 2:
        if (isGuest) {
          Get.toNamed(AppRoutes.guestProfileScreen);
        } else {
          Get.toNamed(AppRoutes.normalLoginProfileScreen);
        }

        break;
      case 3:
        Get.toNamed(AppRoutes.premiumSettingScreen);
        break;
      default:
        print('Unknown item tapped');
    }
  }
}
