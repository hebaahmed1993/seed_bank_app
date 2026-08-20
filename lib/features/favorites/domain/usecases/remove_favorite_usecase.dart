import '../../../../core/utils/typedefs.dart';
import '../repositories/favorites_repository.dart';

class RemoveFavoriteParams {
  final String userId;
  final String productId;

  const RemoveFavoriteParams({
    required this.userId,
    required this.productId,
  });
}

class RemoveFavoriteUseCase {
  final FavoritesRepository _repository;

  const RemoveFavoriteUseCase(this._repository);

  ResultFuture<void> call(RemoveFavoriteParams params) async {
    return await _repository.removeFavorite(
      userId: params.userId,
      productId: params.productId,
    );
  }
}
