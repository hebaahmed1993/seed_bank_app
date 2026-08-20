import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enums/app_enums.dart';
import '../../../../core/utils/app_validators.dart' as AppValidators;
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../../location/presentation/providers/location_providers.dart';
import '../../../location/presentation/widgets/custom_city_dropdown.dart';
import '../../data/models/sign_up_request_model.dart';
import '../providers/auth_providers.dart';
import '../providers/auth_state.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  String? _selectedCityId;
  String? _selectedCityName;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final request = SignUpRequestModel(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        phone: _phoneController.text.trim(),
        cityId: _selectedCityId!,
        cityName: _selectedCityName!,
      );

      ref.read(authNotifierProvider.notifier).signUp(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🎯 الاستماع لحالة إنشاء الحساب تحديداً
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next.signUpStatus == RequestStatus.error) {
        CustomSnackBar.showError(
          context,
          next.errorMessage ?? 'حدث خطأ أثناء إنشاء الحساب',
        );
      } else if (next.signUpStatus == RequestStatus.success) {
        CustomSnackBar.showSuccess(
          context,
          'تم إنشاء الحساب بنجاح، يرجى تسجيل الدخول',
        );
        Navigator.pop(context);
      }
    });

    final authState = ref.watch(authNotifierProvider);
    // 🎯 قراءة حالة التحميل الخاصة بإنشاء الحساب
    final isLoading = authState.signUpStatus == RequestStatus.loading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء حساب جديد'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.person_add_alt_1_outlined,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'مرحباً بك',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  CustomTextFormField(
                    controller: _nameController,
                    labelText: 'الاسم الكامل',
                    prefixIcon: const Icon(Icons.person_outline),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    validator: AppValidators.requiredValidator,
                  ),
                  const SizedBox(height: 16),

                  CustomTextFormField(
                    controller: _emailController,
                    labelText: 'البريد الإلكتروني',
                    prefixIcon: const Icon(Icons.email_outlined),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: AppValidators.requiredValidator,
                  ),
                  const SizedBox(height: 16),

                  CustomTextFormField(
                    controller: _phoneController,
                    labelText: 'رقم الهاتف',
                    prefixIcon: const Icon(Icons.phone_outlined),
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    validator: AppValidators.phoneNumberValidator,
                  ),
                  const SizedBox(height: 16),

                  CustomCityDropdown(
                    value: _selectedCityId,
                    onChanged: (value) {
                      setState(() {
                        _selectedCityId = value;

                        if (value != null) {
                          final cities = ref.read(locationNotifierProvider).cities;
                          final selectedCity = cities.where((city) => city.cityId == value).firstOrNull;
                          _selectedCityName = selectedCity?.name;
                        } else {
                          _selectedCityName = null;
                        }
                      });
                    },
                    validator: (value) => value == null ? 'يرجى اختيار المدينة' : null,
                  ),
                  const SizedBox(height: 16),

                  CustomTextFormField(
                    controller: _passwordController,
                    labelText: 'كلمة المرور',
                    prefixIcon: const Icon(Icons.lock_outline),
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    validator: AppValidators.requiredValidator,
                  ),
                  const SizedBox(height: 24),

                  CustomButton(
                    title: 'إنشاء الحساب',
                    isLoading: isLoading,
                    onPressed: _submit,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('لديك حساب بالفعل؟'),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'تسجيل الدخول',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}