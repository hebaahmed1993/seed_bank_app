import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/category_entity.dart';

class CategoryModel {
  final String id;
  final String name;
  final String? imageUrl;
  final String? parentId;
  final int productsCount;
  final bool isActive;
  final int sortOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CategoryModel({
    required this.id,
    required this.name,
    this.imageUrl,
    this.parentId,
    this.productsCount = 0,
    this.isActive = true,
    this.sortOrder = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json, String documentId) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      if (value is String) return DateTime.tryParse(value);
      return null;
    }

    final rawImageUrl = (json['imageUrl'] ?? json['image'] ?? json['icon']) as String?;
    final cleanImageUrl = (rawImageUrl != null && rawImageUrl.trim().isNotEmpty)
        ? rawImageUrl.trim()
        : null;

    final rawParentId = json['parentId'] as String?;
    final cleanParentId = (rawParentId != null && rawParentId.trim().isNotEmpty)
        ? rawParentId.trim()
        : null;

    return CategoryModel(
      id: documentId,
      name: json['name'] as String? ?? '',
      imageUrl: cleanImageUrl,
      parentId: cleanParentId,
      productsCount: ((json['product_count'] ?? json['productsCount'] ?? json['subcategoriesCount']) as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      sortOrder: ((json['sortOrder'] ?? json['order'] ?? json['displayOrder']) as num?)?.toInt() ?? 0,
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (parentId != null) 'parentId': parentId,
      'product_count': productsCount,
      'isActive': isActive,
      'sortOrder': sortOrder,
      if (createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!),
      if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
    };
  }

  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      imageUrl: imageUrl,
      parentId: parentId,
      subcategoriesCount: productsCount,
      isActive: isActive,
      displayOrder: sortOrder,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory CategoryModel.fromEntity(CategoryEntity entity) {
    return CategoryModel(
      id: entity.id,
      name: entity.name,
      imageUrl: entity.imageUrl,
      parentId: entity.parentId,
      productsCount: entity.subcategoriesCount,
      isActive: entity.isActive,
      sortOrder: entity.displayOrder,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}