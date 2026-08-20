import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/location_remote_datasource.dart';
import '../../data/datasources/location_remote_datasource_impl.dart';
import '../../data/repositories/location_repository_impl.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/usecases/get_cities_usecase.dart';
import '../../domain/usecases/get_regions_by_city_usecase.dart';
import 'location_notifier.dart';
import 'location_state.dart';

final locationRemoteDataSourceProvider =
    Provider<LocationRemoteDataSource>((ref) {
  return LocationRemoteDataSourceImpl(
    firestore: FirebaseFirestore.instance,
  );
});

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  final remoteDataSource = ref.watch(locationRemoteDataSourceProvider);
  return LocationRepositoryImpl(remoteDataSource: remoteDataSource);
});

final getCitiesUseCaseProvider = Provider<GetCitiesUseCase>((ref) {
  final repository = ref.watch(locationRepositoryProvider);
  return GetCitiesUseCase(repository);
});

final getRegionsByCityUseCaseProvider =
    Provider<GetRegionsByCityUseCase>((ref) {
  final repository = ref.watch(locationRepositoryProvider);
  return GetRegionsByCityUseCase(repository);
});

final locationNotifierProvider =
    StateNotifierProvider<LocationNotifier, LocationState>((ref) {
  return LocationNotifier(
    getCitiesUseCase: ref.watch(getCitiesUseCaseProvider),
    getRegionsByCityUseCase: ref.watch(getRegionsByCityUseCaseProvider),
  );
});
