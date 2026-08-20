import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.categoryId,
    required super.name,
    required super.description,
    required super.price,
    required super.discountPrice,
    required super.hasDiscount,
    required super.stockQuantity,
    required super.lowStockThreshold,
    required super.salesCount,
    required super.sku,
    required super.imageUrl,
    required super.isActive,
    required super.defaultSupplierId,
    required super.germinationRate,
    required super.hasExpiryTracking,
    required super.season,
    required super.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json, [String? documentId]) {
    DateTime parseCreatedAt(dynamic value) {
      if (value is Timestamp) {
        return value.toDate();
      } else if (value is String) {
        return DateTime.tryParse(value) ?? DateTime.now();
      } else if (value is DateTime) {
        return value;
      }
      return DateTime.now();
    }

    return ProductModel(
      id: json['id'] as String? ?? documentId ?? '',
      categoryId: json['categoryId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?) ?? 0,
      discountPrice: (json['discountPrice'] as num?) ?? 0,
      hasDiscount: json['hasDiscount'] as bool? ?? false,
      stockQuantity: ((json['stockQuantity'] as num?)?.toInt()) ?? 0,
      lowStockThreshold: ((json['lowStockThreshold'] as num?)?.toInt()) ?? 0,
      salesCount: ((json['salesCount'] as num?)?.toInt()) ?? 0,
      sku: json['sku'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? false,
      defaultSupplierId: json['defaultSupplierId'] as String? ?? '',
      germinationRate: (json['germinationRate'] as num?) ?? 0,
      hasExpiryTracking: json['hasExpiryTracking'] as bool? ?? false,
      season: json['season'] as String? ?? '',
      createdAt: parseCreatedAt(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'name': name,
      'description': description,
      'price': price,
      'discountPrice': discountPrice,
      'hasDiscount': hasDiscount,
      'stockQuantity': stockQuantity,
      'lowStockThreshold': lowStockThreshold,
      'salesCount': salesCount,
      'sku': sku,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'defaultSupplierId': defaultSupplierId,
      'germinationRate': germinationRate,
      'hasExpiryTracking': hasExpiryTracking,
      'season': season,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      categoryId: categoryId,
      name: name,
      description: description,
      price: price,
      discountPrice: discountPrice,
      hasDiscount: hasDiscount,
      stockQuantity: stockQuantity,
      lowStockThreshold: lowStockThreshold,
      salesCount: salesCount,
      sku: sku,
      imageUrl: imageUrl,
      isActive: isActive,
      defaultSupplierId: defaultSupplierId,
      germinationRate: germinationRate,
      hasExpiryTracking: hasExpiryTracking,
      season: season,
      createdAt: createdAt,
    );
  }

  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id,
      categoryId: entity.categoryId,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      discountPrice: entity.discountPrice,
      hasDiscount: entity.hasDiscount,
      stockQuantity: entity.stockQuantity,
      lowStockThreshold: entity.lowStockThreshold,
      salesCount: entity.salesCount,
      sku: entity.sku,
      imageUrl: entity.imageUrl,
      isActive: entity.isActive,
      defaultSupplierId: entity.defaultSupplierId,
      germinationRate: entity.germinationRate,
      hasExpiryTracking: entity.hasExpiryTracking,
      season: entity.season,
      createdAt: entity.createdAt,
    );
  }
}
