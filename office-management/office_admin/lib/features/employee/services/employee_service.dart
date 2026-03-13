import 'package:dio/dio.dart';

import '../../../core/services/api_service.dart';
import '../models/employee_import_summary.dart';
import '../models/employee_model.dart';

class EmployeeService {
  final ApiService _api = ApiService();

  Future<List<EmployeeModel>> fetchEmployees() async {
    final response = await _api.get<dynamic>('/employees');
    final payload = Map<String, dynamic>.from(response.data as Map);
    final data = payload['data'];
    final employees = data is Map<String, dynamic> ? data['employees'] : null;

    if (employees is! List) {
      return [];
    }

    return employees
        .map((item) => EmployeeModel.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  Future<EmployeeModel> createEmployee({
    required String name,
    required String email,
    required String password,
    required String departmentId,
    String? phone,
    String? designation,
    String? employeeCode,
    String? role,
  }) async {
    final response = await _api.post(
      '/employees',
      {
        'name': name.trim(),
        'email': email.trim().toLowerCase(),
        'password': password,
        'departmentId': departmentId,
        'phone': phone?.trim(),
        'designation': designation?.trim(),
        'employeeCode': employeeCode?.trim(),
        'role': role,
      },
    );

    final payload = Map<String, dynamic>.from(response.data as Map);
    final data = Map<String, dynamic>.from(payload['data'] as Map);
    return EmployeeModel.fromJson(Map<String, dynamic>.from(data['employee'] as Map));
  }

  Future<EmployeeModel> updateEmployee({
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
    final response = await _api.put<dynamic>(
      '/employees/$id',
      data: {
        'name': name.trim(),
        'email': email.trim().toLowerCase(),
        'password': password?.trim().isEmpty ?? true ? null : password?.trim(),
        'departmentId': departmentId,
        'phone': phone?.trim(),
        'designation': designation?.trim(),
        'employeeCode': employeeCode?.trim(),
        'role': role,
      },
    );

    final payload = Map<String, dynamic>.from(response.data as Map);
    final data = Map<String, dynamic>.from(payload['data'] as Map);
    return EmployeeModel.fromJson(Map<String, dynamic>.from(data['employee'] as Map));
  }

  Future<void> deleteEmployee(String id) async {
    await _api.delete<dynamic>('/employees/$id');
  }

  Future<EmployeeImportSummary> importEmployees({
    required List<int> bytes,
    required String fileName,
  }) async {
    final multipartFile = MultipartFile.fromBytes(
      bytes,
      filename: fileName,
    );

    final response = await _api.upload(
      '/employees/import',
      data: {
        'file': multipartFile,
      },
    );

    final payload = Map<String, dynamic>.from(response.data as Map);
    final data = Map<String, dynamic>.from(payload['data'] as Map);
    return EmployeeImportSummary.fromJson(
      Map<String, dynamic>.from(data['summary'] as Map),
    );
  }
}
