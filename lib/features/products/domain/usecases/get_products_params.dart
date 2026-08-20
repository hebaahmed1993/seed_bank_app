import 'package:equatable/equatable.dart';
import '../../../../core/params/pagination_params.dart';

class GetProductsParams extends Equatable {
  final PaginationParams paginationParams;
  final String? categoryId;
  final String? searchQuery;

  const GetProductsParams({
    required this.paginationParams,
    this.categoryId,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [
        paginationParams,
        categoryId,
        searchQuery,
      ];
}
