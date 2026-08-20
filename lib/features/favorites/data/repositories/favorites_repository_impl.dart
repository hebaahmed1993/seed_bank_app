import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/favorite_entity.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_remote_datasource.dart';
import '../models/favorite_model.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDataSource remoteDataSource;

  FavoritesRepositoryImpl({required this.remoteDataSource});

  @override
  ResultFuture<List<FavoriteEntity>> getFavorites(String userId) async {
    try {
      final result = await remoteDataSource.getFavorites(userId);
      return Right(result);
    } catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  ResultFuture<void> addFavorite(FavoriteEntity favorite) async {
    try {
      final model = FavoriteModel.fromEntity(favorite);
      await remoteDataSource.addFavorite(model);
      return const Right(null);
    } catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  ResultFuture<void> removeFavorite({
    required String userId,
    required String productId,
  }) async {
    try {
      await remoteDataSource.removeFavorite(
        userId: userId,
        productId: productId,
      );
      return const Right(null);
    } catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  ResultFuture<bool> isFavorite({
    required String userId,
    required String productId,
  }) async {
    try {
      final isFav = await remoteDataSource.isFavorite(
        userId: userId,
        productId: productId,
      );
      return Right(isFav);
    } catch (e) {
      return Left(e.toFailure());
    }
  }
}
