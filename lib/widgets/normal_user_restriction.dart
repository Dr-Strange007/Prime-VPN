import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/openvpn_controller.dart';


void normalUserRestrictionUpDialog(BuildContext context) async {

  final vpnController = Get.find<OpenVPNController>();

  final result = await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Upgrade to pro'),
        content: const Text('To continue using VPN, please upgrade to pro.'),
        actions: [
          TextButton(
            onPressed: () {
              vpnController.disconnect();
              Navigator.pop(context, true);
              Get.toNamed('/guestHome');
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );

  if (result == null) {
    vpnController.disconnect();
    Get.toNamed('/guestHome');
  }
}

