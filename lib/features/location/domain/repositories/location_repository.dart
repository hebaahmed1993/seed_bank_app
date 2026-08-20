import '../../../../core/utils/typedefs.dart';
import '../entities/city_entity.dart';
import '../entities/region_entity.dart';

abstract class LocationRepository {
  ResultFuture<List<CityEntity>> getCities();

  ResultFuture<List<RegionEntity>> getRegionsByCity(String cityId);
}
