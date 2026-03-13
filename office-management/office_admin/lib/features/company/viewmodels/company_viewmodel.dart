import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../core/services/api_exception.dart';
import '../models/company_model.dart';
import '../services/company_service.dart';

class CompanyViewModel extends ChangeNotifier {
  final CompanyService _service = CompanyService();

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  Future<bool> registerCompany(CompanyModel model) async {
    try {
      errorMessage = null;
      successMessage = null;
      isLoading = true;
      notifyListeners();

      final result = await _service.registerCompany(model);
      successMessage =
          (result['message'] as String?) ?? 'Company registered successfully';

      isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      errorMessage = _resolveErrorMessage(e);
      isLoading = false;
      notifyListeners();

      return false;
    }
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
