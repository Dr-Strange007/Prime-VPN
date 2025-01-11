import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../controllers/openvpn_controller.dart';
import '../../routes/routes.dart';
import '../../service/device_service.dart';
import '../../widgets/bottomNavigationBar_widget.dart';
import '../../widgets/disconnect_dialog_box.dart';
import '../sign_up_screen/sign_up_screen1.dart';

class GuestServerScreen extends StatefulWidget {
  const GuestServerScreen({super.key});

  @override
  GuestServerScreenState createState() => GuestServerScreenState();
}

class GuestServerScreenState extends State<GuestServerScreen> {
  int? _selectedValue = 0;
  late int _currentIndex = 1;
  final OpenVPNController vpnController = Get.find<OpenVPNController>();
  final DeviceService _deviceService = DeviceService();

  void _handleRadioValueChange(int? value) {
    setState(() {
      _selectedValue = value;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 100.h,
          ),
          Center(
            child: Container(
              width: 226.w,
              height: 215.h,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/searching_image.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 225.71.w,
            child: Transform.translate(
              offset: Offset(0, -8.h),
              child: const Divider(
                color: Color(0xFFDBD2D1),
                thickness: 1,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          const Text(
            'Sign in to connect with more servers',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              letterSpacing: -0.02,
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: 90.w, // Button width
            height: 36.h, // Button height
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF1D1D7D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.r),
                ),
              ),
              onPressed: () async {
                if (vpnController.isConnected.value) {
                  final shouldDisconnect = await showDialog<bool>(
                    context: context,
                    builder: (context) => const DisconnectDialog(),
                  );
                  if (shouldDisconnect == true) {
                    _deviceService.removeDeviceId();
                    Get.offAll(const SignUpScreen());
                  }
                } else {
                  _deviceService.removeDeviceId();
                  Get.offAll(const SignUpScreen());
                }
              },
              child: const Text(
                'SIGN UP',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          SizedBox(height: 60.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 32.w),
              const Icon(
                Icons.language,
                color: Colors.blue,
                size: 20,
              ),
              SizedBox(width: 16.w),
              const Text('Smart Location',
                  style: TextStyle(
                    fontSize: 12,
                  )),
              const Spacer(),
              Radio<int>(
                value: 0,
                groupValue: _selectedValue,
                onChanged: _handleRadioValueChange,
              ),
              SizedBox(width: 32.w),
            ],
          ),
          const Divider(
            color: Color(0xFFDBD2D1),
            thickness: 1,
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.only(left: 32.w),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Locations',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            color: Theme.of(context).cardColor,
            child: SizedBox(
              height: 80.h,
              child: Center(
                child: ListTile(
                  leading: Container(
                    width: 40.w,
                    height: 25.h,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/french_flag.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: const Text('France'),
                  trailing: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('231ms', style: TextStyle(color: Colors.blue)),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: VerticalDivider(
                          width: 10,
                          thickness: 1,
                          color: Color(0xFF787473),
                        ),
                      ),
                      Icon(Icons.arrow_drop_down, color: Colors.black),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            color: Theme.of(context).cardColor,
            child: SizedBox(
              height: 80.h,
              child: Center(
                child: ListTile(
                  leading: Container(
                    width: 40.w,
                    height: 25.h,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/french_flag.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: const Text('Poland'),
                  trailing: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('999ms', style: TextStyle(color: Colors.red)),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: VerticalDivider(
                          width: 10,
                          thickness: 1,
                          color: Color(0xFF787473),
                        ),
                      ),
                      Icon(Icons.arrow_drop_down, color: Colors.black),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
