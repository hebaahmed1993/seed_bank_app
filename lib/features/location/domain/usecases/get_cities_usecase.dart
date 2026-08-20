import '../../../../core/utils/typedefs.dart';
import '../entities/city_entity.dart';
import '../repositories/location_repository.dart';

class GetCitiesUseCase {
  final LocationRepository _repository;

  const GetCitiesUseCase(this._repository);

  ResultFuture<List<CityEntity>> call() async {
    return await _repository.getCities();
  }
}
