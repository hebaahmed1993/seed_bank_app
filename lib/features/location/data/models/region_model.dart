import '../../domain/entities/region_entity.dart';

class RegionModel extends RegionEntity {
  const RegionModel({
    required super.regionId,
    required super.cityId,
    required super.name,
    required super.baseFee,
    required super.estimatedDays,
    required super.isAvailable,
  });

  factory RegionModel.fromJson(Map<String, dynamic> json, [String? documentId]) {
    return RegionModel(
      regionId: json['regionId'] as String? ?? documentId ?? '',
      cityId: json['cityId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      baseFee: (json['baseFee'] as num?) ?? 0,
      estimatedDays: json['estimatedDays'] as String? ?? '',
      isAvailable: json['isAvailable'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'regionId': regionId,
      'cityId': cityId,
      'name': name,
      'baseFee': baseFee,
      'estimatedDays': estimatedDays,
      'isAvailable': isAvailable,
    };
  }

  RegionEntity toEntity() {
    return RegionEntity(
      regionId: regionId,
      cityId: cityId,
      name: name,
      baseFee: baseFee,
      estimatedDays: estimatedDays,
      isAvailable: isAvailable,
    );
  }

  factory RegionModel.fromEntity(RegionEntity entity) {
    return RegionModel(
      regionId: entity.regionId,
      cityId: entity.cityId,
      name: entity.name,
      baseFee: entity.baseFee,
      estimatedDays: entity.estimatedDays,
      isAvailable: entity.isAvailable,
    );
  }
}
