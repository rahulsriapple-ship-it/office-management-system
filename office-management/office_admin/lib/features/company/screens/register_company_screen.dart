import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/formatters/app_input_formatters.dart';
import '../../../core/validation/app_validators.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/surface_card.dart';
import '../models/company_model.dart';
import '../viewmodels/company_viewmodel.dart';

class RegisterCompanyScreen extends StatefulWidget {
  const RegisterCompanyScreen({super.key});

  @override
  State<RegisterCompanyScreen> createState() => _RegisterCompanyScreenState();
}

class _RegisterCompanyScreenState extends State<RegisterCompanyScreen> {
  final _formKey = GlobalKey<FormState>();
  final companyController = TextEditingController();
  final adminController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    companyController.dispose();
    adminController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit(CompanyViewModel vm) async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final model = CompanyModel.fromForm(
      companyName: companyController.text,
      adminName: adminController.text,
      email: emailController.text,
      password: passwordController.text,
      phone: phoneController.text,
    );

    final success = await vm.registerCompany(model);
    if (!mounted) {
      return;
    }

    final message = success
        ? (vm.successMessage ?? 'Company registered successfully')
        : (vm.errorMessage ?? 'Unable to register company');

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CompanyViewModel>();
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 960;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF1F8F5),
              Color(0xFFE3F0EC),
              Color(0xFFF8FBFA),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildHero(theme)),
                          const SizedBox(width: 28),
                          Expanded(child: _buildFormCard(vm)),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHero(theme),
                          const SizedBox(height: 24),
                          _buildFormCard(vm),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHero(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(right: 12, top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.border),
            ),
            child: const Text(
              'Office Admin Setup',
              style: TextStyle(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Create a company workspace with a cleaner onboarding flow.',
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'This screen now uses shared validation, typed form formatting, and reusable UI components so it scales better than the original raw widget stack.',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.textMuted,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: const [
              _FeatureChip(
                icon: Icons.verified_outlined,
                label: 'Field validation',
              ),
              _FeatureChip(
                icon: Icons.tune_rounded,
                label: 'Input formatting',
              ),
              _FeatureChip(
                icon: Icons.bolt_rounded,
                label: 'Reusable components',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard(CompanyViewModel vm) {
    return SurfaceCard(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Register company',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Set up your company and primary admin account in one step.',
              style: TextStyle(
                color: AppColors.textMuted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            AppTextField(
              controller: companyController,
              label: 'Company name',
              hintText: 'Acme Studio',
              prefixIcon: Icons.apartment_rounded,
              textInputAction: TextInputAction.next,
              inputFormatters: AppInputFormatters.companyName,
              validator: AppValidators.companyName,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: adminController,
              label: 'Admin name',
              hintText: 'Rahul Sharma',
              prefixIcon: Icons.person_outline_rounded,
              textInputAction: TextInputAction.next,
              inputFormatters: AppInputFormatters.personName,
              validator: (value) =>
                  AppValidators.personName(value, label: 'Admin name'),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: emailController,
              label: 'Work email',
              hintText: 'admin@company.com',
              prefixIcon: Icons.alternate_email_rounded,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              inputFormatters: AppInputFormatters.email,
              validator: AppValidators.email,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: passwordController,
              label: 'Password',
              hintText: 'Minimum 8 characters',
              prefixIcon: Icons.lock_outline_rounded,
              textInputAction: TextInputAction.next,
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
            AppTextField(
              controller: phoneController,
              label: 'Phone',
              hintText: '9876543210',
              prefixIcon: Icons.call_outlined,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              inputFormatters: AppInputFormatters.phone,
              validator: AppValidators.phone,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Create workspace',
              isLoading: vm.isLoading,
              onPressed: () => _submit(vm),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppColors.primaryDark),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
