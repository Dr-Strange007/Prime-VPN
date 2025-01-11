import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';

import '../models/user_preferences.dart';
import '../service/database/database_helper.dart';
import '../service/user_service.dart';


class OpenVPNController extends GetxController {

  final UserService _userService = UserService();
  late final OpenVPN engine;

  final Rx<VpnStatus?> vpnStatus = Rx<VpnStatus?>(null); // Observable status
  final RxString vpnStage = "Disconnected".obs; // Observable stage
  final RxBool isConnected = false.obs; // Observable connection status

  final RxString vpnConfig = "".obs; // VPN configuration
  static const String defaultVpnUsername = "root"; // Default VPN username
  static const String defaultVpnPassword = "vpnserver123456"; // Default VPN password

  final RxBool vpnConnected = false.obs;


  static const MethodChannel _killSwitchChannel = MethodChannel('com.example.bdix_vpn/killSwitch');



  OpenVPNController() {
    engine = OpenVPN(
      onVpnStatusChanged: (VpnStatus? status) {
        vpnStatus.value = status;
        isConnected.value = status?.connectedOn != null;
        vpnConnected.value = isConnected.value;
        debugPrint("VPN Status Changed: $status");
      },
      onVpnStageChanged: (VPNStage stage, String raw) {
        vpnStage.value = stage.name;
        debugPrint("VPN Stage Changed: ${stage.name}");
      },
    );
  }

  Future<void> init() async {
    try {
      await engine.initialize(
        groupIdentifier: "group.com.laskarmedia.vpn",
        providerBundleIdentifier: "id.laskarmedia.openvpnFlutterExample.VPNExtension",
        localizedDescription: "VPN by Nizwar",
        lastStage: (VPNStage stage) => vpnStage.value = stage.name,
        lastStatus: (VpnStatus? status) {
          vpnStatus.value = status;
          isConnected.value = status?.connectedOn != null;
          vpnConnected.value = isConnected.value;
        },
      );
      debugPrint("VPN initialized successfully.");
      await _conditionalKillSwitchCheck();
    } catch (e) {
      debugPrint("Failed to initialize VPN: $e");
    }
  }

  Future<void> connect() async {
    if (vpnConfig.value.isEmpty) {
      vpnStage.value = "Config not loaded";
      debugPrint("VPN configuration is empty.");
      return;
    }
    try {
      await engine.connect(
        vpnConfig.value,
        "MyVPNProfile",
        username: defaultVpnUsername,
        password: defaultVpnPassword,
        certIsRequired: true,
      );
      debugPrint("VPN connection initiated.");
      vpnConnected.value = true;
      await _conditionalKillSwitchCheck();
    } catch (error) {
      vpnStage.value = "Disconnected";
      vpnConnected.value = false;
      debugPrint("Failed to connect VPN: $error");
    }
  }

  Future<void> disconnect() async {
    engine.disconnect();
    isConnected.value = false;
    vpnStage.value = "Disconnected";
    vpnConnected.value = false;
    debugPrint("VPN disconnected manually.");
    await _conditionalKillSwitchCheck();

  }

  Future<void> _conditionalKillSwitchCheck() async {
    try {
      final DatabaseHelper dbHelper = DatabaseHelper();
      final String? userId = await _userService.getUserId();
      final UserPreferences? preferences = await dbHelper.getUserPreferences(userId!);

      if (preferences?.blockInternet == true) {
        final String result = await _killSwitchChannel.invokeMethod('checkVpnStatus');
        debugPrint("Kill switch result: $result");

        if (result == "VPN disconnected due to kill switch") {
          debugPrint("Kill switch triggered: Internet blocked due to VPN disconnection.");
        }
      } else {
        debugPrint("Kill switch not triggered: blockInternet is disabled.");
      }
    } on PlatformException catch (e) {
      debugPrint("Failed to check VPN kill switch status: ${e.message}");
    }
  }


}