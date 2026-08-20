import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String? imageUrl;
  final String? parentId;
  final int subcategoriesCount;
  final bool isActive;
  final int displayOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CategoryEntity({
    required this.id,
    required this.name,
    this.imageUrl,
    this.parentId,
    this.subcategoriesCount = 0,
    this.isActive = true,
    this.displayOrder = 0,
    this.createdAt,
    this.updatedAt,
  });

  bool get isMainCategory => parentId == null || parentId!.isEmpty;
  bool get hasSubcategories => subcategoriesCount > 0;

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrl,
        parentId,
        subcategoriesCount,
        isActive,
        displayOrder,
        createdAt,
        updatedAt,
      ];
}
