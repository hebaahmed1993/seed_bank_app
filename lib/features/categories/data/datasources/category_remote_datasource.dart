import '../../../../core/models/pagination_model.dart';
import '../models/category_model.dart';
import '../../../../core/params/pagination_params.dart';

abstract class CategoryRemoteDataSource {
  Future<PaginationModel<CategoryModel>> getMainCategoriesPaginated(
      PaginationParams params,
      );

  Future<List<CategoryModel>> getSubcategories({
    required String parentId,
  });

  Future<List<CategoryModel>> getCategoriesByIds({
    required List<String> categoryIds,
  });
}