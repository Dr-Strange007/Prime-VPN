import 'package:flutter/material.dart';

class ConnectionRequestDialog extends StatelessWidget {
  const ConnectionRequestDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)), // Rounded corners
      ),
      title: const Text(
        'Connection Request',
        style: TextStyle(fontSize: 18),
      ),
      content: const Text(
        'By allowing this request, the VPN will route your internet traffic through its encrypted servers, ensuring your privacy and security. Please note that your network activity will be monitored and secured through the VPN while connected. Tap "OK" to proceed with establishing a secure connection.',
        style: TextStyle(fontSize: 14, color: Color(0xFF8A8A8A)),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cancel action
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Color(0xFF393E7A), fontSize: 16),
          ),
        ),
        const SizedBox(width: 50,),
        SizedBox(
          width: 154,
          height: 44,
          child: OutlinedButton(
            onPressed: () {
              // Add your OK action logic here
              Navigator.of(context).pop();
            },
            style: OutlinedButton.styleFrom(
              side:
                  const BorderSide(color: Colors.blue, width: 1), // Blue border
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(5), // Rounded corners for button
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            ),
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
