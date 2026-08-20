import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/splash/presentation/screens/splash_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/sign_up_screen.dart';
import '../features/cart/presentation/screens/cart_screen.dart';
import '../features/categories/presentation/pages/categories_page.dart';
import '../features/products/presentation/screens/category_products_screen.dart';
import '../features/products/presentation/screens/product_details_screen.dart';
import 'main_navigation.dart';

enum AppScreen {
  splash,
  main,
  cart,
  categories,
  productDetails,
  categoryProducts,
  login,
  signUp,
}

// 🎯 Extensions لإستخراج المسارات والأسماء بأمان تام
extension AppScreenExtension on AppScreen {
  String get toPath {
    switch (this) {
      case AppScreen.splash:
        return '/';
      case AppScreen.main:
        return '/main';
      case AppScreen.cart:
        return '/cart';
      case AppScreen.categories:
        return '/categories';
      case AppScreen.productDetails:
        return '/productDetails';
      case AppScreen.categoryProducts:
        return '/categoryProducts';
      case AppScreen.login:
        return '/login';
      case AppScreen.signUp:
        return '/signUp';
    }
  }

  String get toName {
    switch (this) {
      case AppScreen.splash:
        return 'SPLASH';
      case AppScreen.main:
        return 'MAIN';
      case AppScreen.cart:
        return 'CART';
      case AppScreen.categories:
        return 'CATEGORIES';
      case AppScreen.productDetails:
        return 'PRODUCT_DETAILS';
      case AppScreen.categoryProducts:
        return 'CATEGORY_PRODUCTS';
      case AppScreen.login:
        return 'LOGIN';
      case AppScreen.signUp:
        return 'SIGN_UP';
    }
  }
}

// 🎯 Provider خاص بـ GoRouter لربطه مع حالة التطبيق
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppScreen.splash.toPath,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppScreen.splash.toPath,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppScreen.main.toPath,
        builder: (context, state) => const MainNavigation(),
      ),
      GoRoute(
        path: AppScreen.cart.toPath,
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: AppScreen.categories.toPath,
        builder: (context, state) => const CategoriesPage(),
      ),
      GoRoute(
        path: AppScreen.productDetails.toPath,
        builder: (context, state) {
          final productId = state.extra as String? ?? '';
          return ProductDetailsScreen(productId: productId);
        },
      ),
      GoRoute(
        path: AppScreen.categoryProducts.toPath,
        builder: (context, state) {
          final args = state.extra as Map<String, String>? ?? {};
          return CategoryProductsScreen(
            categoryId: args['categoryId'] ?? '',
            categoryName: args['categoryName'] ?? 'المنتجات',
          );
        },
      ),
      GoRoute(
        path: AppScreen.login.toPath,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppScreen.signUp.toPath,
        builder: (context, state) => const SignUpScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('No route defined for ${state.matchedLocation}'),
      ),
    ),
  );
});