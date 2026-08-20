import '../../../../core/utils/typedefs.dart';
import '../entities/cart_item_entity.dart';

abstract class CartRepository {
  ResultFuture<List<CartItemEntity>> getCartItems();
}
