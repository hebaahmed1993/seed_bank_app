import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/localization/app_strings.dart';
import '../core/widgets/main_drawer.dart';
import '../features/cart/presentation/providers/cart_provider.dart';
import '../features/favorites/presentation/screens/favorites_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import 'app_routes.dart';

final selectedTabProvider = StateProvider<int>((ref) => 0);

class MainNavigation extends ConsumerWidget {
  const MainNavigation({super.key});

  static const List<Widget> _screens = [
    HomeScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedTabProvider);
    final cartCount = ref.watch(cartTotalCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الرئيسية'),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            tooltip: 'القائمة',
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      // 🎯 القائمة الجانبية (Drawer)
      drawer: MainDrawer(),


      body: IndexedStack(
        index: selectedIndex,
        children: _screens,
      ),


      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(AppScreen.cart.toPath);          },



        tooltip: AppStrings.cartTab,
        icon: Badge(
          isLabelVisible: cartCount > 0,
          label: Text('$cartCount'),
          child: const Icon(Icons.shopping_cart_outlined),
        ),
        label: const Text(AppStrings.cartTab),
      ),


      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          ref.read(selectedTabProvider.notifier).state = index;
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: AppStrings.homeTab,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: AppStrings.favoritesTab,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: AppStrings.profileTab,
          ),
        ],
      ),
    );
  }
}