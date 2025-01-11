import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/openvpn_controller.dart';

class DisconnectDialog extends StatelessWidget {
  const DisconnectDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final vpnController = Get.find<OpenVPNController>();
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      content: const Text(
        'Would you like to disconnect?',
        style: TextStyle(fontSize: 18),
      ),
      actions: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'CANCEL',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            const VerticalDivider(
              width: 1,
              color: Colors.grey,
              thickness: 1,
            ),
            const SizedBox(width: 50,),
            TextButton(
              onPressed: () {
                vpnController.disconnect();
                Navigator.of(context).pop(true);
              },
              child: const Text(
                'DISCONNECT',
                style: TextStyle(color: Color(0xFF393E7A), fontSize: 16),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
