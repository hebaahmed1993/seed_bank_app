import '../../../../core/params/no_params.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/home_section_entity.dart';
import '../repositories/home_repository.dart';

class GetHomeSectionsUseCase {
  final HomeRepository repository;

  const GetHomeSectionsUseCase(this.repository);

  ResultFuture<List<HomeSectionEntity>> call(NoParams params) async {
    return await repository.getHomeSections();
  }
}
