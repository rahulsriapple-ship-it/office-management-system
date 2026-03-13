import 'package:flutter/material.dart';

import '../../../core/services/api_exception.dart';
import '../models/department_model.dart';
import '../services/department_service.dart';

class DepartmentViewModel extends ChangeNotifier {
  final DepartmentService _service = DepartmentService();

  bool isLoading = false;
  bool isSubmitting = false;
  String? errorMessage;
  String? successMessage;
  List<DepartmentModel> departments = const [];

  Future<void> loadDepartments() async {
    try {
      errorMessage = null;
      isLoading = true;
      notifyListeners();

      departments = await _service.fetchDepartments();
    } catch (error) {
      errorMessage = _resolveErrorMessage(error);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createDepartment({
    required String name,
    String? description,
  }) async {
    try {
      errorMessage = null;
      successMessage = null;
      isSubmitting = true;
      notifyListeners();

      final department = await _service.createDepartment(
        name: name,
        description: description,
      );

      departments = [department, ...departments];
      successMessage = 'Department created successfully';
      return true;
    } catch (error) {
      errorMessage = _resolveErrorMessage(error);
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> updateDepartment({
    required String id,
    required String name,
    String? description,
  }) async {
    try {
      errorMessage = null;
      successMessage = null;
      isSubmitting = true;
      notifyListeners();

      final updatedDepartment = await _service.updateDepartment(
        id: id,
        name: name,
        description: description,
      );

      departments = departments
          .map((department) => department.id == id ? updatedDepartment : department)
          .toList();
      successMessage = 'Department updated successfully';
      return true;
    } catch (error) {
      errorMessage = _resolveErrorMessage(error);
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> deleteDepartment(String id) async {
    try {
      errorMessage = null;
      successMessage = null;
      isSubmitting = true;
      notifyListeners();

      await _service.deleteDepartment(id);
      departments = departments.where((department) => department.id != id).toList();
      successMessage = 'Department deleted successfully';
      return true;
    } catch (error) {
      errorMessage = _resolveErrorMessage(error);
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  String _resolveErrorMessage(Object error) {
    if (error is ApiException) {
      return error.message;
    }

    return 'Unable to process department request.';
  }
}
