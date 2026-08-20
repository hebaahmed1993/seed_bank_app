import 'package:flutter/foundation.dart'; // من أجل debugPrint
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enums/pagination_action.dart';
import '../../../../core/params/pagination_params.dart';

// --- استدعاءات التصنيفات ---
import '../../../categories/domain/entities/category_entity.dart';
import '../../../categories/presentation/providers/categories_notifier.dart';

// --- استدعاءات المنتجات ---
import '../../../products/domain/entities/product_entity.dart';
import '../../../products/domain/usecases/get_products_params.dart';
// ⚠️ تنبيه: تأكدي من أن مسار هذا الملف يطابق مكان وجود مزودات UseCases المنتجات لديكِ

// --- استدعاءات الرئيسية ---
import '../../../products/presentation/providers/products_notifier.dart';
import '../../domain/entities/home_section_entity.dart';


// ==========================================
// 1. مزود قسم المنتجات (Products Section Provider)
// ==========================================
final sectionProductsProvider =
FutureProvider.family<List<ProductEntity>, ProductsSectionEntity>((
    ref,
    section,
    ) async {

  // 1. إذا كان التحديد يدوياً (يدعم العربية والإنجليزية)
  final isManual = section.selectionMode == 'manual' || section.selectionMode == 'يدوي';

  if (isManual && section.productIds.isNotEmpty) {
    final useCase = ref.watch(getProductsByIdsUseCaseProvider);
    final result = await useCase(section.productIds.take(10).toList());

    return result.fold(
          (failure) {
        debugPrint('🔴 خطأ يدوي في قسم [${section.title}]: ${failure.message}');
        return <ProductEntity>[];
      },
          (products) => products,
    );
  }

  // 2. إذا كان التحديد ديناميكياً (الأحدث، التخفيضات... إلخ)
  final useCase = ref.watch(getProductsPaginatedUseCaseProvider);
  final limitCount = section.limit > 0 ? section.limit : 10;

  final params = GetProductsParams(
    paginationParams: PaginationParams(
      limit: limitCount,
      action: PaginationAction.refresh,
    ),
  );

  final result = await useCase(params);

  return result.fold(
        (failure) {
      // ✨ هذا السطر سيطبع رابط الفهرس المفقود في حال وجود خطأ بفايربيس
      debugPrint('🔴 خطأ ديناميكي في قسم [${section.title}]: ${failure.message}');
      return <ProductEntity>[];
    },
        (paginationModel) => paginationModel.items,
  );
});


// ==========================================
// 2. مزود قسم التصنيفات (Categories Section Provider)
// ==========================================
final sectionCategoriesProvider =
FutureProvider.family<List<CategoryEntity>, List<String>>((
    ref,
    categoryIds,
    ) async {

  // إذا لم يتم تحديد تصنيفات معينة، نجلب أول 10 تصنيفات رئيسية
  if (categoryIds.isEmpty) {
    final useCase = ref.watch(getMainCategoriesPaginatedUseCaseProvider);
    final result = await useCase(
      const PaginationParams(limit: 10, action: PaginationAction.refresh),
    );

    return result.fold(
          (failure) => <CategoryEntity>[],
          (paginationModel) => paginationModel.items,
    );
  }

  // جلب تصنيفات محددة بالـ IDs
  final useCase = ref.watch(getCategoriesByIdsUseCaseProvider);
  final result = await useCase(categoryIds.take(10).toList());

  return result.fold(
        (failure) => <CategoryEntity>[],
        (categories) => categories,
  );
});