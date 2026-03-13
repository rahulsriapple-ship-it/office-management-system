import '../../../core/services/api_service.dart';
import '../models/forgot_password_model.dart';
import '../models/login_model.dart';
import '../models/reset_password_model.dart';

class AuthService {
  final ApiService _api = ApiService();

  Future<bool> hasActiveSession() async {
    final token = await _api.getAuthToken();
    return token != null && token.isNotEmpty;
  }

  Future<String?> getSavedToken() async {
    return _api.getAuthToken();
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await _api.get<dynamic>('/auth/me');
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> login(LoginModel model) async {
    final response = await _api.post('/auth/login', model.toJson());
    final result = Map<String, dynamic>.from(response.data as Map);
    final data = result['data'];
    if (data is Map<String, dynamic>) {
      final token = data['token'];
      if (token is String && token.isNotEmpty) {
        await _api.saveAuthToken(token);
      }
    }
    return result;
  }

  Future<Map<String, dynamic>> forgotPassword(ForgotPasswordModel model) async {
    final response = await _api.post('/auth/forgot-password', model.toJson());
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> resetPassword(ResetPasswordModel model) async {
    final response = await _api.post('/auth/reset-password', model.toJson());
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<void> logout() async {
    await _api.clearAuthToken();
  }
}
