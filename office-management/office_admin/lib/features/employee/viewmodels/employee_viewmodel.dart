import 'package:flutter/material.dart';

import '../../../core/services/api_exception.dart';
import '../models/employee_import_summary.dart';
import '../models/employee_model.dart';
import '../services/employee_service.dart';

class EmployeeViewModel extends ChangeNotifier {
  final EmployeeService _service = EmployeeService();

  bool isLoading = false;
  bool isSubmitting = false;
  bool isImporting = false;
  String? errorMessage;
  String? successMessage;
  EmployeeImportSummary? lastImportSummary;
  List<EmployeeModel> employees = const [];

  Future<void> loadEmployees() async {
    try {
      errorMessage = null;
      isLoading = true;
      notifyListeners();

      employees = await _service.fetchEmployees();
    } catch (error) {
      errorMessage = _resolveErrorMessage(error);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createEmployee({
    required String name,
    required String email,
    required String password,
    required String departmentId,
    String? phone,
    String? designation,
    String? employeeCode,
    String? role,
  }) async {
    try {
      errorMessage = null;
      successMessage = null;
      isSubmitting = true;
      notifyListeners();

      final employee = await _service.createEmployee(
        name: name,
        email: email,
        password: password,
        departmentId: departmentId,
        phone: phone,
        designation: designation,
        employeeCode: employeeCode,
        role: role,
      );

      employees = [employee, ...employees];
      successMessage = 'Employee created successfully';
      return true;
    } catch (error) {
      errorMessage = _resolveErrorMessage(error);
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> updateEmployee({
    required String id,
    required String name,
    required String email,
    required String departmentId,
    String? password,
    String? phone,
    String? designation,
    String? employeeCode,
    String? role,
  }) async {
    try {
      errorMessage = null;
      successMessage = null;
      isSubmitting = true;
      notifyListeners();

      final employee = await _service.updateEmployee(
        id: id,
        name: name,
        email: email,
        departmentId: departmentId,
        password: password,
        phone: phone,
        designation: designation,
        employeeCode: employeeCode,
        role: role,
      );

      employees = employees
          .map((item) => item.id == id ? employee : item)
          .toList();
      successMessage = 'Employee updated successfully';
      return true;
    } catch (error) {
      errorMessage = _resolveErrorMessage(error);
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> deleteEmployee(String id) async {
    try {
      errorMessage = null;
      successMessage = null;
      isSubmitting = true;
      notifyListeners();

      await _service.deleteEmployee(id);
      employees = employees.where((item) => item.id != id).toList();
      successMessage = 'Employee deleted successfully';
      return true;
    } catch (error) {
      errorMessage = _resolveErrorMessage(error);
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> importEmployees({
    required List<int> bytes,
    required String fileName,
  }) async {
    try {
      errorMessage = null;
      successMessage = null;
      lastImportSummary = null;
      isImporting = true;
      notifyListeners();

      lastImportSummary = await _service.importEmployees(
        bytes: bytes,
        fileName: fileName,
      );
      successMessage = 'Employee import completed';
      await loadEmployees();
      return true;
    } catch (error) {
      errorMessage = _resolveErrorMessage(error);
      return false;
    } finally {
      isImporting = false;
      notifyListeners();
    }
  }

  String _resolveErrorMessage(Object error) {
    if (error is ApiException) {
      return error.message;
    }

    return 'Unable to process employee request.';
  }
}
