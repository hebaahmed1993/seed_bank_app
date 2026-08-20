import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/app_routes.dart';
import '../../../../core/widgets/custom_image_view.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../favorites/domain/entities/favorite_entity.dart';
import '../../../favorites/presentation/providers/favorites_providers.dart';
import '../../domain/entities/home_section_entity.dart';
import '../providers/home_section_providers.dart';

class ProductsSectionWidget extends ConsumerWidget {
  final ProductsSectionEntity section;

  const ProductsSectionWidget({
    super.key,
    required this.section,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(sectionProductsProvider(section));

    return productsAsync.when(
      data: (products) {
        if (products.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    section.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {



                      // context.push(
                      //   AppScreen.categoryProducts.toPath,
                      //   extra: {
                      //     'categoryId': category.id,
                      //     'categoryName': category.name,
                      //   },
                      // );

                    },
                    child: const Text('عرض الكل'),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 230,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];

                  return Container(
                    width: 160,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () {

                          context.push(
                            AppScreen.productDetails.toPath,
                            extra: product.id,
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CustomImageView(
                                      imageUrl: product.imageUrl,
                                      fit: BoxFit.cover,
                                      imageType: ImageType.product,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                product.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              if (product.description.isNotEmpty)
                                Text(
                                  product.description,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${product.price} د.ل',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      // 🎯 زر المفضلة الجديد
                                      Consumer(
                                        builder: (context, ref, child) {
                                          final favoritesState = ref.watch(favoritesNotifierProvider);
                                          final isFavorite = favoritesState.isProductFavorite(product.id);
                                          final userId = ref.watch(firebaseAuthProvider).currentUser?.uid ?? '';

                                          return IconButton(
                                            constraints: const BoxConstraints(),
                                            padding: const EdgeInsets.symmetric(horizontal: 4),
                                            icon: Icon(
                                              isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                              size: 20,
                                              color: isFavorite ? Colors.red : Colors.grey,
                                            ),
                                            onPressed: () {
                                              if (userId.isEmpty) {
                                                CustomSnackBar.showError(context, 'يجب تسجيل الدخول أولاً لإدارة المفضلة');
                                                return;
                                              }

                                              if (isFavorite) {
                                                // حذف من المفضلة
                                                ref.read(favoritesNotifierProvider.notifier).removeFavorite(
                                                  userId: userId,
                                                  productId: product.id,
                                                );
                                              } else {
                                                // إضافة إلى المفضلة (ننشئ كائن FavoriteEntity)
                                                final favoriteEntity = FavoriteEntity(
                                                  id: '${userId}_${product.id}', // معرف فريد مؤقت أو يتم توليده
                                                  userId: userId,
                                                  productId: product.id,
                                                  createdAt: DateTime.now(),
                                                );
                                                ref.read(favoritesNotifierProvider.notifier).addFavorite(favoriteEntity);
                                              }
                                            },
                                          );
                                        },
                                      ),
                                      // زر سلة المشتريات الحالي
                                      IconButton(
                                        constraints: const BoxConstraints(),
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(Icons.add_shopping_cart, size: 20),
                                        onPressed: () {
                                          CustomSnackBar.showSuccess(
                                            context,
                                            'تمت إضافة ${product.name} إلى السلة بنجاح',
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox(
        height: 230,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}