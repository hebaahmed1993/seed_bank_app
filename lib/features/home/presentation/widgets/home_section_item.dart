import 'package:flutter/material.dart';
import '../../domain/entities/home_section_entity.dart';
import 'banner_section_widget.dart';
import 'categories_section_widget.dart';
import 'products_section_widget.dart';

class HomeSectionItem extends StatelessWidget {
  final HomeSectionEntity section;

  const HomeSectionItem({
    super.key,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    if (!section.isActive) {
      return const SizedBox.shrink();
    }


    if (section is ProductsSectionEntity) {
      return ProductsSectionWidget(section: section as ProductsSectionEntity);
    } else if (section is CategoriesSectionEntity) {
      return CategoriesSectionWidget(section: section as CategoriesSectionEntity);
    } else if (section is BannerSectionEntity) {
      return BannerSectionWidget(section: section as BannerSectionEntity);
    }

    return const SizedBox.shrink();
  }
}