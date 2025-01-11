import 'package:bdix_vpn/service/api/user_remote_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/routes.dart';
import '../../service/api/auth_service.dart';
import '../../utils/validation_utils.dart';

void main() {
  runApp(const ForgetPasswordApp());
}

class ForgetPasswordApp extends StatelessWidget {
  const ForgetPasswordApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ForgetPasswordScreen(),
    );
  }
}

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final arguments = Get.arguments as Map<String, dynamic>?;
  final UserRemoteService _userRemoteService = UserRemoteService();

  @override
  Widget build(BuildContext context) {
    final fromProfilePage = arguments?['fromProfilePage'] ?? false;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey, // Attach the form key
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // Logo
                Center(
                  child: Image.asset(
                    'assets/images/logo.png', // Replace with your logo path
                    height: 120,
                    width: 120,
                  ),
                ),
                const SizedBox(height: 40),
                // Email Label
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Email TextField
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'name@example.com',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFC7BFBE),
                    ),
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Color(0xFFC7BFBE),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(
                        color: Color(0xFFC7BFBE),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(
                        color: Color(0xFF393E7A),
                        width: 1,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  validator: (value) => ValidationUtils.validateEmail(value),
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF393E7A),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      if (!fromProfilePage) {
                        final emailError =
                            ValidationUtils.validateEmail(emailController.text);
                        if (emailError == null) {
                          try {
                            await _authService.sendOTP(
                                email: emailController.text);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'OTP sent successfully!',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              ),
                            );
                            Get.toNamed(
                              AppRoutes.signUpOTP,
                              arguments: {
                                'email': emailController.text,
                                'isForgetPassword': true,
                              },
                            );
                          } catch (e) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Email is not registered, try with registered one",
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                emailError,
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      } else {
                        final emailError =
                            ValidationUtils.validateEmail(emailController.text);
                        if (emailError == null) {
                          try {
                            await _userRemoteService.updateEmail(email: emailController.text);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Email is updated successfully!',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              ),
                            );
                            Get.toNamed(
                              AppRoutes.normalLoginProfileScreen,
                            );
                          } catch (e) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Email is not registered, try with registered one",
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                emailError,
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFE6E7EE),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
