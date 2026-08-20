import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/utils/app_validators.dart' as AppValidators;
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../../data/models/sign_in_request_model.dart';
import '../providers/auth_providers.dart';
import '../providers/auth_state.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController(); // 👈 تعديل الاسم ليتناسب مع الهاتف
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {

      final request = SignInRequestModel(
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
      );

      ref.read(authNotifierProvider.notifier).signIn(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🎯 الاستماع لحالة تسجيل الدخول تحديداً
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next.signInStatus == RequestStatus.error) {
        CustomSnackBar.showError(
          context,
          next.errorMessage ?? 'حدث خطأ أثناء تسجيل الدخول',
        );
      } else if (next.signInStatus == RequestStatus.success) {
        CustomSnackBar.showSuccess(context, 'تم تسجيل الدخول بنجاح');
        context.go(AppScreen.main.toPath); // استخدام go بدل push لتطهير الشاشات السابقة

      }
    });

    final authState = ref.watch(authNotifierProvider);
    // 🎯 قراءة حالة التحميل الخاصة بتسجيل الدخول
    final isLoading = authState.signInStatus == RequestStatus.loading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل الدخول'),
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
                    Icons.lock_outline_rounded,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'مرحباً بك مجدداً',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'قم بتسجيل الدخول للمتابعة',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 32),

                  CustomTextFormField(
                    controller: _phoneController,
                    labelText: 'رقم الهاتف',
                    prefixIcon: const Icon(Icons.phone_outlined),
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    validator: AppValidators.phoneNumberValidator,
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
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
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
                    title: 'تسجيل الدخول',
                    isLoading: isLoading,
                    onPressed: _submit,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('ليس لديك حساب؟'),
                      TextButton(
                        onPressed: () {
                          context.push(AppScreen.signUp.toPath);
                        },
                        child: const Text(
                          'إنشاء حساب جديد',
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