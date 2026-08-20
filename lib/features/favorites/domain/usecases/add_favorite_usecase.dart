import '../../../../core/utils/typedefs.dart';
import '../entities/favorite_entity.dart';
import '../repositories/favorites_repository.dart';

class AddFavoriteUseCase {
  final FavoritesRepository _repository;

  const AddFavoriteUseCase(this._repository);

  ResultFuture<void> call(FavoriteEntity favorite) async {
    return await _repository.addFavorite(favorite);
  }
}
