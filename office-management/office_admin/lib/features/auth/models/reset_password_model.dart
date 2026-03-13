class ResetPasswordModel {
  const ResetPasswordModel({
    required this.token,
    required this.password,
  });

  factory ResetPasswordModel.fromForm({
    required String token,
    required String password,
  }) {
    return ResetPasswordModel(
      token: token.trim(),
      password: password.trim(),
    );
  }

  final String token;
  final String password;

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'password': password,
    };
  }
}
