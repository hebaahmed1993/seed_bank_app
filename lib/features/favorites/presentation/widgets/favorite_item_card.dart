import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_image_view.dart';
import '../../../products/presentation/screens/product_details_screen.dart';
import '../../domain/entities/favorite_entity.dart';

class FavoriteItemCard extends ConsumerWidget {
  final FavoriteEntity favorite;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const FavoriteItemCard({
    super.key,
    required this.favorite,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 🎯 نفترض أن لديك بروفايدر يجلب تفاصيل المنتج أو قائمة المنتجات عبر الـ ID
    // يمكنك تعديله بما يتناسب مع هيكل ميزة الـ Products لديك
    final productAsync = ref.watch(productDetailsProvider(favorite.productId));

    return productAsync.when(
      data: (product) {
        if (product == null) {
          return const SizedBox.shrink(); // في حال تم حذف المنتج الأصلي من المتجر
        }

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CustomImageView(
                    imageUrl: product.imageUrl, // جلب الصورة المحدثة من المنتج
                    width: 80,
                    height: 80,
                    borderRadius: BorderRadius.circular(8),
                    imageType: ImageType.product,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name, // جلب الاسم المحدث من المنتج
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${product.price} ر.س', // جلب السعر المحدث من المنتج لحظياً
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.favorite_rounded,
                      color: AppColors.error,
                    ),
                    tooltip: 'حذف من المفضلة',
                    onPressed: onDelete,
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}