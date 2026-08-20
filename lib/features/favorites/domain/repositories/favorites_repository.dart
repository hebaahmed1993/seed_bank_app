import '../../../../core/utils/typedefs.dart';
import '../entities/favorite_entity.dart';

abstract class FavoritesRepository {
  /// جلب قائمة المفضلة الخاصة بالمستخدم
  ResultFuture<List<FavoriteEntity>> getFavorites(String userId);

  /// إضافة منتج إلى المفضلة
  ResultFuture<void> addFavorite(FavoriteEntity favorite);

  /// حذف منتج من المفضلة
  ResultFuture<void> removeFavorite({
    required String userId,
    required String productId,
  });

  /// التحقق مما إذا كان المنتج مضافاً للمفضلة
  ResultFuture<bool> isFavorite({
    required String userId,
    required String productId,
  });
}
