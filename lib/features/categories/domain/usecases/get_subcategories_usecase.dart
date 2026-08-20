import '../../../../core/utils/typedefs.dart';
import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class GetSubcategoriesUseCase {
  final CategoryRepository _repository;

  const GetSubcategoriesUseCase(this._repository);

  ResultFuture<List<CategoryEntity>> call(String parentId) async {
    return await _repository.getSubcategories(parentId: parentId);
  }
}
