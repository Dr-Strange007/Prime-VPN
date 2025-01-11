import 'package:bdix_vpn/presentation/connected_screen/premium_connected_screen.dart';
import 'package:bdix_vpn/presentation/connection_screen/connection_failed_screen.dart';
import 'package:bdix_vpn/presentation/home_screen/guest_home_screen.dart';
import 'package:bdix_vpn/presentation/profile_screen/guest_profile_screen.dart';
import 'package:bdix_vpn/presentation/profile_screen/normal_login_profile_screen.dart';
import 'package:bdix_vpn/presentation/setting_screen/guest_setting_screen.dart';
import 'package:bdix_vpn/presentation/subscription_screen/premium_subscription_screen.dart';
import 'package:get/get.dart';
import '../middleware/auth_middleware.dart';
import '../presentation/connected_screen/normal_connected_screen.dart';
import '../presentation/connection_screen/connection_report_screen.dart';
import '../presentation/forgot_password/forgot_password.dart';
import '../presentation/forgot_password/forgot_password2.dart';
import '../presentation/home_screen/normal_home_screen.dart';
import '../presentation/one_time_splash_screen/one_time_splash_screen.dart';
import '../presentation/server_screen/guest_server_screen.dart';
import '../presentation/server_screen/normal_server_screen.dart';
import '../presentation/setting_screen/normal_setting_screen.dart';
import '../presentation/setting_screen/premium_setting_screen.dart';
import '../presentation/sign_in_screen/sign_in_screen.dart';
import '../presentation/sign_up_screen/signUp_otp_screen.dart';
import '../presentation/sign_up_screen/signUp_passWord_screen.dart';
import '../presentation/sign_up_screen/sign_up_screen1.dart';
import '../presentation/welcome_screen/welcome_screen.dart';

class AppRoutes {
  static const splash = '/splash';
  static const welcome = '/welcome';
  static const signIn = '/signIn';
  static const forgotPassword = '/forgotPassword';
  static const forgotPassword2 = '/forgotPassword2';
  static const signUp1 = '/signUp1';
  static const signUpOTP = '/signUpOTP';
  static const signUpPass = '/signUpPass';
  static const guestHome = '/guestHome';
  static const normalConnectHome = '/normalConnectHome';
  static const connectionReportScreen = '/connectionReportScreen';
  static const guestServerScreen = '/guestServerScreen';
  static const normalServerScreen = '/normalServerScreen';
  static const guestProfileScreen = '/guestProfileScreen';
  static const normalLoginProfileScreen = '/normalLoginProfileScreen';
  static const normalConnectedScreen = '/normalConnectedScreen';
  static const guestSettingScreen = '/guestSettingScreen';
  static const normalSettingScreen = '/normalSettingScreen';
  static const premiumSettingScreen = '/premiumSettingScreen';
  static const premiumSubscriptionScreen = '/premiumSubscriptionScreen';
  static const connectionFailedScreen = '/connectionFailedScreen';
  static const premiumConnectedScreen = '/premiumConnectedScreen';
  static const guestHomeScreen = '/guestHomeScreen';

  static final routes = [
    GetPage(name: splash, page: () => OneTimeSplashScreen()),
    GetPage(name: welcome, page: () => WelcomeScreen()),
    GetPage(name: signIn, page: () => SignInScreen()),
    GetPage(name: forgotPassword, page: () => const ForgetPasswordApp()),
    GetPage(name: forgotPassword2, page: () => ResetPasswordScreen()),
    GetPage(name: signUp1, page: () => const SignUpScreen()),
    GetPage(name: signUpOTP, page: () => const SignUp3()),
    GetPage(name: signUpPass, page: () => const SignUp6()),
    GetPage(
      name: guestHome,
      page: () => GuestHome(),
      middlewares: [
        AuthMiddleware(), // Apply middleware here
      ],
    ),
    GetPage(
        name: connectionReportScreen,
        page: () => const ConnectionReportScreen()),
    GetPage(
      name: guestServerScreen,
      page: () => const GuestServerScreen(),
      middlewares: [
        AuthMiddleware(),
      ],
    ),
    GetPage(name: normalServerScreen, page: () => const NormalServerScreen()),
    GetPage(
      name: guestProfileScreen,
      page: () => const GuestProfileScreen(),
      middlewares: [
        AuthMiddleware(),
      ],
    ),
    GetPage(
        name: normalLoginProfileScreen,
        page: () => const NormalLoginProfileScreen()),
    GetPage(
        name: normalConnectedScreen, page: () => const ConnectedDeviceScreen()),
    GetPage(name: guestSettingScreen, page: () => const GuestSettingScreen()),
    GetPage(name: normalSettingScreen, page: () => const NormalSettingScreen()),
    GetPage(
        name: premiumSettingScreen, page: () => const PremiumSettingScreen()),
    GetPage(
        name: premiumSubscriptionScreen,
        page: () => const PremiumSubscriptionScreen()),
    GetPage(
        name: connectionFailedScreen,
        page: () => const ConnectionFailedScreen()),
    GetPage(
        name: premiumConnectedScreen,
        page: () => const PremiumConnectedScreen()),
    GetPage(
      name: guestHomeScreen,
      page: () => const GuestHomeScreen(),
      middlewares: [
        AuthMiddleware(),
      ],
    )
  ];
}
