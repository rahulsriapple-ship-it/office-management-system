class AppValidators {
  static String? requiredField(String? value, {required String label}) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required';
    }

    return null;
  }

  static String? companyName(String? value) {
    final requiredError = requiredField(value, label: 'Company name');
    if (requiredError != null) {
      return requiredError;
    }

    if (value!.trim().length < 2) {
      return 'Company name must be at least 2 characters';
    }

    return null;
  }

  static String? personName(String? value, {required String label}) {
    final requiredError = requiredField(value, label: label);
    if (requiredError != null) {
      return requiredError;
    }

    if (value!.trim().length < 2) {
      return '$label must be at least 2 characters';
    }

    return null;
  }

  static String? email(String? value) {
    final requiredError = requiredField(value, label: 'Email');
    if (requiredError != null) {
      return requiredError;
    }

    final emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailPattern.hasMatch(value!.trim())) {
      return 'Enter a valid email address';
    }

    return null;
  }

  static String? password(String? value) {
    final requiredError = requiredField(value, label: 'Password');
    if (requiredError != null) {
      return requiredError;
    }

    if (value!.trim().length < 8) {
      return 'Password must be at least 8 characters';
    }

    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    if (value.trim().length < 7) {
      return 'Phone number looks too short';
    }

    return null;
  }
}
