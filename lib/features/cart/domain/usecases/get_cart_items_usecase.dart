import '../../../../core/params/no_params.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

class GetCartItemsUseCase {
  final CartRepository repository;

  const GetCartItemsUseCase(this.repository);

  ResultFuture<List<CartItemEntity>> call(NoParams params) {
    return repository.getCartItems();
  }
}
