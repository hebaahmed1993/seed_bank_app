import 'package:equatable/equatable.dart';

class RegionEntity extends Equatable {
  final String regionId;
  final String cityId;
  final String name;
  final num baseFee;
  final String estimatedDays;
  final bool isAvailable;

  const RegionEntity({
    required this.regionId,
    required this.cityId,
    required this.name,
    required this.baseFee,
    required this.estimatedDays,
    required this.isAvailable,
  });

  @override
  List<Object?> get props => [
        regionId,
        cityId,
        name,
        baseFee,
        estimatedDays,
        isAvailable,
      ];
}
