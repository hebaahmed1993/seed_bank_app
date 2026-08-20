import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/favorites_providers.dart';
import '../providers/favorites_state.dart';
import '../widgets/favorite_item_card.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(favoritesNotifierProvider);
    final userId = ref.watch(firebaseAuthProvider).currentUser?.uid ?? '';

    ref.listen<FavoritesState>(favoritesNotifierProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
        CustomSnackBar.showError(context, next.errorMessage!);
        ref.read(favoritesNotifierProvider.notifier).clearMessages();
      } else if (next.actionSuccessMessage != null &&
          next.actionSuccessMessage!.isNotEmpty) {
        CustomSnackBar.showSuccess(context, next.actionSuccessMessage!);
        ref.read(favoritesNotifierProvider.notifier).clearMessages();
      }
    });

    return  _buildBody(context, ref, state, userId);

  }

  Widget _buildBody(
      BuildContext context,
      WidgetRef ref,
      FavoritesState state,
      String userId,
      ) {
    if (state.fetchStatus == RequestStatus.loading && state.items.isEmpty) {
      return const LoadingView(message: 'جاري جلب القائمة المفضلة...');
    }

    // حالة حدث خطأ أثناء التحميل والأجسام فارغة
    if (state.fetchStatus == RequestStatus.error && state.items.isEmpty) {
      return ErrorView(
        message: state.errorMessage ?? 'حدث خطأ أثناء تحميل المفضلة',
        onRetry: () {
          if (userId.isNotEmpty) {
            ref.read(favoritesNotifierProvider.notifier).fetchFavorites(userId);
          }
        },
      );
    }

    // القائمة فارغة
    if (state.items.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          if (userId.isNotEmpty) {
            await ref
                .read(favoritesNotifierProvider.notifier)
                .fetchFavorites(userId);
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            alignment: Alignment.center,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border_rounded,
                  size: 80,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'قائمة المفضلة فارغة',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'لم تقم بإضافة أي منتجات إلى المفضلة بعد.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // عرض المنتجات في قائمة
    return RefreshIndicator(
      onRefresh: () async {
        if (userId.isNotEmpty) {
          await ref
              .read(favoritesNotifierProvider.notifier)
              .fetchFavorites(userId);
        }
      },
      child: ListView.builder(
        itemCount: state.items.length,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemBuilder: (context, index) {
          final item = state.items[index];
          return FavoriteItemCard(
            favorite: item,
            onTap: () {
              context.push(
                AppScreen.productDetails.toPath,
                extra: item.productId,
              );
            },
            onDelete: () {
              ref.read(favoritesNotifierProvider.notifier).removeFavorite(
                userId: userId,
                productId: item.productId,
              );
            },
          );
        },

      ),
    );
  }
}
