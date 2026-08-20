import '../../../../core/utils/typedefs.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductByIdUseCase {
  final ProductRepository _repository;

  const GetProductByIdUseCase(this._repository);

  ResultFuture<ProductEntity> call(
    String id,
  ) async {
    return await _repository.getProductById(id);
  }
}
