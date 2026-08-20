import '../../../../core/utils/typedefs.dart';
import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class GetCategoriesByIdsUseCase {
  final CategoryRepository _repository;

  const GetCategoriesByIdsUseCase(this._repository);

  ResultFuture<List<CategoryEntity>> call(List<String> categoryIds) async {
    return await _repository.getCategoriesByIds(categoryIds: categoryIds);
  }
}
