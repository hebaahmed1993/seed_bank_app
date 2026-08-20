import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/city_entity.dart';
import '../../domain/entities/region_entity.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_remote_datasource.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource remoteDataSource;

  const LocationRepositoryImpl({required this.remoteDataSource});

  @override
  ResultFuture<List<CityEntity>> getCities() async {
    try {
      final models = await remoteDataSource.getCities();
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  ResultFuture<List<RegionEntity>> getRegionsByCity(String cityId) async {
    try {
      final models = await remoteDataSource.getRegionsByCity(cityId);
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(e.toFailure());
    }
  }
}
