import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_routes.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../localization/app_strings.dart';

class MainDrawer extends ConsumerWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          if (user != null)
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              accountName: Text(
                user.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              accountEmail: Text(user.email),
            )
          else
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person_outline, size: 40, color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'أهلاً بك يا زائر',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),





          ListTile(
            leading: const Icon(Icons.category_outlined),
            title: const Text('التصنيفات'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                context.pop(); // بدلاً من Navigator.pop
                context.push(AppScreen.categories.toPath); // بدلاً من pushNamed
              },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart_outlined),
            title: const Text(AppStrings.cartTab),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              context.pop();
              context.push(AppScreen.cart.toPath);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('الإعدادات'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          if (user != null)
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.red),
              title: const Text(
                'تسجيل الخروج',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                // 1. إغلاق القائمة الجانبية بطريقة go_router
                context.pop();

                // 2. تنفيذ تسجيل الخروج
                await ref.read(authNotifierProvider.notifier).signOut();

                // 3. التوجيه الفوري للـ Splash لتصفير التطبيق
                if (context.mounted) {
                  context.go(AppScreen.splash.toPath);
                }
              },
            )
          else
            ListTile(
              leading: const Icon(Icons.login_rounded, color: Colors.green),
              title: const Text(
                'تسجيل الدخول',
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                context.pop();
                context.push(AppScreen.login.toPath);
              },
            ),
        ],
      ),
    );
  }
}