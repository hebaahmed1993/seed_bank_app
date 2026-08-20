import '../../../../core/utils/typedefs.dart';
import '../entities/favorite_entity.dart';
import '../repositories/favorites_repository.dart';

class GetFavoritesUseCase {
  final FavoritesRepository _repository;

  const GetFavoritesUseCase(this._repository);

  ResultFuture<List<FavoriteEntity>> call(String userId) async {
    return await _repository.getFavorites(userId);
  }
}
