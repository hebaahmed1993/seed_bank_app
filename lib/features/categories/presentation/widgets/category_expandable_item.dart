import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/widgets/custom_image_view.dart';
import '../../domain/entities/category_entity.dart';
import '../providers/categories_notifier.dart';
import '../providers/categories_state.dart';

class CategoryExpandableItem extends ConsumerWidget {
  final CategoryEntity category;
  final bool isExpanded;
  final VoidCallback onTap;

  const CategoryExpandableItem({
    super.key,
    required this.category,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(categoriesNotifierProvider);
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isExpanded ? AppColors.primary : AppColors.border.withAlpha(120),
          width: isExpanded ? 1.5 : 1.0,
        ),
        boxShadow: isExpanded
            ? [
          BoxShadow(
            color: AppColors.primary.withAlpha(15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. الترويسة (التصنيف الرئيسي)
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Row(
                children: [
                  CustomImageView(
                    imageUrl: category.imageUrl,
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      category.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: isExpanded ? AppColors.primary : null,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: isExpanded ? AppColors.primary : AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),

          // 2. الجسم القابل للتوسعة (الأقسام الفرعية)
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: isExpanded
                ? Column(
              children: [
                const Divider(height: 1),
                _buildSubcategoriesBody(context, state),
              ],
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildSubcategoriesBody(BuildContext context, CategoriesState state) {
    // التحقق من أن التصنيف يمتلك أقساماً فرعية
    if (!category.hasSubcategories) {
      return _buildEmptyOrErrorMsg('لا توجد أقسام فرعية');
    }

    // حالة التحميل
    if (state.subcategoriesStatus == RequestStatus.loading) {
      return const Padding(
        padding: EdgeInsets.all(24.0),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    // حالة الخطأ
    if (state.subcategoriesStatus == RequestStatus.error) {
      return _buildEmptyOrErrorMsg(
        state.subcategoriesErrorMessage ?? AppStrings.errorOccurred,
        isError: true,
      );
    }

    // حالة تفريغ القائمة
    if (state.subcategories.isEmpty) {
      return _buildEmptyOrErrorMsg('لا توجد أقسام فرعية');
    }

    // رسم قائمة الأقسام الفرعية المطابقة للصورة
    return Column(
      children: state.subcategories.map((sub) {
        return InkWell(
          onTap: () {
            // استخدام CustomSnackBar بدلاً من ScaffoldMessenger
            // CustomSnackBar.showSuccess(
            //   context: context,
            //   message: 'تم اختيار القسم: ${sub.name}',
            // );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
            child: Row(
              children: [
                const SizedBox(width: 40), // إزاحة للنص ليكون أسفل نص الرئيسي
                Expanded(
                  child: Text(
                    sub.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyOrErrorMsg(String text, {bool isError = false}) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        text,
        style: TextStyle(
          color: isError ? Colors.red : AppColors.textSecondary,
          fontSize: 14,
        ),
      ),
    );
  }
}