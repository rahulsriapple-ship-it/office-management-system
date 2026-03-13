class CompanyModel {
  final String companyName;
  final String adminName;
  final String email;
  final String password;
  final String phone;

  CompanyModel({
    required this.companyName,
    required this.adminName,
    required this.email,
    required this.password,
    required this.phone,
  });

  factory CompanyModel.fromForm({
    required String companyName,
    required String adminName,
    required String email,
    required String password,
    required String phone,
  }) {
    return CompanyModel(
      companyName: companyName.trim(),
      adminName: adminName.trim(),
      email: email.trim().toLowerCase(),
      password: password.trim(),
      phone: phone.trim(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "companyName": companyName,
      "adminName": adminName,
      "email": email,
      "password": password,
      "phone": phone,
    };
  }
}
