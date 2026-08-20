import '../models/city_model.dart';
import '../models/region_model.dart';

abstract class LocationRemoteDataSource {
  Future<List<CityModel>> getCities();

  Future<List<RegionModel>> getRegionsByCity(String cityId);
}
