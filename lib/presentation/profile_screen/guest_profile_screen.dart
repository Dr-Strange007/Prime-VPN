import 'package:bdix_vpn/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/openvpn_controller.dart';
import '../../routes/routes.dart';
import '../../service/device_service.dart';
import '../../utils/scaffold_messenger_utils.dart';
import '../../widgets/bottomNavigationBar_widget.dart';
import '../../widgets/disconnect_dialog_box.dart';
import '../sign_up_screen/sign_up_screen1.dart';

class GuestProfileScreen extends StatefulWidget {
  const GuestProfileScreen({super.key});

  @override
  State<GuestProfileScreen> createState() => _GuestProfileScreenState();
}

class _GuestProfileScreenState extends State<GuestProfileScreen> {
  final UserService _userService = UserService();
  final DeviceService _deviceService = DeviceService();
  final OpenVPNController vpnController = Get.find<OpenVPNController>();
  late int _currentIndex = 2;
  bool isCheckedForId = false;
  String userId = "";


  @override
  void initState() {
    super.initState();
    _userId();
  }


  Future<void> _userId() async {
    String id = await _userService.getUserId() ?? '';
    setState(() {
      userId = id;
    });
  }

  void _onCheckboxChangedForId(bool? value, String userId) {
    if (value != null) {
      setState(() {
        isCheckedForId = value;
      });

      if (isCheckedForId) {
        Clipboard.setData(ClipboardData(text: userId));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Copied: $userId'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
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
            height: 150.h,
          ),
          Center(
            child: Container(
              width: 226.w,
              height: 210.h,
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
              offset: Offset(0, -8.h), // Move the divider 3 pixels up
              child: Divider(
                color: const Color(0xFFDBD2D1),
                thickness: 1.h,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Looks like you are not signed in yet',
            style: TextStyle(
              fontSize: 14.sp,
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
              child: Text(
                'SIGN UP',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50.h,
          ),
          Row(
            children: [
              SizedBox(width: 32.w),
              Text(
                'ID',
                style: TextStyle(
                  color: const Color(0xFF080E59),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 60.w),
              Text(
                userId,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(), // This will push the checkbox to the far right
              SizedBox(
                width: 32.w,
                child: Checkbox(
                  value:
                      isCheckedForId, // If you want the checkbox to be unchecked initially
                  onChanged: (value) => _onCheckboxChangedForId(value, userId),
                ),
              ),
              SizedBox(width: 32.w),
            ],
          ),
          GestureDetector(
            onTap: () {
              showScaffoldMessage(context,
                  "Your current plan is guest,you have to signup first to upgrade plan");
            },
            child: Row(
              children: [
                SizedBox(width: 32.w),
                SvgPicture.asset(
                  'assets/images/crown.svg',
                  height: 15.h,
                  width: 16.67.w,
                ),
                SizedBox(width: 32.w),
                Text(
                  'Base Plan',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 70.w,
                  height: 25.h,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF1D1D7D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {
                      showScaffoldMessage(context,
                          "Your current plan is guest,you have to signup first to upgrade plan");
                    },
                    child: Text(
                      'Guest',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 42.w),
              ],
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
