import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_image_view.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../domain/entities/product_entity.dart';
import '../providers/products_notifier.dart';

final productDetailsProvider =
    FutureProvider.family<ProductEntity, String>((ref, productId) async {
  final getProductByIdUseCase = ref.watch(getProductByIdUseCaseProvider);
  final result = await getProductByIdUseCase(productId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (product) => product,
  );
});

class ProductDetailsScreen extends ConsumerWidget {
  final String productId;

  const ProductDetailsScreen({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailsProvider(productId));

    return Scaffold(
      body: productAsync.when(
        data: (product) {
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: CustomImageView(
                      imageUrl: product.imageUrl,
                      fit: BoxFit.cover,
                      imageType: ImageType.product,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${product.price} د.ل',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: product.stockQuantity > 0
                                    ? Colors.green.withAlpha(30)
                                    : Colors.red.withAlpha(30),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                product.stockQuantity > 0
                                    ? 'متوفر (${product.stockQuantity})'
                                    : 'غير متوفر',
                                style: TextStyle(
                                  color: product.stockQuantity > 0
                                      ? Colors.green[800]
                                      : Colors.red[800],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 8),
                        Text(
                          'تفاصيل المنتج',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.description.isNotEmpty
                              ? product.description
                              : 'لا يوجد وصف متاح لهذا المنتج حالياً.',
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.5,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (product.season.isNotEmpty) ...[
                          _buildDetailRow('الموسم', product.season),
                          const SizedBox(height: 8),
                        ],
                        if (product.sku.isNotEmpty) ...[
                          _buildDetailRow('رمز المنتج (SKU)', product.sku),
                          const SizedBox(height: 8),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(15),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: SafeArea(
                child: CustomButton(
                  title: 'إضافة إلى السلة',
                  icon: Icons.add_shopping_cart,
                  onPressed: () {
                    CustomSnackBar.showSuccess(
                      context,
                      'تمت إضافة ${product.name} إلى السلة بنجاح',
                    );
                  },
                ),
              ),
            ),
          );
        },
        loading: () => const Scaffold(
          body: LoadingView(message: 'جاري تحميل تفاصيل المنتج...'),
        ),
        error: (error, stack) => Scaffold(
          appBar: AppBar(),
          body: ErrorView(
            message: 'حدث خطأ أثناء تحميل تفاصيل المنتج',
            onRetry: () => ref.invalidate(productDetailsProvider(productId)),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
