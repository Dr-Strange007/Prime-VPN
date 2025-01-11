import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RewardedAdDialog extends StatelessWidget {
  final VoidCallback onWatchAd;

  const RewardedAdDialog({super.key, required this.onWatchAd});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Watch Ad to Get Extra Time',
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
      ),
      content: Text(
        'Get an extra 5 minutes by watching an ad.',
        style: TextStyle(fontSize: 14.sp),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close dialog
          },
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.red, fontSize: 14.sp),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close dialog
            onWatchAd(); // Trigger the callback
          },
          child: Text(
            'Watch Ad',
            style: TextStyle(fontSize: 14.sp),
          ),
        ),
      ],
    );
  }
}
