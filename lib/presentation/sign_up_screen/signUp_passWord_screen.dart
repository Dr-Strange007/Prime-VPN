import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/routes.dart';
import '../../service/api/auth_service.dart';
import '../../service/api/user_remote_service.dart';
import '../../utils/validation_utils.dart';

void main() {
  runApp(const signUpPaass());
}

class signUpPaass extends StatelessWidget {
  const signUpPaass({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: const SignUp6(),
    );
  }
}

class SignUp6 extends StatefulWidget {
  const SignUp6({super.key});

  @override
  State<SignUp6> createState() => _SignUp6State();
}

class _SignUp6State extends State<SignUp6> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final AuthService _authService = AuthService();
  final String email = Get.arguments['email'] ?? '';
  final arguments = Get.arguments as Map<String, dynamic>?;

  String? _passwordError;
  String? _confirmPasswordError;
  bool _obscureCurrentPassword = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

void _validateAndCreateAccount() async {
  final password = _passwordController.text;
  final currentPassword = _currentPasswordController.text;
  final confirmPassword = _confirmPasswordController.text;

  setState(() {
    _passwordError = ValidationUtils.validatePassword(password);
    _confirmPasswordError =
        ValidationUtils.validateConfirmPassword(password, confirmPassword);
  });

  if (_passwordError == null && _confirmPasswordError == null) {
    try {
      if (currentPassword.isEmpty) {
        // If currentPassword is not provided, attempt to sign up
        await _authService.signUp(email: email, password: password, flag: true);
        Get.toNamed(AppRoutes.guestHome);
      } else {
        // Create an instance of UserRemoteService
        final userRemoteService = UserRemoteService();
        
        // Call updatePassword on the instance
        await userRemoteService.updatePassword(
          currentPass: currentPassword,
          newPass: password,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password updated successfully'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().contains('registered')
                ? 'This email is already registered, try with a new one'
                : 'Failed to update password: ${e.toString()}',
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    final fromProfilePage = arguments?['fromProfilePage'] ?? false;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            if (fromProfilePage) const SizedBox(height: 100),
            // App Logo
            Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Password Fields
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  if (fromProfilePage)
                    TextField(
                      controller: _currentPasswordController,
                      obscureText: _obscureCurrentPassword,
                      decoration: InputDecoration(
                        hintText: 'Current Password',
                        prefixIcon:
                            const Icon(Icons.lock_outline, color: Colors.grey),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureCurrentPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureCurrentPassword =
                                  !_obscureCurrentPassword;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide:
                              const BorderSide(color: Color(0xFFE2DBDA)),
                        ),
                        errorText: _passwordError,
                      ),
                    ),
                  const SizedBox(height: 14),
                  // Password Field
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: fromProfilePage ? 'New Password' : 'Password',
                      prefixIcon:
                          const Icon(Icons.lock_outline, color: Colors.grey),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFFE2DBDA)),
                      ),
                      errorText: _passwordError,
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Confirm Password Field
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      hintText: fromProfilePage
                          ? 'Confirm New Password'
                          : 'Confirm Password',
                      prefixIcon:
                          const Icon(Icons.lock_outline, color: Colors.grey),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFFE2DBDA)),
                      ),
                      errorText: _confirmPasswordError,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // Create Account Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _validateAndCreateAccount,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF393E7A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    fromProfilePage ? 'Update Password' : 'Create account',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            // Sign In Text
            if (!fromProfilePage)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: Color(0xFF545454),
                        fontSize: 12,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.signIn);
                      },
                      child: const Text(
                        ' Sign in',
                        style: TextStyle(
                          color: Color(0xFF393E7A),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 40),
            // Privacy Policy Text
            if (!fromProfilePage)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'By creating an account, you agree to our ',
                        style: TextStyle(
                          color: Color(0xFF8A8A8A),
                          fontSize: 10,
                        ),
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: Color(0xFFEC8304),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                            ', which outlines how we handle your personal data and browsing information to ensure secure and private access to the VPN service.',
                        style: TextStyle(
                          color: Color(0xFF8A8A8A),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
