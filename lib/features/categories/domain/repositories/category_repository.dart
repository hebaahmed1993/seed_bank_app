import '../../../../core/models/pagination_model.dart';
import '../../../../core/params/pagination_params.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/category_entity.dart';

abstract class CategoryRepository {
  ResultFuture<PaginationModel<CategoryEntity>> getMainCategoriesPaginated(
      PaginationParams params,
      );

  ResultFuture<List<CategoryEntity>> getSubcategories({
    required String parentId,
  });

  ResultFuture<List<CategoryEntity>> getCategoriesByIds({
    required List<String> categoryIds,
  });
}