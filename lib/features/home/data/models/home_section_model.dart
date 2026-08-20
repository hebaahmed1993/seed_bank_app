import '../../domain/entities/home_section_entity.dart';

class HomeSectionModel {
  final String id;
  final String title;
  final String typeString;
  final int order;
  final bool isActive;
  final List<String> categoryIds;
  final List<String> productIds;
  final int limit;
  final String? dynamicFilterType;
  final String? selectionMode;
  final String bannerStyleString; // ✨ بقي String هنا لأنه قادم من JSON
  final List<Map<String, dynamic>> banners;

  const HomeSectionModel({
    required this.id,
    required this.title,
    required this.typeString,
    required this.order,
    required this.isActive,
    this.categoryIds = const [],
    this.productIds = const [],
    this.limit = 10,
    this.dynamicFilterType,
    this.selectionMode,
    this.bannerStyleString = 'slider',
    this.banners = const [],
  });

  factory HomeSectionModel.fromJson(Map<String, dynamic> json, String documentId) {
    String determineType() {
      final rawType = (json['type'] ?? json['sectionType'] ?? '').toString().toLowerCase();
      if (rawType.contains('cat') || rawType.contains('تصنيف') || (json['categoryIds'] as List?)?.isNotEmpty == true) {
        return 'categories';
      }
      if (rawType.contains('ban') || rawType.contains('بنر') || rawType.contains('اعلان')) {
        return 'banner';
      }
      return 'products';
    }

    return HomeSectionModel(
      id: documentId,
      title: json['title'] as String? ?? '',
      typeString: determineType(),
      order: (json['order'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      categoryIds: (json['categoryIds'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      productIds: (json['productIds'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      limit: (json['limit'] as num?)?.toInt() ?? 10,
      dynamicFilterType: json['dynamicFilterType'] as String?,
      selectionMode: json['selectionMode'] as String?,
      bannerStyleString: json['bannerStyle'] as String? ?? 'slider', // نأخذ النص من فايربيس
      banners: (json['banners'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList() ?? const [],
    );
  }

  HomeSectionEntity toEntity() {
    switch (typeString) {
      case 'categories':
        return CategoriesSectionEntity(
          id: id,
          title: title,
          order: order,
          isActive: isActive,
          categoryIds: categoryIds,
          limit: limit,
        );
      case 'banner':
      // ✨ دالة التحويل من نص إلى Enum
        BannerStyle getStyle(String style) {
          switch (style.toLowerCase()) {
            case 'hero':
              return BannerStyle.hero;
            case 'strip':
              return BannerStyle.strip;
            case 'slider':
            default:
              return BannerStyle.slider;
          }
        }

        return BannerSectionEntity(
          id: id,
          title: title,
          order: order,
          isActive: isActive,
          bannerStyle: getStyle(bannerStyleString), // ✨ تمرير الـ Enum النظيف
          banners: banners.map((b) => BannerItemEntity(
            imageUrl: b['imageUrl'] as String? ?? '',
            targetUrl: b['targetUrl'] as String?,
          )).where((b) => b.imageUrl.isNotEmpty).toList(),
        );
      case 'products':
      default:
        return ProductsSectionEntity(
          id: id,
          title: title,
          order: order,
          isActive: isActive,
          productIds: productIds,
          limit: limit,
          selectionMode: selectionMode,
          dynamicFilterType: dynamicFilterType,
        );
    }
  }
}