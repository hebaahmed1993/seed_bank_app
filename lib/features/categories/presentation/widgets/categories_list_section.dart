import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/category_entity.dart';
import '../providers/categories_notifier.dart';
import 'category_expandable_item.dart';

class CategoriesListSection extends ConsumerStatefulWidget {
  final List<CategoryEntity> categories;
  final bool isFetchingMore;

  const CategoriesListSection({
    super.key,
    required this.categories,
    required this.isFetchingMore,
  });

  @override
  ConsumerState<CategoriesListSection> createState() => _CategoriesListSectionState();
}

class _CategoriesListSectionState extends ConsumerState<CategoriesListSection> {
  // متغير لحفظ الـ ID الخاص بالتصنيف المفتوح حالياً (Accordion Logic)
  String? _expandedCategoryId;

  void _toggleExpand(CategoryEntity category) {
    if (_expandedCategoryId == category.id) {
      // إغلاق التصنيف إذا كان مفتوحاً بالفعل
      setState(() {
        _expandedCategoryId = null;
      });
      ref.read(categoriesNotifierProvider.notifier).clearSubcategories();
    } else {
      // فتح تصنيف جديد وإغلاق الآخرين
      setState(() {
        _expandedCategoryId = category.id;
      });
      if (category.hasSubcategories) {
        ref.read(categoriesNotifierProvider.notifier).fetchSubcategories(category);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.categories.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.list_alt_rounded,
                size: 64,
                color: AppColors.textSecondary,
              ),
              SizedBox(height: 16),
              Text(
                'لا توجد تصنيفات متاحة حالياً',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      itemCount: widget.categories.length + (widget.isFetchingMore ? 1 : 0),
      itemBuilder: (context, index) {
        // عرض مؤشر التحميل في نهاية القائمة أثناء جلب المزيد
        if (index == widget.categories.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.primary,
                ),
              ),
            ),
          );
        }

        final category = widget.categories[index];
        final isExpanded = _expandedCategoryId == category.id;

        return CategoryExpandableItem(
          category: category,
          isExpanded: isExpanded,
          onTap: () => _toggleExpand(category),
        );
      },
    );
  }
}