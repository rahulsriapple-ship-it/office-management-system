import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/formatters/app_input_formatters.dart';
import '../../../core/validation/app_validators.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/surface_card.dart';
import '../../auth/screens/login_screen.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../../department/models/department_model.dart';
import '../../department/viewmodels/department_viewmodel.dart';
import '../../employee/models/employee_import_summary.dart';
import '../../employee/models/employee_model.dart';
import '../../employee/viewmodels/employee_viewmodel.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DepartmentViewModel>().loadDepartments();
      context.read<EmployeeViewModel>().loadEmployees();
    });
  }

  Future<void> _logout() async {
    await context.read<AuthViewModel>().logout();
    if (!mounted) {
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final departmentVm = context.watch<DepartmentViewModel>();
    final employeeVm = context.watch<EmployeeViewModel>();
    final isWide = MediaQuery.sizeOf(context).width >= 1100;

    final sections = [
      _OverviewPanel(
        departmentCount: departmentVm.departments.length,
        employeeCount: employeeVm.employees.length,
      ),
      const _DepartmentPanel(),
      const _EmployeePanel(),
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF2F7F6),
              Color(0xFFE7F0ED),
              Color(0xFFF8FBFA),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: isWide
                ? Row(
                    children: [
                      _buildRail(),
                      const SizedBox(width: 24),
                      Expanded(child: sections[_selectedIndex]),
                    ],
                  )
                : Column(
                    children: [
                      _buildCompactHeader(),
                      const SizedBox(height: 20),
                      Expanded(child: sections[_selectedIndex]),
                    ],
                  ),
          ),
        ),
      ),
      bottomNavigationBar: isWide
          ? null
          : NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  label: 'Overview',
                ),
                NavigationDestination(
                  icon: Icon(Icons.account_tree_outlined),
                  label: 'Departments',
                ),
                NavigationDestination(
                  icon: Icon(Icons.badge_outlined),
                  label: 'Employees',
                ),
              ],
            ),
    );
  }

  Widget _buildRail() {
    return SurfaceCard(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: 280,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Admin Workspace',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Create departments first, then add employees individually or from Excel.',
              style: TextStyle(
                color: AppColors.textMuted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: NavigationRail(
                selectedIndex: _selectedIndex,
                groupAlignment: -0.8,
                onDestinationSelected: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.dashboard_outlined),
                    label: Text('Overview'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.account_tree_outlined),
                    label: Text('Departments'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.badge_outlined),
                    label: Text('Employees'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactHeader() {
    return SurfaceCard(
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Admin Workspace',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Manage departments and employees after login.',
                  style: TextStyle(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
    );
  }
}

class _OverviewPanel extends StatelessWidget {
  const _OverviewPanel({
    required this.departmentCount,
    required this.employeeCount,
  });

  final int departmentCount;
  final int employeeCount;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overview',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Recommended use case: create the company, login as admin, define departments, then create employees or import them from an Excel sheet.',
            style: TextStyle(color: AppColors.textMuted, height: 1.5),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 18,
            runSpacing: 18,
            children: [
              _StatCard(
                title: 'Departments',
                value: '$departmentCount',
                subtitle: 'Active structures ready for assignment',
                icon: Icons.account_tree_outlined,
              ),
              _StatCard(
                title: 'Employees',
                value: '$employeeCount',
                subtitle: 'Profiles created or synced from file import',
                icon: Icons.badge_outlined,
              ),
            ],
          ),
          const SizedBox(height: 24),
          const SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Import guidelines',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Use the downloadable template, keep email unique per employee, and use an existing or new department name in the department column.',
                  style: TextStyle(color: AppColors.textMuted, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: SizedBox(
        width: 280,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primaryDark, size: 28),
            const SizedBox(height: 18),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: const TextStyle(color: AppColors.textMuted, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _DepartmentPanel extends StatefulWidget {
  const _DepartmentPanel();

  @override
  State<_DepartmentPanel> createState() => _DepartmentPanelState();
}

class _DepartmentPanelState extends State<_DepartmentPanel> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit(DepartmentViewModel vm) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success = await vm.createDepartment(
      name: _nameController.text,
      description: _descriptionController.text,
    );

    if (!mounted) {
      return;
    }

    _showMessage(
      success
          ? (vm.successMessage ?? 'Department created successfully')
          : (vm.errorMessage ?? 'Unable to create department'),
    );

    if (success) {
      _nameController.clear();
      _descriptionController.clear();
    }
  }

  Future<void> _editDepartment(
    DepartmentViewModel vm,
    DepartmentModel department,
  ) async {
    final nameController = TextEditingController(text: department.name);
    final descriptionController =
        TextEditingController(text: department.description ?? '');
    final formKey = GlobalKey<FormState>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Department'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(
                  controller: nameController,
                  label: 'Department name',
                  validator: (value) =>
                      AppValidators.requiredField(value, label: 'Department name'),
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: descriptionController,
                  label: 'Description',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(context).pop(true);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    final success = await vm.updateDepartment(
      id: department.id,
      name: nameController.text,
      description: descriptionController.text,
    );

    if (!mounted) {
      return;
    }

    _showMessage(
      success
          ? (vm.successMessage ?? 'Department updated successfully')
          : (vm.errorMessage ?? 'Unable to update department'),
    );
  }

  Future<void> _deleteDepartment(
    DepartmentViewModel vm,
    DepartmentModel department,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Department'),
        content: Text('Delete ${department.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    final success = await vm.deleteDepartment(department.id);
    if (!mounted) {
      return;
    }

    _showMessage(
      success
          ? (vm.successMessage ?? 'Department deleted successfully')
          : (vm.errorMessage ?? 'Unable to delete department'),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DepartmentViewModel>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Departments',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 900;

              final formCard = SurfaceCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Create department',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 18),
                      AppTextField(
                        controller: _nameController,
                        label: 'Department name',
                        hintText: 'Human Resources',
                        prefixIcon: Icons.account_tree_outlined,
                        inputFormatters: AppInputFormatters.companyName,
                        validator: (value) =>
                            AppValidators.requiredField(value, label: 'Department name'),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _descriptionController,
                        label: 'Description',
                        hintText: 'Handles people operations and onboarding',
                        prefixIcon: Icons.notes_rounded,
                      ),
                      const SizedBox(height: 20),
                      PrimaryButton(
                        label: 'Add department',
                        isLoading: vm.isSubmitting,
                        onPressed: () => _submit(vm),
                      ),
                    ],
                  ),
                ),
              );

              final listCard = SurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Department list',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 18),
                    if (vm.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (vm.departments.isEmpty)
                      const Text(
                        'No departments created yet.',
                        style: TextStyle(color: AppColors.textMuted),
                      )
                    else
                      ...vm.departments.map(
                        (department) => _DepartmentTile(
                          department: department,
                          onEdit: () => _editDepartment(vm, department),
                          onDelete: () => _deleteDepartment(vm, department),
                        ),
                      ),
                  ],
                ),
              );

              if (compact) {
                return Column(
                  children: [
                    formCard,
                    const SizedBox(height: 18),
                    listCard,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: formCard),
                  const SizedBox(width: 18),
                  Expanded(child: listCard),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DepartmentTile extends StatelessWidget {
  const _DepartmentTile({
    required this.department,
    required this.onEdit,
    required this.onDelete,
  });

  final DepartmentModel department;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  department.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
          if ((department.description ?? '').isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              department.description!,
              style: const TextStyle(color: AppColors.textMuted, height: 1.4),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmployeePanel extends StatefulWidget {
  const _EmployeePanel();

  @override
  State<_EmployeePanel> createState() => _EmployeePanelState();
}

class _EmployeePanelState extends State<_EmployeePanel> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _designationController = TextEditingController();
  final _employeeCodeController = TextEditingController();

  String? _selectedDepartmentId;
  String _selectedRole = 'EMPLOYEE';
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _designationController.dispose();
    _employeeCodeController.dispose();
    super.dispose();
  }

  Future<void> _submit(
    EmployeeViewModel employeeVm,
    DepartmentViewModel departmentVm,
  ) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDepartmentId == null) {
      _showMessage('Please choose a department');
      return;
    }

    final success = await employeeVm.createEmployee(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      departmentId: _selectedDepartmentId!,
      phone: _phoneController.text,
      designation: _designationController.text,
      employeeCode: _employeeCodeController.text,
      role: _selectedRole,
    );

    if (!mounted) {
      return;
    }

    _showMessage(
      success
          ? (employeeVm.successMessage ?? 'Employee created successfully')
          : (employeeVm.errorMessage ?? 'Unable to create employee'),
    );

    if (success) {
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _phoneController.clear();
      _designationController.clear();
      _employeeCodeController.clear();
      setState(() {
        _selectedDepartmentId = departmentVm.departments.isNotEmpty
            ? departmentVm.departments.first.id
            : null;
        _selectedRole = 'EMPLOYEE';
      });
    }
  }

  Future<void> _editEmployee(
    EmployeeViewModel employeeVm,
    DepartmentViewModel departmentVm,
    EmployeeModel employee,
  ) async {
    final nameController = TextEditingController(text: employee.name);
    final emailController = TextEditingController(text: employee.email);
    final passwordController = TextEditingController();
    final phoneController = TextEditingController(text: employee.phone ?? '');
    final designationController =
        TextEditingController(text: employee.designation ?? '');
    final employeeCodeController =
        TextEditingController(text: employee.employeeCode ?? '');
    final formKey = GlobalKey<FormState>();
    String? departmentId = departmentVm.departments
        .cast<DepartmentModel?>()
        .firstWhere(
          (department) => department?.name == employee.departmentName,
          orElse: () => null,
        )
        ?.id;
    String role = employee.role;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Employee'),
              content: SizedBox(
                width: 460,
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppTextField(
                          controller: nameController,
                          label: 'Employee name',
                          validator: (value) => AppValidators.personName(
                            value,
                            label: 'Employee name',
                          ),
                        ),
                        const SizedBox(height: 12),
                        AppTextField(
                          controller: emailController,
                          label: 'Email',
                          validator: AppValidators.email,
                        ),
                        const SizedBox(height: 12),
                        AppTextField(
                          controller: passwordController,
                          label: 'New password',
                          hintText: 'Leave blank to keep unchanged',
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          initialValue: departmentId,
                          items: departmentVm.departments
                              .map(
                                (department) => DropdownMenuItem(
                                  value: department.id,
                                  child: Text(department.name),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setDialogState(() {
                              departmentId = value;
                            });
                          },
                          decoration: const InputDecoration(labelText: 'Department'),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          initialValue: role,
                          items: const [
                            DropdownMenuItem(
                              value: 'EMPLOYEE',
                              child: Text('Employee'),
                            ),
                            DropdownMenuItem(
                              value: 'MANAGER',
                              child: Text('Manager'),
                            ),
                          ],
                          onChanged: (value) {
                            setDialogState(() {
                              role = value ?? 'EMPLOYEE';
                            });
                          },
                          decoration: const InputDecoration(labelText: 'Role'),
                        ),
                        const SizedBox(height: 12),
                        AppTextField(
                          controller: designationController,
                          label: 'Designation',
                        ),
                        const SizedBox(height: 12),
                        AppTextField(
                          controller: phoneController,
                          label: 'Phone',
                        ),
                        const SizedBox(height: 12),
                        AppTextField(
                          controller: employeeCodeController,
                          label: 'Employee code',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    if (formKey.currentState!.validate() && departmentId != null) {
                      Navigator.of(context).pop(true);
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirmed != true || departmentId == null) {
      return;
    }

    final success = await employeeVm.updateEmployee(
      id: employee.id,
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
      departmentId: departmentId!,
      phone: phoneController.text,
      designation: designationController.text,
      employeeCode: employeeCodeController.text,
      role: role,
    );

    if (!mounted) {
      return;
    }

    if (success) {
      await employeeVm.loadEmployees();
    }

    _showMessage(
      success
          ? (employeeVm.successMessage ?? 'Employee updated successfully')
          : (employeeVm.errorMessage ?? 'Unable to update employee'),
    );
  }

  Future<void> _deleteEmployee(
    EmployeeViewModel employeeVm,
    EmployeeModel employee,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Employee'),
        content: Text('Delete ${employee.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    final success = await employeeVm.deleteEmployee(employee.id);
    if (!mounted) {
      return;
    }

    _showMessage(
      success
          ? (employeeVm.successMessage ?? 'Employee deleted successfully')
          : (employeeVm.errorMessage ?? 'Unable to delete employee'),
    );
  }

  Future<void> _pickExcel(EmployeeViewModel vm) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      withData: true,
      allowedExtensions: const ['xlsx', 'xls'],
    );

    if (result == null || result.files.isEmpty || !mounted) {
      return;
    }

    final file = result.files.single;
    if (file.bytes == null) {
      _showMessage('Unable to read the selected file');
      return;
    }

    final success = await vm.importEmployees(
      bytes: file.bytes!,
      fileName: file.name,
    );

    if (!mounted) {
      return;
    }

    _showMessage(
      success
          ? (vm.successMessage ?? 'Employee import completed')
          : (vm.errorMessage ?? 'Unable to import employees'),
    );
  }

  Future<void> _downloadTemplate() async {
    const csvTemplate = '''
name,email,department,designation,phone,employeeCode,joiningDate,password
Rahul Sharma,rahul@company.com,Operations,Operations Lead,9876543210,EMP-1001,2026-03-12,ChangeMe123
Priya Singh,priya@company.com,Human Resources,HR Executive,9123456780,EMP-1002,2026-03-12,ChangeMe123
''';

    await FileSaver.instance.saveFile(
      name: 'employee_import_template',
      bytes: Uint8List.fromList(utf8.encode(csvTemplate)),
      ext: 'csv',
      mimeType: MimeType.csv,
    );

    if (!mounted) {
      return;
    }

    _showMessage('Employee import template downloaded');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final departmentVm = context.watch<DepartmentViewModel>();
    final employeeVm = context.watch<EmployeeViewModel>();
    final departments = departmentVm.departments;

    _selectedDepartmentId ??=
        departments.isNotEmpty ? departments.first.id : null;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Employees',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 980;

              final employeeFormCard = SurfaceCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Register employee',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 18),
                      AppTextField(
                        controller: _nameController,
                        label: 'Employee name',
                        hintText: 'Priya Singh',
                        prefixIcon: Icons.person_outline_rounded,
                        inputFormatters: AppInputFormatters.personName,
                        validator: (value) =>
                            AppValidators.personName(value, label: 'Employee name'),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _emailController,
                        label: 'Email',
                        hintText: 'priya@company.com',
                        prefixIcon: Icons.alternate_email_rounded,
                        keyboardType: TextInputType.emailAddress,
                        inputFormatters: AppInputFormatters.email,
                        validator: AppValidators.email,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _passwordController,
                        label: 'Password',
                        hintText: 'Minimum 8 characters',
                        prefixIcon: Icons.lock_outline_rounded,
                        inputFormatters: AppInputFormatters.password,
                        validator: AppValidators.password,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedDepartmentId,
                        items: departments
                            .map(
                              (department) => DropdownMenuItem<String>(
                                value: department.id,
                                child: Text(department.name),
                              ),
                            )
                            .toList(),
                        onChanged: departments.isEmpty
                            ? null
                            : (value) {
                                setState(() {
                                  _selectedDepartmentId = value;
                                });
                              },
                        decoration: const InputDecoration(
                          labelText: 'Department',
                          prefixIcon: Icon(Icons.account_tree_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedRole,
                        items: const [
                          DropdownMenuItem(
                            value: 'EMPLOYEE',
                            child: Text('Employee'),
                          ),
                          DropdownMenuItem(
                            value: 'MANAGER',
                            child: Text('Manager'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value ?? 'EMPLOYEE';
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Role',
                          prefixIcon: Icon(Icons.admin_panel_settings_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _designationController,
                        label: 'Designation',
                        hintText: 'Operations Executive',
                        prefixIcon: Icons.work_outline_rounded,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _phoneController,
                        label: 'Phone',
                        hintText: '9876543210',
                        prefixIcon: Icons.call_outlined,
                        keyboardType: TextInputType.phone,
                        inputFormatters: AppInputFormatters.phone,
                        validator: AppValidators.phone,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _employeeCodeController,
                        label: 'Employee code',
                        hintText: 'EMP-1001',
                        prefixIcon: Icons.badge_outlined,
                      ),
                      const SizedBox(height: 20),
                      PrimaryButton(
                        label: 'Add employee',
                        isLoading: employeeVm.isSubmitting,
                        onPressed: departments.isEmpty
                            ? null
                            : () => _submit(employeeVm, departmentVm),
                      ),
                      if (departments.isEmpty) ...[
                        const SizedBox(height: 12),
                        const Text(
                          'Create at least one department before adding employees.',
                          style: TextStyle(color: AppColors.textMuted, height: 1.5),
                        ),
                      ],
                    ],
                  ),
                ),
              );

              final sideColumn = Column(
                children: [
                  SurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bulk import from Excel',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Upload an `.xlsx` or `.xls` file. Existing employees are updated by email, and missing departments are created automatically.',
                          style: TextStyle(color: AppColors.textMuted, height: 1.5),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            SizedBox(
                              width: compact ? double.infinity : 220,
                              child: PrimaryButton(
                                label: 'Choose Excel file',
                                isLoading: employeeVm.isImporting,
                                onPressed: () => _pickExcel(employeeVm),
                              ),
                            ),
                            SizedBox(
                              width: compact ? double.infinity : 220,
                              child: OutlinedButton(
                                onPressed: _downloadTemplate,
                                child: const Text('Download template'),
                              ),
                            ),
                          ],
                        ),
                        if (employeeVm.lastImportSummary != null) ...[
                          const SizedBox(height: 18),
                          _ImportSummaryCard(
                            summary: employeeVm.lastImportSummary!,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  SurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Employee list',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 18),
                        if (employeeVm.isLoading)
                          const Center(child: CircularProgressIndicator())
                        else if (employeeVm.employees.isEmpty)
                          const Text(
                            'No employees added yet.',
                            style: TextStyle(color: AppColors.textMuted),
                          )
                        else
                          ...employeeVm.employees.map(
                            (employee) => _EmployeeTile(
                              employee: employee,
                              onEdit: () => _editEmployee(
                                employeeVm,
                                departmentVm,
                                employee,
                              ),
                              onDelete: () => _deleteEmployee(employeeVm, employee),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              );

              if (compact) {
                return Column(
                  children: [
                    employeeFormCard,
                    const SizedBox(height: 18),
                    sideColumn,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: employeeFormCard),
                  const SizedBox(width: 18),
                  Expanded(child: sideColumn),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ImportSummaryCard extends StatelessWidget {
  const _ImportSummaryCard({
    required this.summary,
  });

  final EmployeeImportSummary summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total rows: ${summary.total}',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text('Created: ${summary.created}'),
          Text('Updated: ${summary.updated}'),
          Text('Skipped: ${summary.skipped}'),
          if (summary.errors.isNotEmpty) ...[
            const SizedBox(height: 10),
            const Text(
              'Row issues',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            ...summary.errors.take(5).map(
              (error) => Text(
                '- $error',
                style: const TextStyle(color: AppColors.textMuted),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmployeeTile extends StatelessWidget {
  const _EmployeeTile({
    required this.employee,
    required this.onEdit,
    required this.onDelete,
  });

  final EmployeeModel employee;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final details = [
      if ((employee.departmentName ?? '').isNotEmpty)
        'Department: ${employee.departmentName}',
      if ((employee.designation ?? '').isNotEmpty)
        'Designation: ${employee.designation}',
      if ((employee.employeeCode ?? '').isNotEmpty)
        'Code: ${employee.employeeCode}',
    ].join(' • ');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  employee.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  employee.role,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            employee.email,
            style: const TextStyle(color: AppColors.textMuted),
          ),
          if (details.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              details,
              style: const TextStyle(color: AppColors.textMuted, height: 1.4),
            ),
          ],
        ],
      ),
    );
  }
}
