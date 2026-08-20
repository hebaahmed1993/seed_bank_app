import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/favorite_entity.dart';

class FavoriteModel extends FavoriteEntity {
  const FavoriteModel({
    required super.id,
    required super.userId,
    required super.productId,
    super.createdAt,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json, [String? docId]) {
    DateTime? parsedCreatedAt;
    if (json['createdAt'] != null) {
      if (json['createdAt'] is Timestamp) {
        parsedCreatedAt = (json['createdAt'] as Timestamp).toDate();
      } else if (json['createdAt'] is String) {
        parsedCreatedAt = DateTime.tryParse(json['createdAt'] as String);
      }
    }

    return FavoriteModel(
      id: docId ?? (json['id'] as String? ?? ''),
      userId: json['userId'] as String? ?? '',
      productId: json['productId'] as String? ?? '',
      createdAt: parsedCreatedAt,
    );
  }

  Map<String, dynamic> toDocumentJson() {
    return {
      'id': id,
      'userId': userId,
      'productId': productId,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory FavoriteModel.fromEntity(FavoriteEntity entity) {
    return FavoriteModel(
      id: entity.id,
      userId: entity.userId,
      productId: entity.productId,
      createdAt: entity.createdAt,
    );
  }
}