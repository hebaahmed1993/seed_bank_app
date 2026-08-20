import '../../../../core/utils/typedefs.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductsByIdsUseCase {
  final ProductRepository _repository;

  const GetProductsByIdsUseCase(this._repository);

  ResultFuture<List<ProductEntity>> call(
    List<String> ids,
  ) async {
    return await _repository.getProductsByIds(ids);
  }
}
