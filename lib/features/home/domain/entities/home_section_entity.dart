import 'package:equatable/equatable.dart';

enum HomeSectionType {
  products,
  categories,
  banner,
}

// ✨ الـ Enum الجديد الخاص بأشكال الإعلانات
enum BannerStyle {
  slider,
  hero,
  strip,
}

abstract class HomeSectionEntity extends Equatable {
  final String id;
  final String title;
  final HomeSectionType type;
  final int order;
  final bool isActive;

  const HomeSectionEntity({
    required this.id,
    required this.title,
    required this.type,
    required this.order,
    required this.isActive,
  });

  @override
  List<Object?> get props => [id, title, type, order, isActive];
}

// 🛒 كيان قسم المنتجات (بقي كما هو)
class ProductsSectionEntity extends HomeSectionEntity {
  final List<String> productIds;
  final int limit;
  final String? selectionMode;
  final String? dynamicFilterType;

  const ProductsSectionEntity({
    required super.id,
    required super.title,
    required super.order,
    required super.isActive,
    this.productIds = const [],
    this.limit = 10,
    this.selectionMode,
    this.dynamicFilterType,
  }) : super(type: HomeSectionType.products);

  @override
  List<Object?> get props => [
    ...super.props,
    productIds,
    limit,
    selectionMode,
    dynamicFilterType,
  ];
}

// 🗂️ كيان قسم التصنيفات (بقي كما هو)
class CategoriesSectionEntity extends HomeSectionEntity {
  final List<String> categoryIds;
  final int limit;

  const CategoriesSectionEntity({
    required super.id,
    required super.title,
    required super.order,
    required super.isActive,
    this.categoryIds = const [],
    this.limit = 10,
  }) : super(type: HomeSectionType.categories);

  @override
  List<Object?> get props => [
    ...super.props,
    categoryIds,
    limit,
  ];
}

class BannerItemEntity extends Equatable {
  final String imageUrl;
  final String? targetUrl;

  const BannerItemEntity({
    required this.imageUrl,
    this.targetUrl,
  });

  @override
  List<Object?> get props => [imageUrl, targetUrl];
}

// 🖼️ كيان قسم البنر (تم تعديل نوع bannerStyle)
class BannerSectionEntity extends HomeSectionEntity {
  final BannerStyle bannerStyle; // ✨ أصبح Enum
  final List<BannerItemEntity> banners;

  const BannerSectionEntity({
    required super.id,
    required super.title,
    required super.order,
    required super.isActive,
    this.bannerStyle = BannerStyle.slider, // ✨ القيمة الافتراضية
    this.banners = const [],
  }) : super(type: HomeSectionType.banner);

  @override
  List<Object?> get props => [
    ...super.props,
    bannerStyle,
    banners,
  ];
}