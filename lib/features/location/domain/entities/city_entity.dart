import 'package:equatable/equatable.dart';

class CityEntity extends Equatable {
  final String cityId;
  final String name;
  final bool isActive;

  const CityEntity({
    required this.cityId,
    required this.name,
    required this.isActive,
  });

  @override
  List<Object?> get props => [cityId, name, isActive];
}
