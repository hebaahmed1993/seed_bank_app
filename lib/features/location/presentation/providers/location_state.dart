import 'package:equatable/equatable.dart';

import '../../../../core/enums/app_enums.dart';
import '../../domain/entities/city_entity.dart';
import '../../domain/entities/region_entity.dart';

class LocationState extends Equatable {
  final RequestStatus fetchCitiesStatus;
  final RequestStatus fetchRegionsStatus;
  final List<CityEntity> cities;
  final List<RegionEntity> regions;
  final String? errorMessage;

  const LocationState({
    this.fetchCitiesStatus = RequestStatus.initial,
    this.fetchRegionsStatus = RequestStatus.initial,
    this.cities = const [],
    this.regions = const [],
    this.errorMessage,
  });

  LocationState copyWith({
    RequestStatus? fetchCitiesStatus,
    RequestStatus? fetchRegionsStatus,
    List<CityEntity>? cities,
    List<RegionEntity>? regions,
    String? errorMessage,
  }) {
    return LocationState(
      fetchCitiesStatus: fetchCitiesStatus ?? this.fetchCitiesStatus,
      fetchRegionsStatus: fetchRegionsStatus ?? this.fetchRegionsStatus,
      cities: cities ?? this.cities,
      regions: regions ?? this.regions,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        fetchCitiesStatus,
        fetchRegionsStatus,
        cities,
        regions,
        errorMessage,
      ];
}
