import 'package:equatable/equatable.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/models/pagination_model.dart';
import '../../domain/entities/product_entity.dart';

class ProductsState extends Equatable {
  final RequestStatus fetchStatus;
  final PaginationModel<ProductEntity> pagination;
  final String? errorMessage;
  final String searchQuery;
  final String? selectedCategoryId;

  const ProductsState({
    this.fetchStatus = RequestStatus.initial,
    this.pagination = const PaginationModel(items: [], hasMore: true),
    this.errorMessage,
    this.searchQuery = '',
    this.selectedCategoryId,
  });

  ProductsState copyWith({
    RequestStatus? fetchStatus,
    PaginationModel<ProductEntity>? pagination,
    String? errorMessage,
    String? searchQuery,
    String? selectedCategoryId,
    bool clearSelectedCategory = false,
  }) {
    return ProductsState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      pagination: pagination ?? this.pagination,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategoryId: clearSelectedCategory
          ? null
          : (selectedCategoryId ?? this.selectedCategoryId),
    );
  }

  @override
  List<Object?> get props => [
        fetchStatus,
        pagination,
        errorMessage,
        searchQuery,
        selectedCategoryId,
      ];
}
