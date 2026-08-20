import '../../domain/entities/city_entity.dart';

class CityModel extends CityEntity {
  const CityModel({
    required super.cityId,
    required super.name,
    required super.isActive,
  });

  factory CityModel.fromJson(Map<String, dynamic> json, [String? documentId]) {
    return CityModel(
      cityId: json['cityId'] as String? ?? documentId ?? '',
      name: json['name'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cityId': cityId,
      'name': name,
      'isActive': isActive,
    };
  }

  CityEntity toEntity() {
    return CityEntity(
      cityId: cityId,
      name: name,
      isActive: isActive,
    );
  }

  factory CityModel.fromEntity(CityEntity entity) {
    return CityModel(
      cityId: entity.cityId,
      name: entity.name,
      isActive: entity.isActive,
    );
  }
}
