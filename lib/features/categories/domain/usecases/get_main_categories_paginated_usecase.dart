import '../../../../core/models/pagination_model.dart';
import '../../../../core/params/pagination_params.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class GetMainCategoriesPaginatedUseCase {
  final CategoryRepository _repository;

  const GetMainCategoriesPaginatedUseCase(this._repository);

  ResultFuture<PaginationModel<CategoryEntity>> call(PaginationParams params) async {
    return await _repository.getMainCategoriesPaginated(params);
  }
}