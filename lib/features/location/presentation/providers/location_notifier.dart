import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enums/app_enums.dart';
import '../../domain/usecases/get_cities_usecase.dart';
import '../../domain/usecases/get_regions_by_city_usecase.dart';
import 'location_state.dart';

class LocationNotifier extends StateNotifier<LocationState> {
  final GetCitiesUseCase getCitiesUseCase;
  final GetRegionsByCityUseCase getRegionsByCityUseCase;

  LocationNotifier({
    required this.getCitiesUseCase,
    required this.getRegionsByCityUseCase,
  }) : super(const LocationState()) {
    fetchCities();
  }

  Future<void> fetchCities() async {
    state = state.copyWith(
      fetchCitiesStatus: RequestStatus.loading,
      errorMessage: null,
    );

    final result = await getCitiesUseCase();

    result.fold(
      (failure) {
        state = state.copyWith(
          fetchCitiesStatus: RequestStatus.error,
          errorMessage: failure.message,
        );
      },
      (cities) {
        state = state.copyWith(
          fetchCitiesStatus: RequestStatus.success,
          cities: cities,
        );
      },
    );
  }

  Future<void> fetchRegions(String cityId) async {
    if (cityId.isEmpty) {
      clearRegions();
      return;
    }

    state = state.copyWith(
      fetchRegionsStatus: RequestStatus.loading,
      errorMessage: null,
    );

    final result = await getRegionsByCityUseCase(cityId);

    result.fold(
      (failure) {
        state = state.copyWith(
          fetchRegionsStatus: RequestStatus.error,
          errorMessage: failure.message,
        );
      },
      (regions) {
        state = state.copyWith(
          fetchRegionsStatus: RequestStatus.success,
          regions: regions,
        );
      },
    );
  }

  void clearRegions() {
    state = state.copyWith(
      fetchRegionsStatus: RequestStatus.initial,
      regions: const [],
    );
  }
}
