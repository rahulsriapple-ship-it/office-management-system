class EmployeeImportSummary {
  const EmployeeImportSummary({
    required this.total,
    required this.created,
    required this.updated,
    required this.skipped,
    required this.errors,
  });

  final int total;
  final int created;
  final int updated;
  final int skipped;
  final List<String> errors;

  factory EmployeeImportSummary.fromJson(Map<String, dynamic> json) {
    final rawErrors = json['errors'];
    return EmployeeImportSummary(
      total: (json['total'] as num?)?.toInt() ?? 0,
      created: (json['created'] as num?)?.toInt() ?? 0,
      updated: (json['updated'] as num?)?.toInt() ?? 0,
      skipped: (json['skipped'] as num?)?.toInt() ?? 0,
      errors: rawErrors is List
          ? rawErrors.map((error) => error.toString()).toList()
          : const [],
    );
  }
}
