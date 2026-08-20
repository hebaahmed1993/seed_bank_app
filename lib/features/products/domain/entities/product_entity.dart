import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String categoryId;
  final String name;
  final String description;
  final num price;
  final num discountPrice;
  final bool hasDiscount;
  final int stockQuantity;
  final int lowStockThreshold;
  final int salesCount;
  final String sku;
  final String imageUrl;
  final bool isActive;
  final String defaultSupplierId;
  final num germinationRate;
  final bool hasExpiryTracking;
  final String season;
  final DateTime createdAt;

  const ProductEntity({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.discountPrice,
    required this.hasDiscount,
    required this.stockQuantity,
    required this.lowStockThreshold,
    required this.salesCount,
    required this.sku,
    required this.imageUrl,
    required this.isActive,
    required this.defaultSupplierId,
    required this.germinationRate,
    required this.hasExpiryTracking,
    required this.season,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        categoryId,
        name,
        description,
        price,
        discountPrice,
        hasDiscount,
        stockQuantity,
        lowStockThreshold,
        salesCount,
        sku,
        imageUrl,
        isActive,
        defaultSupplierId,
        germinationRate,
        hasExpiryTracking,
        season,
        createdAt,
      ];
}
