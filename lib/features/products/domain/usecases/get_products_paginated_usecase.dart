import '../../../../core/models/pagination_model.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';
import 'get_products_params.dart';

class GetProductsPaginatedUseCase {
  final ProductRepository _repository;

  const GetProductsPaginatedUseCase(this._repository);

  ResultFuture<PaginationModel<ProductEntity>> call(
    GetProductsParams params,
  ) async {
    return await _repository.getProductsPaginated(params);
  }
}
