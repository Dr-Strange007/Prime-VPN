import 'package:bdix_vpn/presentation/sign_up_screen/signUp_passWord_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../models/user.dart';
import '../../routes/routes.dart';
import '../../service/api/user_remote_service.dart';
import '../../service/database/database_helper.dart';
import '../../service/user_service.dart';
import '../../widgets/bottomNavigationBar_widget.dart';
import '../forgot_password/forgot_password.dart';

class NormalLoginProfileScreen extends StatefulWidget {
  const NormalLoginProfileScreen({super.key});

  @override
  State<NormalLoginProfileScreen> createState() => _NormalLoginProfileScreenState();
}

class _NormalLoginProfileScreenState extends State<NormalLoginProfileScreen> {
  final UserService _userService = UserService();
  late int _currentIndex =  2;
  late Future<User> _userFuture;
  int totalDataUsed = 0;
  bool isPremium = false;

  bool isCheckedForId = false;
  bool isCheckedForEmail = false;

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

  void _onCheckboxChangedForEmail(bool? value, String userId) {
    if (value != null) {
      setState(() {
        isCheckedForEmail = value;
      });

      if (isCheckedForEmail) {
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

  void getTotalData() async {
    final dbHelper = DatabaseHelper();
    totalDataUsed = await dbHelper.getTotalDataUsed();
  }

  String formatDataUsage(int dataUsedKilobytes) {
    if (dataUsedKilobytes >= 1024) {
      // Convert kilobytes to megabytes (1 MB = 1024 KB)
      return "${(dataUsedKilobytes / 1024).toStringAsFixed(2)} MB";
    } else {
      // Keep it as kilobytes if less than 1 MB
      return "$dataUsedKilobytes KB";
    }
  }

  Future<void> _loadUserType() async {
    bool userType = await _userService.getUserType();
    setState(() {
      isPremium = userType;
    });
  }



  @override
  void initState() {
    super.initState();
    _userFuture = UserRemoteService().userDetails();
    getTotalData();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: FutureBuilder<User>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No user data found.'));
            }

            final user = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60.h), // Scale height
                const Text(
                  'Profile',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    const Text(
                      'ID',
                      style: TextStyle(
                          color: Color(0xFF080E59),
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text(
                      user.userId.toString(),
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),

                    Checkbox(
                      value: isCheckedForId,
                      onChanged: (value) => _onCheckboxChangedForId(value, user.userId.toString()),
                    ),
                  ],
                ),
                Divider(
                  color: const Color(0x80DAD9DB),
                  thickness: 1.w, // Scale thickness
                ),
                Row(
                  children: [
                    const Text(
                      'EMAIL',
                      style: TextStyle(
                          color: Color(0xFF080E59),
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text(
                      user.email.length > 15
                          ? '${user.email.substring(0, 15)}...'
                          : user.email,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(width: 60.w), // Scale width
                    GestureDetector(
                      onTap: () {
                        Get.to(
                              () => const ForgetPasswordApp(),
                          arguments: {'fromProfilePage': true},
                        );
                      },
                      child: SvgPicture.asset(
                        'assets/images/pencil.svg',
                        height: 15.h, // Scale height
                        width: 16.67.w, // Scale width
                      ),
                    ),
                    Checkbox(
                      value: isCheckedForEmail,
                      onChanged: (value) => _onCheckboxChangedForEmail(value, user.email.toString()),
                    ),
                  ],
                ),
                Divider(
                  color: const Color(0x80DAD9DB),
                  thickness: 1.w, // Scale thickness
                ),
                Row(
                  children: [
                    const Text(
                      'PASSWORD',
                      style: TextStyle(
                          color: Color(0xFF080E59),
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    const Text(
                     "******",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    SizedBox(width: 70.w), // Scale width
                    GestureDetector(
                      onTap: () {
                        Get.to(
                              () => const SignUp6(),
                          arguments: {'fromProfilePage': true},
                        );
                      },
                      child: SvgPicture.asset(
                        'assets/images/pencil.svg',
                        height: 15.h, // Scale height
                        width: 16.67.w, // Scale width
                      ),
                    ),
                    const Checkbox(
                      value: false,
                      onChanged: null,
                    ),
                  ],
                ),
                Divider(
                  color: const Color(0x80DAD9DB),
                  thickness: 1.w, // Scale thickness
                ),
                Row(
                  children: [
                    const Text(
                      'VPN',
                      style: TextStyle(
                          color: Color(0xFF080E59),
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text(
                      formatDataUsage(totalDataUsed), // Displaying user VPN if exists
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    SizedBox(width: 100.w), // Scale width
                    SizedBox(height: 40.h), // Scale height
                  ],
                ),
                Divider(
                  color: const Color(0x80DAD9DB),
                  thickness: 1.w, // Scale thickness
                ),
                Row(
                  children: [
                    const Text(
                      'Device',
                      style: TextStyle(
                          color: Color(0xFF080E59),
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    const Text(
                      '1/4', // Display device usage
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    SizedBox(width: 60.w), // Scale width
                    const Text(
                      'View',
                      style: TextStyle(
                          color: Color(0xFF080E59),
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 45.w), // Scale width
                    SizedBox(height: 40.h), // Scale height
                  ],
                ),
                Divider(
                  color: const Color(0x80DAD9DB),
                  thickness: 1.w, // Scale thickness
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/crown.svg',
                      height: 15.h, // Scale height
                      width: 16.67.w, // Scale width
                    ),
                    SizedBox(width: 25.w), // Scale width
                    const Text(
                      'Base Plan', // Display user plan
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 74.14.w, // Scale width
                      height: 25.h, // Scale height
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFF1D1D7D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.r), // Scale radius
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () {},
                        child: Text(
                          isPremium
                              ? 'Normal'
                              : "Premium",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h), // Scale height
                  ],
                ),
                Divider(
                  color: const Color(0x80DAD9DB),
                  thickness: 1.w, // Scale thickness
                ),
                SizedBox(height: 50.h), // Scale height
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 121.w, // Scale width
                        height: 25.h, // Scale height
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFFEC8304),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.r), // Scale radius
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () {Get.toNamed(AppRoutes.premiumSubscriptionScreen);},
                          child: Text(
                            isPremium
                                ? 'Upgrade to Premium'
                                : "Upgrade",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 200.h), // Scale height
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     SvgPicture.asset(
                      //       'assets/images/recycle.svg',
                      //       height: 15.h, // Scale height
                      //       width: 16.67.w, // Scale width
                      //     ),
                      //     SizedBox(width: 16.w), // Scale width
                      //     const Text(
                      //       'Restore',
                      //       style: TextStyle(color: Colors.black),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

