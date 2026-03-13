class ForgotPasswordModel {
  const ForgotPasswordModel({
    required this.email,
  });

  factory ForgotPasswordModel.fromForm({
    required String email,
  }) {
    return ForgotPasswordModel(
      email: email.trim().toLowerCase(),
    );
  }

  final String email;

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}
