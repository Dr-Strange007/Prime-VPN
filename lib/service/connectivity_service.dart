import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../routes/routes.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectivityStreamController =
  StreamController<bool>.broadcast();

  Timer? _debounceTimer;

  ConnectivityService() {
    _checkInitialConnectivity();


    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _handleConnectivityChange(result);
    });
  }

  Stream<bool> get connectivityStream => _connectivityStreamController.stream;

  Future<void> _checkInitialConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _handleConnectivityChange(result);
    } catch (e) {
      _connectivityStreamController.add(false);
    }
  }

  void _handleConnectivityChange(ConnectivityResult result) {
    _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(seconds: 2), () {
      if (_connectivityStreamController.isClosed) return;
      bool isConnected = result != ConnectivityResult.none;
      _connectivityStreamController.add(isConnected);

      if (!isConnected) {
        Get.toNamed(AppRoutes.connectionFailedScreen);
      }
    });
  }

  void dispose() {
    _connectivityStreamController.close();
  }
}

