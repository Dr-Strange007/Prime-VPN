import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../controllers/openvpn_controller.dart';
import 'package:workmanager/workmanager.dart';

const countdownTaskName = "com.example.bdix_vpn.countdownTask";
const stopVpnTaskName = "com.example.bdix_vpn.stopVpnTask";

const String prefKeyTimeRemaining = 'timeRemaining';
const String prefKeyTimerStartTime = 'timerStartTime';


class TimerNotifier extends StateNotifier<int> {


  Timer? _timer;
  bool _adTriggered = false;
  bool _adShownForSession = false;
  bool _dialogTriggered = false;
  bool _normalDialogTriggered = false;

  final OpenVPNController vpnController = Get.find<OpenVPNController>();

  bool get shouldShowAd => !_adTriggered && state == 359 && !_adShownForSession;
  bool get signUpDialogShow => _dialogTriggered;
  bool get normalSignUpDialogShow => _normalDialogTriggered;

  TimerNotifier() : super(0) {
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getInt(prefKeyTimeRemaining) ?? 3600;

    int? startTime = prefs.getInt(prefKeyTimerStartTime);
    if (startTime != null) {
      int elapsedSeconds =
          ((DateTime.now().millisecondsSinceEpoch - startTime) / 1000).round();
      state = (state - elapsedSeconds).clamp(0, 3600);
    }

    if (state > 0) {
      startTimer(); // Resume timer if needed
    }
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(prefKeyTimeRemaining, state);
    prefs.setInt(prefKeyTimerStartTime, DateTime.now().millisecondsSinceEpoch);
  }

  void startTimer() {
    if (_timer != null) return; // Prevent restarting if already running

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (state > 0) {
        state -= 1;
        await _saveState();

        // Check for ad trigger (existing logic)
        if (state == 359 && !_adTriggered && !_adShownForSession) {
          _adTriggered = true;
          _adShownForSession = true;
        }

        if (state == 359 && !_dialogTriggered) {
          _dialogTriggered = true;
        }

        if (state == 358 && !_normalDialogTriggered) {
          _normalDialogTriggered = true;
        }
      } else {
        _timer?.cancel();
        _timer = null;
        await _scheduleVpnDisconnection();
      }
    });
        // Register background task after starting the in-app timer
    _registerBackgroundTask();
  }

  Future<void> _scheduleVpnDisconnection() async {
    // Schedule a one-time task to disconnect the VPN
    await Workmanager().registerOneOffTask(
      stopVpnTaskName,
      stopVpnTaskName, // Simple task name, can be the same as the unique name
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
    print("VPN disconnection task scheduled.");
  }

  // Method to handle the VPN disconnection, to be called by WorkManager
  static Future<void> handleVpnDisconnection() async {
    final vpnController = Get.find<OpenVPNController>();
    if (vpnController.isConnected.value) {
      try {
        await vpnController.disconnect();
        print("VPN Disconnected by WorkManager task.");
      } catch (e) {
        print("Error disconnecting VPN: $e");
      }
    }
  }

  // Start the timer and background task
  // Future<void> startTimerAndRegisterBackgroundTask() async {
  //   startTimer(); // Start the in-app timer
  //   await _registerBackgroundTask(); // Start the background task
  // }

  // Stop the timer
  Future<void> stopTimer() async {
    _timer?.cancel();
    _timer = null;
    await _saveState();
    // Cancel the background task when the timer is stopped manually
    await Workmanager().cancelByUniqueName(countdownTaskName);
  }

  Future<void> _registerBackgroundTask() async {
    await Workmanager().registerPeriodicTask(
      countdownTaskName,
      countdownTaskName, // Simple task name, can be the same as the unique name
      frequency: Duration(minutes: 15), // Check every 15 minutes
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void addExtraTime(int seconds) {
    state += seconds;
    _saveState(); // Save state after adding time
  }

  void resetAdFlag() {
    _adShownForSession = false;
    _adTriggered = false;
    _dialogTriggered = false;
    _normalDialogTriggered = false;
  }

  void resetTimer() {
    stopTimer();
    state = 3600;
    _saveState(); // Save state after resetting
  }
}

final timerProvider = StateNotifierProvider<TimerNotifier, int>((ref) {
  return TimerNotifier();
});