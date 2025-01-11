import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../presentation/sign_in_screen/sign_in_screen.dart';
import '../routes/routes.dart';
import '../service/device_service.dart';
import '../utils/scaffold_messenger_utils.dart';


void showSignUpDialog(BuildContext context,bool timeOver ) async {

  final DeviceService deviceService = DeviceService();

  final result = await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign Up Required'),
        content: const Text('To continue using the app, please sign up.'),
        actions: [
          TextButton(
            onPressed: () async {
              if(timeOver){
                deviceService.removeDeviceId();
                Navigator.pop(context, true);
                Get.offAll(SignInScreen());
              }
              else{
                Navigator.pop(context, true);
                showScaffoldMessage(context, "You have to signup first to be premium user");
              }

            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );

  if (result == null) {
    if(timeOver){
      deviceService.removeDeviceId();
      Get.offAll(SignInScreen());
    }


  }
}

