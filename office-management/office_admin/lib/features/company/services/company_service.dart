import '../../../core/services/api_service.dart';
import '../models/company_model.dart';

class CompanyService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> registerCompany(CompanyModel model) async {
    final response = await _api.post(
      "/company/register",
      model.toJson(),
    );

    return Map<String, dynamic>.from(response.data as Map);
  }
}
