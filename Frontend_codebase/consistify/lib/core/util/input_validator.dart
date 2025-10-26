// consistify_frontend/lib/core/util/input_validator.dart

class InputValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  static String? validateConfirmPassword(String password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Confirm password cannot be empty';
    }
    if (confirmPassword != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username cannot be empty';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters long';
    }
    return null;
  }

  static String? validateNotificationTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'Notification time cannot be empty';
    }
 
    if (!RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$').hasMatch(value)) {
      return 'Enter a valid time in HH:MM format (e.g., 18:00)';
    }
    return null;
  }

  static String? validatePlatformUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Platform username cannot be empty';
    }
    if (value.length < 2) {
      return 'Platform username must be at least 2 characters long';
    }
    
    return null;
  }
}