import '../../../../core/models/pagination_model.dart';
import '../../domain/usecases/get_products_params.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<PaginationModel<ProductModel>> getProductsPaginated(
    GetProductsParams params,
  );

  Future<List<ProductModel>> getProductsByIds(
    List<String> ids,
  );

  Future<ProductModel> getProductById(
    String id,
  );
}
