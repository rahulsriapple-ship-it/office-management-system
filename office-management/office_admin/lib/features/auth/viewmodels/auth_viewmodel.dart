import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../core/services/api_exception.dart';
import '../models/forgot_password_model.dart';
import '../models/login_model.dart';
import '../models/reset_password_model.dart';
import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _service = AuthService();

  bool isInitialized = false;
  bool isAuthenticated = false;
  bool isLoading = false;
  String? errorMessage;
  String? successMessage;
  String? resetToken;
  String? authToken;

  Future<void> restoreSession() async {
    isInitialized = false;
    notifyListeners();

    final hasToken = await _service.hasActiveSession();

    if (!hasToken) {
      isAuthenticated = false;
      authToken = null;
      isInitialized = true;
      notifyListeners();
      return;
    }

    try {
      final result = await _service.getCurrentUser();
      final data = result['data'];

      if (data is Map<String, dynamic>) {
        final storedToken = await _service.getSavedToken();
        authToken = storedToken;
        isAuthenticated = storedToken != null && storedToken.isNotEmpty;
      } else {
        isAuthenticated = false;
      }
    } catch (_) {
      await _service.logout();
      isAuthenticated = false;
      authToken = null;
    }

    isInitialized = true;
    notifyListeners();
  }

  Future<bool> login(LoginModel model) async {
    return _execute(
      action: () => _service.login(model),
      fallbackSuccessMessage: 'Login successful',
      onSuccess: (result) {
        final data = result['data'];
        if (data is Map<String, dynamic>) {
          authToken = data['token']?.toString();
          isAuthenticated = authToken != null && authToken!.isNotEmpty;
        }
      },
    );
  }

  Future<bool> forgotPassword(ForgotPasswordModel model) async {
    return _execute(
      action: () => _service.forgotPassword(model),
      fallbackSuccessMessage: 'Password reset flow started',
      onSuccess: (result) {
        final data = result['data'];
        if (data is Map<String, dynamic>) {
          resetToken = data['resetToken'] as String?;
        }
      },
    );
  }

  Future<bool> resetPassword(ResetPasswordModel model) async {
    return _execute(
      action: () => _service.resetPassword(model),
      fallbackSuccessMessage: 'Password reset successfully',
    );
  }

  Future<bool> _execute({
    required Future<Map<String, dynamic>> Function() action,
    required String fallbackSuccessMessage,
    void Function(Map<String, dynamic> result)? onSuccess,
  }) async {
    try {
      errorMessage = null;
      successMessage = null;
      isLoading = true;
      notifyListeners();

      final result = await action();
      successMessage = (result['message'] as String?) ?? fallbackSuccessMessage;
      onSuccess?.call(result);

      isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      errorMessage = _resolveErrorMessage(error);
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _service.logout();
    isAuthenticated = false;
    authToken = null;
    notifyListeners();
  }

  String _resolveErrorMessage(Object error) {
    if (error is ApiException) {
      return error.message;
    }

    if (error is DioException) {
      final responseData = error.response?.data;
      if (responseData is Map<String, dynamic>) {
        final message = responseData['message'];
        if (message is String && message.isNotEmpty) {
          return message;
        }
      }

      return error.message ?? 'Request failed. Please try again.';
    }
    return 'Something went wrong. Please try again.';
  }
}
