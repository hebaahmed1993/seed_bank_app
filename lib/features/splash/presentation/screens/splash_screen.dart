import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../auth/presentation/providers/auth_state.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _checkInitialState();
  }

  void _checkInitialState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      // قراءة الحالة الحالية بعد التأخير
      final authState = ref.read(authNotifierProvider);

      // إذا كانت عملية التحقق قد انتهت بالفعل خلال الثانيتين، وجه المستخدم فوراً
      if (authState.checkStatus != RequestStatus.loading) {
        _navigate();
      }
    });
  }

  void _navigate() {
    if (!mounted) return;

    context.go(
      AppScreen.main.toPath,

    );


  }

  @override
  Widget build(BuildContext context) {
    // 🎧 الاستماع التفاعلي: في حال استغرق فايربيس وقتاً أطول من ثانيتين
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      // إذا تغيرت الحالة من تحميل إلى أي حالة أخرى (نجاح، خطأ، أو فشل أولي)
      if (previous?.checkStatus == RequestStatus.loading &&
          next.checkStatus != RequestStatus.loading) {
        _navigate();
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🎯 الشعار (يمكنك استبداله بصورة الشعار الخاصة بك)
            Icon(
              Icons.eco_rounded, // أيقونة مؤقتة لـ Seed Bank
              size: 120,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            // اسم التطبيق
            Text(
              'Seed Bank',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 48),
            // مؤشر التحميل
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}