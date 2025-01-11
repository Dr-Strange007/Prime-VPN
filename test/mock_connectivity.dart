import 'dart:async';

import 'package:bdix_vpn/service/connectivity_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class MockConnectivityService implements ConnectivityService {
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  @override
  Stream<bool> get connectivityStream => _controller.stream;

  // Add a method to control the stream in your mock
  void emitConnectivityStatus(bool isConnected) {
    _controller.add(isConnected);
  }

  @override
  Future<bool> checkInitialConnectivity() async {
    // You can return true or false depending on your test case
    return true; 
  }

  @override
  void dispose() {
    _controller.close();
  }

  // You don't need these in the mock as you're controlling the stream directly
  @override
  Connectivity get _connectivity => throw UnimplementedError(); 

  @override
  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    throw UnimplementedError();
  }
}