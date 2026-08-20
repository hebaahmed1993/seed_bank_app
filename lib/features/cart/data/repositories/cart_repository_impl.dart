import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_datasource.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl({required this.remoteDataSource});

  @override
  ResultFuture<List<CartItemEntity>> getCartItems() async {
    try {
      final items = await remoteDataSource.getCartItems();
      return Right(items);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, ));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
