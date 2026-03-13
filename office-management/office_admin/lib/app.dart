import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/config/app_config.dart';
import 'core/theme/app_theme.dart';
import 'features/admin/screens/admin_dashboard_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/viewmodels/auth_viewmodel.dart';
import 'features/company/viewmodels/company_viewmodel.dart';
import 'features/department/viewmodels/department_viewmodel.dart';
import 'features/employee/viewmodels/employee_viewmodel.dart';

class OfficeAdminApp extends StatelessWidget {
  const OfficeAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => CompanyViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => DepartmentViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => EmployeeViewModel(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Office Admin ${AppConfig.environmentLabel}',
        theme: AppTheme.lightTheme,
        home: const _AppBootstrapper(),
      ),
    );
  }
}

class _AppBootstrapper extends StatefulWidget {
  const _AppBootstrapper();

  @override
  State<_AppBootstrapper> createState() => _AppBootstrapperState();
}

class _AppBootstrapperState extends State<_AppBootstrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthViewModel>().restoreSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();

    if (!authVm.isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return authVm.isAuthenticated
        ? const AdminDashboardScreen()
        : const LoginScreen();
  }
}
