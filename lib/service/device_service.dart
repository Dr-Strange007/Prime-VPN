import 'package:shared_preferences/shared_preferences.dart';

class DeviceService {
  Future<bool> checkGuestStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString('guest_device_id');
    return deviceId != null;
  }

  Future<void> removeDeviceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('guest_device_id');
  }

}
