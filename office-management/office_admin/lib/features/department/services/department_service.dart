import '../../../core/services/api_service.dart';
import '../models/department_model.dart';

class DepartmentService {
  final ApiService _api = ApiService();

  Future<List<DepartmentModel>> fetchDepartments() async {
    final response = await _api.get<dynamic>('/departments');
    final payload = Map<String, dynamic>.from(response.data as Map);
    final data = payload['data'];
    final departments = data is Map<String, dynamic> ? data['departments'] : null;

    if (departments is! List) {
      return [];
    }

    return departments
        .map((item) => DepartmentModel.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  Future<DepartmentModel> createDepartment({
    required String name,
    String? description,
  }) async {
    final response = await _api.post(
      '/departments',
      {
        'name': name.trim(),
        'description': description?.trim(),
      },
    );

    final payload = Map<String, dynamic>.from(response.data as Map);
    final data = Map<String, dynamic>.from(payload['data'] as Map);
    return DepartmentModel.fromJson(Map<String, dynamic>.from(data['department'] as Map));
  }

  Future<DepartmentModel> updateDepartment({
    required String id,
    required String name,
    String? description,
  }) async {
    final response = await _api.put<dynamic>(
      '/departments/$id',
      data: {
        'name': name.trim(),
        'description': description?.trim(),
      },
    );

    final payload = Map<String, dynamic>.from(response.data as Map);
    final data = Map<String, dynamic>.from(payload['data'] as Map);
    return DepartmentModel.fromJson(Map<String, dynamic>.from(data['department'] as Map));
  }

  Future<void> deleteDepartment(String id) async {
    await _api.delete<dynamic>('/departments/$id');
  }
}
