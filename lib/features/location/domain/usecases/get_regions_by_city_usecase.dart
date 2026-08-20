import '../../../../core/utils/typedefs.dart';
import '../entities/region_entity.dart';
import '../repositories/location_repository.dart';

class GetRegionsByCityUseCase {
  final LocationRepository _repository;

  const GetRegionsByCityUseCase(this._repository);

  ResultFuture<List<RegionEntity>> call(String cityId) async {
    return await _repository.getRegionsByCity(cityId);
  }
}
