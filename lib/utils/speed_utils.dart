import 'package:flutter/services.dart';
import 'dart:async';

class Speed {
  static const platform = MethodChannel('com.example.bdix_vpn/trafficStats');

  int bytesSent = 0;
  int bytesReceived = 0;

  Timer? _timer;
  int previousSent = 0;
  int previousReceived = 0;

  String uploadSpeedKB = "0.00 KB/s";
  String downloadSpeedKB = "0.00 KB/s";

  int sessionStartBytesSent = 0;
  int sessionStartBytesReceived = 0;




  Future<void> startMonitoring() async {

    final Map<Object?, Object?> trafficStats = await platform.invokeMethod('getTrafficStats');
    final Map<String, dynamic> castedTrafficStats = Map<String, dynamic>.from(trafficStats);

    sessionStartBytesSent = castedTrafficStats['bytesSent'] ?? 0;
    sessionStartBytesReceived = castedTrafficStats['bytesReceived'] ?? 0;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      await updateTrafficStats();
    });
  }

  Future<int> stopMonitoring() async {
    _timer?.cancel();
    final Map<Object?, Object?> trafficStats = await platform.invokeMethod('getTrafficStats');
    final Map<String, dynamic> castedTrafficStats = Map<String, dynamic>.from(trafficStats);

    int sessionEndBytesSent = castedTrafficStats['bytesSent'] ?? 0;
    int sessionEndBytesReceived = castedTrafficStats['bytesReceived'] ?? 0;

   int sessionDataUsedBytes = (sessionEndBytesSent - sessionStartBytesSent) +
        (sessionEndBytesReceived - sessionStartBytesReceived);
return sessionDataUsedBytes;
  }

  Future<void> updateTrafficStats() async {
    try {
      final Map<Object?, Object?> trafficStats = await platform.invokeMethod('getTrafficStats');
      final Map<String, dynamic> castedTrafficStats = Map<String, dynamic>.from(trafficStats);

      int currentSent = castedTrafficStats['bytesSent'] ?? 0;
      int currentReceived = castedTrafficStats['bytesReceived'] ?? 0;

      if (previousSent == 0 && previousReceived == 0) {
        previousSent = currentSent;
        previousReceived = currentReceived;
        return;
      }


      int uploadSpeed = currentSent - previousSent;
      int downloadSpeed = currentReceived - previousReceived;

      previousSent = currentSent;
      previousReceived = currentReceived;


      bytesSent = currentSent;
      bytesReceived = currentReceived;

      uploadSpeedKB = formatSpeed(uploadSpeed);
      downloadSpeedKB = formatSpeed(downloadSpeed);

      print("Upload Speed: $uploadSpeedKB");
      print("Download Speed: $downloadSpeedKB");

    } on PlatformException catch (e) {
      print("Failed to get traffic stats: '${e.message}'");
    }
  }

  String formatSpeed(int bytes) {
    // Directly convert bytes to kilobytes (KB/s)
    double kilobytes = bytes / 1;

    if (kilobytes < 1024) {
      return "${kilobytes.toStringAsFixed(2)} KB/s";
    } else {
      // If the speed is greater than 1024 KB (1 MB), format it as MB
      double megabytes = kilobytes / 1024.0;
      return "${megabytes.toStringAsFixed(2)} MB/s";
    }
  }

}

