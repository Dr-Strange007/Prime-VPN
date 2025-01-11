import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/routes.dart';
import '../../service/api/auth_service.dart';
import '../../utils/validation_utils.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();
  final String email = Get.arguments['email'] ?? '';

  String? _passwordError;
  String? _confirmPasswordError;

  void _resetPassword() async {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    setState(() {
      _passwordError = ValidationUtils.validatePassword(password);
      _confirmPasswordError = ValidationUtils.validateConfirmPassword(password, confirmPassword);
    });

    if (_passwordError == null && _confirmPasswordError == null) {
      try {
        await _authService.resetPassword(email: email, newPassword: password);
        Get.toNamed(AppRoutes.signIn);
      } catch (e) {
        Get.snackbar(
          'Error',
          e.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

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
            Navigator.pop(context);
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
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 120,
                  width: 120,
                ),
              ),
              const SizedBox(height: 40),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter New Password',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFDBD2D1),
                  ),
                  prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFDBD2D1)),
                  suffixIcon: const Icon(Icons.visibility_off, color: Color(0xFFDBD2D1)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(
                      color: Color(0xFFDBD2D1),
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
                  errorText: _passwordError,
                ),
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Confirm Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Confirm New Password',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFDBD2D1),
                  ),
                  prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFDBD2D1)),
                  suffixIcon: const Icon(Icons.visibility_off, color: Color(0xFFDBD2D1)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(
                      color: Color(0xFFDBD2D1),
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
                  errorText: _confirmPasswordError,
                ),
              ),
              const SizedBox(height: 40),
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
                  onPressed: _resetPassword,
                  child: const Text(
                    'Confirm',
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
    );
  }
}
