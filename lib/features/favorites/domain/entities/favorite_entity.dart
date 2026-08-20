import 'package:equatable/equatable.dart';

class FavoriteEntity extends Equatable {
  final String id;
  final String userId;
  final String productId;
  final DateTime? createdAt;

  const FavoriteEntity({
    required this.id,
    required this.userId,
    required this.productId,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    productId,
    createdAt,
  ];
}