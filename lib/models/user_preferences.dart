class UserPreferences {
  final String userID;
  final bool openVPN;
  final bool ipSec;
  final bool issr;
  final bool blockInternet;
  final bool connectOnStart;
  final bool showNotification;


  UserPreferences({
    required this.userID,
    required this.openVPN,
    required this.ipSec,
    required this.issr,
    required this.blockInternet,
    required this.connectOnStart,
    required this.showNotification,
  });


  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'openVPN': openVPN ? 1 : 0,
      'IPSec': ipSec ? 1 : 0,
      'ISSR': issr ? 1 : 0,
      'blockInternet': blockInternet ? 1 : 0,
      'connectOnStart': connectOnStart ? 1 : 0,
      'showNotification': showNotification ? 1 : 0,
    };
  }


  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      userID: map['userID'],
      openVPN: map['openVPN'] == 1,
      ipSec: map['IPSec'] == 1,
      issr: map['ISSR'] == 1,
      blockInternet: map['blockInternet'] == 1,
      connectOnStart: map['connectOnStart'] == 1,
      showNotification: map['showNotification'] == 1,
    );
  }
}
