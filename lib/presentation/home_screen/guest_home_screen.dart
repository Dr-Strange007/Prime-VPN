import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../advertisment/reworded_ad.dart';
import '../../controllers/openvpn_controller.dart';
import '../../routes/routes.dart';
import '../../service/database/database_helper.dart';
import '../../service/device_service.dart';
import '../../service/user_service.dart';
import '../../utils/scaffold_messenger_utils.dart';
import '../../utils/speed_utils.dart';
import '../../widgets/bottomNavigationBar_widget.dart';
import '../../widgets/normal_user_restriction.dart';
import '../../widgets/rewarded_ad_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/timer_provider.dart';
import '../../widgets/sign_up_dialog.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GuestHomeScreen extends ConsumerStatefulWidget {
  const GuestHomeScreen({super.key});

  @override
  ConsumerState<GuestHomeScreen> createState() => _GuestHomeScreenState();
}

class _GuestHomeScreenState extends ConsumerState<GuestHomeScreen> {
  final OpenVPNController vpnController = Get.find<OpenVPNController>();
  late RewardedAdManager _rewardedAdManager;
  late int _currentIndex = 0;
  late Timer _dialogTimer;
  Duration get remainingTime => Duration(seconds: ref.watch(timerProvider));
  final Speed _speed = Speed();
  final UserService _userService = UserService();
  final DeviceService _deviceService = DeviceService();
  bool isNotPremium = false;
  bool isGuest = false;
  DateTime? sessionStartTime;
  DateTime? sessionEndTime;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }



  Future<void> _disconnectVPN() async {

    sessionEndTime = DateTime.now();
    _speed.stopMonitoring();

    int? dataUsedBytes = await _speed.stopMonitoring();

    print('ki obostha Data use in guest $dataUsedBytes');

    final dbHelper = DatabaseHelper();
    await dbHelper.insertSession(
      sessionStartTime.toString(),
      sessionEndTime.toString(),
      dataUsedBytes,
    );

    ref.read(timerProvider.notifier).resetTimer();
    try {
      String publicIP = "Unknown";
      final response =
          await http.get(Uri.parse('https://api64.ipify.org?format=json'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        publicIP = data['ip'] ?? "Unknown";
      }
      print('Disconnecting VPN...');

      // Access the OpenVPNController instance
      if (!Get.isRegistered<OpenVPNController>()) {
        throw Exception('OpenVPNController is not registered.');
      }

      final OpenVPNController vpnController = Get.find<OpenVPNController>();

      // Ensure the engine is initialized
      if (vpnController.engine == null) {
        throw Exception('OpenVPN engine is not initialized.');
      }

      // Disconnect the VPN using OpenVPNController
      vpnController.disconnect();
      vpnController.isConnected.value = false;
      vpnController.vpnStage.value = "Disconnected";

      print('VPN Disconnected.');

      if (mounted) {
        // Pass the public IP as an argument during navigation
        Get.offNamed(
          AppRoutes.connectionReportScreen,
          arguments: {'publicIP': publicIP},
        );
      }
    } catch (error) {
      print('Error disconnecting VPN: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to disconnect VPN: $error')),
      );
    }
  }

  void _loadRewardedAd() {
    _rewardedAdManager.loadRewardedAd(
      onAdLoaded: () {
        print('Rewarded Ad Loaded');
      },
      onAdFailed: () {
        print('Rewarded Ad Failed to Load');
      },
    );
  }

  @override
  void initState() {
    super.initState();
    MobileAds.instance.initialize();
    _rewardedAdManager = RewardedAdManager();
    _loadRewardedAd();
    //ref.read(timerProvider.notifier).startTimer();
    _speed.startMonitoring();
    _startTrafficStatsUpdate();
    _loadUserType();
    _initializeGuestStatus();
    sessionStartTime = DateTime.now();
  }

  @override
  void dispose() {
    _dialogTimer.cancel();
    _speed.startMonitoring();
    super.dispose();
  }

  Future<void> _initializeGuestStatus() async {
    isGuest = await _deviceService.checkGuestStatus();
    setState(() {});
  }

  Future<void> _loadUserType() async {
    bool userType = await _userService.getUserType();
    setState(() {
      isNotPremium = userType;
    });
  }

  void _startTrafficStatsUpdate() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _speed.updateTrafficStats();
      setState(() {});
    });
  }

  void _showAdDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return RewardedAdDialog(
          onWatchAd: _showRewardedAd,
        );
      },
    );
  }

  void _showRewardedAd() {
    _rewardedAdManager.showRewardedAd(
      context: context,
      onRewardEarned: _addExtraTime,
    );
  }

  void _addExtraTime() {
    setState(() {
      ref.read(timerProvider.notifier).addExtraTime(300);
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(timerProvider, (previous, next) {
      setState(() {});
    });
    if (isGuest || isNotPremium) {
      ref.listen<int>(timerProvider, (previous, next) {
        if (ref.watch(timerProvider.notifier).shouldShowAd) {
          _showAdDialog();
          ref.read(timerProvider.notifier).resetAdFlag();
        }
      });
    }

    if (isGuest) {
      print("ki value $isGuest");
      ref.listen<int>(timerProvider, (previous, next) {
        if (ref.read(timerProvider.notifier).signUpDialogShow) {
          vpnController.disconnect();
          showSignUpDialog(context,true);
          ref.read(timerProvider.notifier).resetAdFlag();
        }
      });
    }
    if (isNotPremium && !isGuest) {
      ref.listen<int>(timerProvider, (previous, next) {
        if (ref.read(timerProvider.notifier).normalSignUpDialogShow) {
          normalUserRestrictionUpDialog(context);
          ref.read(timerProvider.notifier).resetAdFlag();
        }
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(height: 50.h),
              Row(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 32.w,
                    height: 32.h,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    'BDX VPN',
                    style: TextStyle(
                        fontSize: 14.sp, color: const Color(0xFF393E7A)),
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Transform.translate(
                    offset: Offset(0, -70.h),
                    child: Image.asset(
                      'assets/images/map.png',
                      width: double.infinity,
                      height: 400.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(-100.w, -85.h),
                    child: SvgPicture.asset(
                      'assets/images/location_icon.svg',
                      width: 14.w,
                      height: 18.h,
                    ),
                  ),
                ],
              ),
              Transform.translate(
                offset: Offset(0, -170.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Status : ',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    Text(
                      'Connected',
                      style: TextStyle(
                          fontSize: 12.sp, color: const Color(0xFFD77704)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Transform.translate(
                offset: Offset(0, -170.h),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F6F6),
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10.r,
                        offset: Offset(0, 4.h),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/globe_icon.svg',
                            width: 38.w,
                            height: 38.h,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'Smart Location',
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: const Color(0xFF545454)),
                          ),
                          const Spacer(),
                          CircleAvatar(
                            radius: 7.w,
                            backgroundColor: const Color(0xFF393E7A),
                            child: Icon(
                              Icons.done,
                              size: 10.sp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Divider(thickness: 1.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/images/custom_down_arrow.svg',
                                width: 14.w,
                                height: 18.h,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                _speed.downloadSpeedKB,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/images/custom_up_arrow.svg',
                                width: 14.w,
                                height: 18.h,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                _speed.uploadSpeedKB,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              if (!isNotPremium) ...[
                SizedBox(height: 50.h),
              ],
              if (isNotPremium) ...[
                Transform.translate(
                  offset: Offset(0, -170.h),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F6F6),
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10.r,
                          offset: Offset(0, 4.h),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Remaining Time',
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF545454)),
                            ),
                            const Spacer(),
                            Text(
                              _formatDuration(remainingTime),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {

                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFEC8304),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                                child: Text(
                                  '+Random Time',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: const Color(0xFFFDF3E6),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  if (isGuest) {
                                    //vpnController.disconnect();
                                    //showSignUpDialog(context,false);
                                    showScaffoldMessage(context, "You have to signup first to be premium user");
                                  } else {
                                    Get.toNamed(AppRoutes.premiumSubscriptionScreen);
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                      color: const Color(0xFFEC8304),
                                      width: 1.0.w),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Go Pro',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: const Color(0xFFEC8304),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    SvgPicture.asset(
                                      'assets/images/crown.svg',
                                      height: 10.h,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              //SizedBox(height: 16.h),
              Transform.translate(
                offset: Offset(0, -130.h),
                child: GestureDetector(
                  onTap: _disconnectVPN,
                  child: SvgPicture.asset(
                    'assets/images/tap_button.svg',
                    width: 50.w,
                    height: 50.h,
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(0, -130.h),
                child: Text(
                  'Tap to Disconnect',
                  style: TextStyle(
                      fontSize: 28.sp,
                      color: const Color(0xFF393E7A),
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
