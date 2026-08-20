import '../models/cart_item_model.dart';

abstract class CartRemoteDataSource {
  Future<List<CartItemModel>> getCartItems();
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  @override
  Future<List<CartItemModel>> getCartItems() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      CartItemModel(id: 'c1', title: 'منتج السلة الأول', price: 120.0, quantity: 2),
      CartItemModel(id: 'c2', title: 'منتج السلة الثاني', price: 85.0, quantity: 1),
    ];
  }
}
