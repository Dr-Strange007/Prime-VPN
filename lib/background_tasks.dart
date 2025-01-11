import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:bdix_vpn/controllers/openvpn_controller.dart';

import 'providers/timer_provider.dart';
 // Import timer_provider.dart

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case countdownTaskName:
        SharedPreferences prefs = await SharedPreferences.getInstance();
        // Now you can access _prefKeyTimeRemaining
        int timeRemaining = prefs.getInt(prefKeyTimeRemaining) ?? 3600;
        if (timeRemaining > 0) {
          timeRemaining -= 1;
          await prefs.setInt(prefKeyTimeRemaining, timeRemaining);
          print("Countdown task executed. Time remaining: $timeRemaining");
        } else {
          // If the timer has reached 0, schedule the VPN disconnection task
          await Workmanager().registerOneOffTask(
            stopVpnTaskName,
            stopVpnTaskName,
            constraints: Constraints(
              networkType: NetworkType.connected,
            ),
          );
        }
        break;
      case stopVpnTaskName:
        if (!Get.isRegistered<OpenVPNController>()) {
          Get.put(OpenVPNController());
        }
        // Now safe to use Get to find the controller
        TimerNotifier.handleVpnDisconnection();
        break;
    }
    return Future.value(true);
  });
}