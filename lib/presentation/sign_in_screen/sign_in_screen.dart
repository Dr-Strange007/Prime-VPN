import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/routes.dart';
import '../../service/api/auth_service.dart';
import '../../service/user_service.dart';
import '../../utils/validation_utils.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const SizedBox(height: 40),
                  // Logo
                  Center(
                    child: Image.asset(
                      'assets/images/logo.png', // Replace with the actual path
                      width: 120,
                      height: 120,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Email and Password Form Fields
                  CustomTextFormField(
                    controller: emailController,
                    hintText: "Email",
                    prefixIcon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    controller: passwordController,
                    hintText: "Password",
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: Icons.visibility_outlined,
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {

                        Get.toNamed(AppRoutes.forgotPassword);
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF393E7A),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Sign In Button
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
                        final emailValidation = ValidationUtils.validateEmail(emailController.text);
                        final passwordValidation = ValidationUtils.validatePassword(passwordController.text);

                        if (emailValidation != null || passwordValidation != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(emailValidation ?? passwordValidation!)),
                          );
                          return;
                        }

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const Center(child: CircularProgressIndicator()),
                        );

                        try {
                          final userType = await _authService.login(
                            email: emailController.text,
                            password: passwordController.text,
                          );

                          if (userType == "Premium") {
                            await _userService.storeUserType(userType!);
                            print('User type: $userType');
                          }

                          Navigator.of(context).pop();
                          Get.toNamed(AppRoutes.guestHome);

                        } catch (e) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Email or password is not correct")),
                          );
                        }
                      },

                      child: const Text(
                        "Sign in",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Create Account
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "Do not have an account? ",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        TextSpan(
                          text: "Create account",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF393E7A),
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.toNamed(
                                AppRoutes.signUp1);
                            },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Footer Text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "By creating an account, you agree to our ",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          TextSpan(
                            text: "Privacy Policy",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFEC8304),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text:
                                ", which outlines how we handle your personal data.",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;

  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: Colors.grey)
            : null,
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon, color: Colors.grey)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFF393E7A),
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      ),
    );
  }
}
