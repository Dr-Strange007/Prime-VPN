import 'package:flutter/material.dart';
import 'dart:async';

import 'package:get/get.dart';

import '../../routes/routes.dart';
import '../../service/api/auth_service.dart';
import '../../utils/validation_utils.dart';

void main() {
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: const SignUp3(),
    );
  }
}

class SignUp3 extends StatefulWidget {
  const SignUp3({super.key});

  @override
  _SignUp3State createState() => _SignUp3State();
}

class _SignUp3State extends State<SignUp3> {
  int _countdown = 300; // 5 minutes countdown in seconds
  late Timer _timer;

  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final String email = Get.arguments['email'] ?? '';
  final isForgetPassword = Get.arguments?['isForgetPassword'] ?? false;
  final AuthService _authService = AuthService();




  @override
  void initState() {
    super.initState();
    print(email);
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        _timer.cancel();
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  String get formattedTime {
    String minutes = (_countdown ~/ 60).toString().padLeft(2, '0');
    String seconds = (_countdown % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFE),
      body: Padding(
        padding: const EdgeInsets.only(left: 0, top: 24, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 3),

            // Title and Countdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enter PIN',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      text: 'The Code expires in ',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      children: [
                        TextSpan(
                          text: formattedTime,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // PIN Input Boxes
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  6,
                  (index) => SizedBox(
                    width: 57,
                    height: 60,
                    child: TextField(
                      controller: _controllers[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      decoration: InputDecoration(
                        counterText: "",
                        filled: true,
                        fillColor: const Color(0xFFEEEAEA),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          FocusScope.of(context).nextFocus();
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Next Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    String pin = _controllers.map((e) => e.text).join();

                    String? otpError = ValidationUtils.validateOtp(
                      _controllers
                          .map((controller) => controller.text)
                          .toList(),
                    );

                    if (otpError != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(otpError)),
                      );
                      return;
                    }

                    try {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(child: CircularProgressIndicator()),
                      );

                      await _authService.verifyOtp(email: email, otp: pin);

                      Navigator.of(context).pop();

                      if(isForgetPassword){
                        Get.toNamed(AppRoutes.forgotPassword2, arguments: {'email': email});
                      }else{
                        Get.toNamed(AppRoutes.signUpPass, arguments: {'email': email});
                      }

                    } catch (error) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Invalid OTP,try with correct one",
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF393E7A), // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
