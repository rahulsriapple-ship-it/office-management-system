class LoginModel {
  const LoginModel({
    required this.email,
    required this.password,
  });

  factory LoginModel.fromForm({
    required String email,
    required String password,
  }) {
    return LoginModel(
      email: email.trim().toLowerCase(),
      password: password.trim(),
    );
  }

  final String email;
  final String password;

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
