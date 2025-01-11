import 'dart:async';
import 'dart:io';

import 'package:bdix_vpn/presentation/connection_screen/connection_failed_screen.dart';
import 'package:bdix_vpn/providers/timer_provider.dart';
import 'package:bdix_vpn/service/connectivity_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'controllers/openvpn_controller.dart';
import 'routes/routes.dart';
import 'package:workmanager/workmanager.dart';
import 'background_tasks.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  MobileAds.instance.initialize();

  // Initialize WorkManager and register the callback dispatcher
  Workmanager().initialize(
    callbackDispatcher, // The top-level function from background_tasks.dart
    isInDebugMode: true, // Change to false for production
  );

  // Initialize GetX controllers
  final openVpnController = Get.put(OpenVPNController());
  await openVpnController.init();
  final connectivityService = Get.put(ConnectivityService());
  Get.put(TimerNotifier()); // Register TimerNotifier

  runApp(ProviderScope(
    child: MyApp(connectivityService: connectivityService),
  ));
}

class MyApp extends StatelessWidget {
  final ConnectivityService connectivityService;

  const MyApp({super.key, required this.connectivityService});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return StreamBuilder<bool>(
          stream: connectivityService.connectivityStream,
          builder: (context, snapshot) {
            if (snapshot.hasData && !snapshot.data!) {
              return GetMaterialApp(
                home: const ConnectionFailedScreen(),
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                  useMaterial3: true,
                ),
              );
            }
            final OpenVPNController vpnController = Get.find<OpenVPNController>();
            // Show the main app if connected
            print("object1 ${vpnController.isConnected.value}");
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              initialRoute: AppRoutes.splash,
              getPages: AppRoutes.routes,
              unknownRoute: GetPage(
                name: '/not-found',
                page: () => const Scaffold(
                  body: Center(
                    child: Text('Page not found'),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}