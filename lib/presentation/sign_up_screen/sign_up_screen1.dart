import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/routes.dart';
import '../../service/api/auth_service.dart';
import '../../utils/validation_utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {


  final TextEditingController emailController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // Logo
              Center(
                child: Image.asset(
                  'assets/images/logo.png', // Replace with your actual logo path
                  height: 150,
                  width: 150,
                ),
              ),
              const SizedBox(height: 60),
              // Email Field
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Enter Email',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFC7BFBE),
                  ),
                  prefixIcon: const Icon(Icons.email_outlined,
                      color: Color(0xFFC7BFBE)),
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
              const SizedBox(height: 35),
              // Next Button
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
                    final emailError = ValidationUtils.validateEmail(emailController.text);

                    if (emailError == null) {
                      try {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const Center(child: CircularProgressIndicator()),
                        );

                        await _authService.sendOTP(email: emailController.text);

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
                        Navigator.of(context).pop();
                        Get.toNamed(
                          AppRoutes.signUpOTP,
                          arguments: {'email': emailController.text},
                        );
                      } catch (e) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Email already registered, try with different email",
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
              const SizedBox(height: 20),
              // Already Have an Account? Sign In
              GestureDetector(
                onTap: () {
                  // Navigate to the Sign-In page
                },
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF545454),
                        ),
                      ),
                      TextSpan(
                        text: 'Sign in',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF393E7A),
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.toNamed(
                                AppRoutes.signIn);
                          },
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              // Privacy Policy Footer
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'By creating an account, you agree to our ',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF8A8A8A),
                      ),
                    ),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFEC8304),
                      ),
                    ),
                    TextSpan(
                      text:
                      ', which outlines how we handle your personal data and browsing information to ensure secure and private access to the VPN service.',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF8A8A8A),
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

