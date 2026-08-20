import 'package:equatable/equatable.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/models/pagination_model.dart';
import '../../domain/entities/category_entity.dart';

class CategoriesState extends Equatable {
  final RequestStatus fetchStatus;
  final PaginationModel<CategoryEntity> pagination;
  final String? errorMessage;

  final RequestStatus subcategoriesStatus;
  final List<CategoryEntity> subcategories;
  final String? subcategoriesErrorMessage;
  final CategoryEntity? selectedParentCategory;

  const CategoriesState({
    this.fetchStatus = RequestStatus.initial,
    this.pagination = const PaginationModel(items: [], hasMore: true),
    this.errorMessage,
    this.subcategoriesStatus = RequestStatus.initial,
    this.subcategories = const [],
    this.subcategoriesErrorMessage,
    this.selectedParentCategory,
  });

  // 💡 لضمان عدم تعطل واجهة المستخدم الحالية أثناء التعديل
  List<CategoryEntity> get categories => pagination.items;
  bool get hasMore => pagination.hasMore;
  bool get isFetchingMore => fetchStatus == RequestStatus.loading && pagination.items.isNotEmpty;

  CategoriesState copyWith({
    RequestStatus? fetchStatus,
    PaginationModel<CategoryEntity>? pagination,
    String? errorMessage,
    RequestStatus? subcategoriesStatus,
    List<CategoryEntity>? subcategories,
    String? subcategoriesErrorMessage,
    CategoryEntity? selectedParentCategory,
  }) {
    return CategoriesState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      pagination: pagination ?? this.pagination,
      errorMessage: errorMessage,
      subcategoriesStatus: subcategoriesStatus ?? this.subcategoriesStatus,
      subcategories: subcategories ?? this.subcategories,
      subcategoriesErrorMessage: subcategoriesErrorMessage,
      selectedParentCategory: selectedParentCategory ?? this.selectedParentCategory,
    );
  }

  @override
  List<Object?> get props => [
    fetchStatus,
    pagination,
    errorMessage,
    subcategoriesStatus,
    subcategories,
    subcategoriesErrorMessage,
    selectedParentCategory,
  ];
}