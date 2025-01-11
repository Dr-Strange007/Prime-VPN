import 'package:bdix_vpn/service/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  Future<void> storeUserType(String userType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userType', userType);
  }

  Future<bool> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    final userType = prefs.getString('userType');
    print("User type $userType");
    if(userType==null)
      {
        return true;
      }
    return false;
  }

  Future<void> removeUserType() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userType');
  }


  Future<String?> getUserId() async {
    final userType = await getUserType();
    if (userType == true) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('guest_device_id');
    } else {
      return await TokenService().decodeUserId();
    }
  }

}
