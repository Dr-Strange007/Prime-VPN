class ValidationUtils {
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required.';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters.';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required.';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email.';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return null;
  }

  static String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Confirm Password is required.';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match.';
    }
    return null;
  }


  static String? validateOtp(List<String> otpFields) {
    if (otpFields.any((field) => field.isEmpty)) {
      return 'OTP fields cannot be empty.';
    }
    return null;
  }
}