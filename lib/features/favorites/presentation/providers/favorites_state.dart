import 'package:equatable/equatable.dart';
import '../../../../core/enums/app_enums.dart';
import '../../domain/entities/favorite_entity.dart';

class FavoritesState extends Equatable {
  final RequestStatus fetchStatus;
  final RequestStatus addStatus;
  final RequestStatus removeStatus;
  final List<FavoriteEntity> items;
  final String? errorMessage;
  final String? actionSuccessMessage;

  const FavoritesState({
    this.fetchStatus = RequestStatus.initial,
    this.addStatus = RequestStatus.initial,
    this.removeStatus = RequestStatus.initial,
    this.items = const [],
    this.errorMessage,
    this.actionSuccessMessage,
  });

  FavoritesState copyWith({
    RequestStatus? fetchStatus,
    RequestStatus? addStatus,
    RequestStatus? removeStatus,
    List<FavoriteEntity>? items,
    String? errorMessage,
    String? actionSuccessMessage,
  }) {
    return FavoritesState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      addStatus: addStatus ?? this.addStatus,
      removeStatus: removeStatus ?? this.removeStatus,
      items: items ?? this.items,
      errorMessage: errorMessage,
      actionSuccessMessage: actionSuccessMessage,
    );
  }

  bool isProductFavorite(String productId) {
    return items.any((item) => item.productId == productId);
  }

  @override
  List<Object?> get props => [
        fetchStatus,
        addStatus,
        removeStatus,
        items,
        errorMessage,
        actionSuccessMessage,
      ];
}
