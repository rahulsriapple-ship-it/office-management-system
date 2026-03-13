class EmployeeModel {
  const EmployeeModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.designation,
    this.employeeCode,
    this.departmentName,
  });

  final String id;
  final String name;
  final String email;
  final String role;
  final String? phone;
  final String? designation;
  final String? employeeCode;
  final String? departmentName;

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    final department = json['department'];
    String? departmentName;

    if (department is Map<String, dynamic>) {
      departmentName = department['name']?.toString();
    }

    return EmployeeModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      role: (json['role'] ?? '').toString(),
      phone: json['phone']?.toString(),
      designation: json['designation']?.toString(),
      employeeCode: json['employeeCode']?.toString(),
      departmentName: departmentName,
    );
  }
}
