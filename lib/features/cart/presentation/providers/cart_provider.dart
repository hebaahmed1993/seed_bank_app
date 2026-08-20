import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/params/no_params.dart';
import '../../data/datasources/cart_remote_datasource.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/usecases/get_cart_items_usecase.dart';

final cartRemoteDataSourceProvider = Provider<CartRemoteDataSource>((ref) {
  return CartRemoteDataSourceImpl();
});

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  final remoteDataSource = ref.watch(cartRemoteDataSourceProvider);
  return CartRepositoryImpl(remoteDataSource: remoteDataSource);
});

final getCartItemsUseCaseProvider = Provider<GetCartItemsUseCase>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return GetCartItemsUseCase(repository);
});

final cartItemsProvider = FutureProvider<List<CartItemEntity>>((ref) async {
  final useCase = ref.watch(getCartItemsUseCaseProvider);
  final result = await useCase(const NoParams());
  return result.fold(
    (failure) => throw Exception(failure.message),
    (items) => items,
  );
});

final cartTotalCountProvider = Provider<int>((ref) {
  final cartItemsState = ref.watch(cartItemsProvider);
  return cartItemsState.maybeWhen(
    data: (items) => items.fold(0, (sum, item) => sum + item.quantity),
    orElse: () => 0,
  );
});
