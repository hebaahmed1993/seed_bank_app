import '../../../../core/models/pagination_model.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/product_entity.dart';
import '../usecases/get_products_params.dart';

abstract class ProductRepository {
  ResultFuture<PaginationModel<ProductEntity>> getProductsPaginated(
    GetProductsParams params,
  );

  ResultFuture<List<ProductEntity>> getProductsByIds(
    List<String> ids,
  );

  ResultFuture<ProductEntity> getProductById(
    String id,
  );
}
