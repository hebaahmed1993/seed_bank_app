import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../domain/entities/category_entity.dart';
import '../providers/categories_notifier.dart';
import '../providers/categories_state.dart';

class SubcategoriesBottomSheet extends ConsumerWidget {
  final CategoryEntity parentCategory;
  final ValueChanged<CategoryEntity>? onSubcategorySelected;

  const SubcategoriesBottomSheet({
    super.key,
    required this.parentCategory,
    this.onSubcategorySelected,
  });

  static Future<void> show(
    BuildContext context, {
    required CategoryEntity parentCategory,
    ValueChanged<CategoryEntity>? onSubcategorySelected,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SubcategoriesBottomSheet(
        parentCategory: parentCategory,
        onSubcategorySelected: onSubcategorySelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(categoriesNotifierProvider);
    final theme = Theme.of(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header Title
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.subdirectory_arrow_right_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        parentCategory.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'الأقسام الفرعية',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Content Body
          Expanded(
            child: _buildBody(context, ref, state),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, CategoriesState state) {
    if (state.subcategoriesStatus == RequestStatus.loading) {
      return const LoadingView(message: AppStrings.loading);
    }

    if (state.subcategoriesStatus == RequestStatus.error) {
      return ErrorView(
        message: state.subcategoriesErrorMessage ?? AppStrings.errorOccurred,
        onRetry: () {
          ref
              .read(categoriesNotifierProvider.notifier)
              .fetchSubcategories(parentCategory);
        },
      );
    }

    if (state.subcategories.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'لا توجد أقسام فرعية متاحة',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: state.subcategories.length,
      separatorBuilder: (context, index) => const Divider(height: 1, indent: 56),
      itemBuilder: (context, index) {
        final subcategory = state.subcategories[index];
        final hasImage = subcategory.imageUrl != null && subcategory.imageUrl!.isNotEmpty;

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: hasImage
                  ? Image.network(
                      subcategory.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.category_outlined, color: AppColors.primary),
                    )
                  : const Icon(Icons.category_outlined, color: AppColors.primary),
            ),
          ),
          title: Text(
            subcategory.name,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: AppColors.textSecondary,
          ),
          onTap: () {
            Navigator.of(context).pop();
            if (onSubcategorySelected != null) {
              onSubcategorySelected!(subcategory);
            }
          },
        );
      },
    );
  }
}
