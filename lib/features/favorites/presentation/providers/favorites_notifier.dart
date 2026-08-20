import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/enums/app_enums.dart';
import '../../domain/entities/favorite_entity.dart';
import '../../domain/usecases/add_favorite_usecase.dart';
import '../../domain/usecases/get_favorites_usecase.dart';
import '../../domain/usecases/remove_favorite_usecase.dart';
import 'favorites_state.dart';

class FavoritesNotifier extends StateNotifier<FavoritesState> {
  final GetFavoritesUseCase _getFavoritesUseCase;
  final AddFavoriteUseCase _addFavoriteUseCase;
  final RemoveFavoriteUseCase _removeFavoriteUseCase;

  FavoritesNotifier(
    this._getFavoritesUseCase,
    this._addFavoriteUseCase,
    this._removeFavoriteUseCase,
  ) : super(const FavoritesState());

  /// جلب قائمة المفضلة بحالات منفصلة عبر result.fold دون try-catch
  Future<void> fetchFavorites(String userId) async {
    state = state.copyWith(
      fetchStatus: RequestStatus.loading,
      errorMessage: null,
      actionSuccessMessage: null,
    );

    final result = await _getFavoritesUseCase(userId);

    result.fold(
      (failure) {
        state = state.copyWith(
          fetchStatus: RequestStatus.error,
          errorMessage: failure.message,
        );
      },
      (favorites) {
        state = state.copyWith(
          fetchStatus: RequestStatus.success,
          items: favorites,
        );
      },
    );
  }

  /// إضافة عنصر للمفضلة بحالات منفصلة عبر result.fold
  Future<void> addFavorite(FavoriteEntity favorite) async {
    state = state.copyWith(
      addStatus: RequestStatus.loading,
      errorMessage: null,
      actionSuccessMessage: null,
    );

    final result = await _addFavoriteUseCase(favorite);

    result.fold(
      (failure) {
        state = state.copyWith(
          addStatus: RequestStatus.error,
          errorMessage: failure.message,
        );
      },
      (_) {
        final updatedList = List<FavoriteEntity>.from(state.items);
        final index = updatedList.indexWhere((element) => element.productId == favorite.productId);
        if (index == -1) {
          updatedList.add(favorite);
        } else {
          updatedList[index] = favorite;
        }

        state = state.copyWith(
          addStatus: RequestStatus.success,
          items: updatedList,
          actionSuccessMessage: 'تمت إضافة المنتج إلى المفضلة بنجاح',
        );
      },
    );
  }

  /// حذف عنصر من المفضلة بحالات منفصلة عبر result.fold
  Future<void> removeFavorite({
    required String userId,
    required String productId,
  }) async {
    state = state.copyWith(
      removeStatus: RequestStatus.loading,
      errorMessage: null,
      actionSuccessMessage: null,
    );

    final params = RemoveFavoriteParams(userId: userId, productId: productId);
    final result = await _removeFavoriteUseCase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          removeStatus: RequestStatus.error,
          errorMessage: failure.message,
        );
      },
      (_) {
        final updatedList = state.items.where((item) => item.productId != productId).toList();

        state = state.copyWith(
          removeStatus: RequestStatus.success,
          items: updatedList,
          actionSuccessMessage: 'تم حذف المنتج من المفضلة',
        );
      },
    );
  }

  /// إعادة تعيين رسائل التنبيه والنجاح بعد عرضها
  void clearMessages() {
    state = state.copyWith(
      errorMessage: null,
      actionSuccessMessage: null,
      addStatus: RequestStatus.initial,
      removeStatus: RequestStatus.initial,
    );
  }
}
