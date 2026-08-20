import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/enums/pagination_action.dart';
import '../../data/datasources/category_remote_datasource.dart';
import '../../data/datasources/category_remote_datasource_impl.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/usecases/get_categories_by_ids_usecase.dart';
import '../../domain/usecases/get_main_categories_paginated_usecase.dart';
import '../../domain/usecases/get_subcategories_usecase.dart';
import 'categories_state.dart';





import '../../../../core/models/pagination_model.dart';
import '../../../../core/params/pagination_params.dart';

class CategoriesNotifier extends StateNotifier<CategoriesState> {
  final GetMainCategoriesPaginatedUseCase _getMainCategoriesPaginatedUseCase;
  final GetSubcategoriesUseCase _getSubcategoriesUseCase;
  final GetCategoriesByIdsUseCase _getCategoriesByIdsUseCase;

  CategoriesNotifier(
      this._getMainCategoriesPaginatedUseCase,
      this._getSubcategoriesUseCase,
      this._getCategoriesByIdsUseCase,
      ) : super(const CategoriesState()) {
    fetchCategories();
  }

  /// دالة موحدة للتحميل الأولي، التحديث، وجلب المزيد من التصنيفات
  Future<void> fetchCategories({
    PaginationAction action = PaginationAction.refresh,
  }) async {
    // منع التكرار إذا كان يحمل بالفعل، أو إذا طلب التالي ولا يوجد المزيد
    if (state.fetchStatus == RequestStatus.loading) return;
    if (action == PaginationAction.next && !state.pagination.hasMore) return;

    state = state.copyWith(
      fetchStatus: RequestStatus.loading,
      errorMessage: null,
      // تصفير القائمة فقط إذا كان الإجراء Refresh
      pagination: action == PaginationAction.refresh
          ? PaginationModel<CategoryEntity>.empty()
          : state.pagination,
    );

    final params = PaginationParams(
      limit: 10,
      action: action,
      firstDoc: action == PaginationAction.previous ? state.pagination.firstDoc : null,
      lastDoc: action == PaginationAction.next ? state.pagination.lastDoc : null,
    );

    final result = await _getMainCategoriesPaginatedUseCase(params);

    result.fold(
          (failure) {
        state = state.copyWith(
          fetchStatus: RequestStatus.error,
          errorMessage: failure.message,
        );
      },
          (newPagination) {
        List<CategoryEntity> updatedItems = newPagination.items;

        // دمج القوائم في حالة التقدم للأمام
        if (action == PaginationAction.next) {
          updatedItems = [...state.pagination.items, ...newPagination.items];
        }

        state = state.copyWith(
          fetchStatus: RequestStatus.success,
          pagination: newPagination.copyWith(
            items: updatedItems,
            currentPage: action == PaginationAction.next
                ? state.pagination.currentPage + 1
                : 1,
          ),
        );
      },
    );
  }




  /// اختصار لطلب الصفحة التالية (يُستدعى من الـ ScrollController)
  Future<void> fetchMoreMainCategories() async {
    await fetchCategories(action: PaginationAction.next);
  }

  /// اختصار للتحديث (يُستدعى من الـ RefreshIndicator أو عند حدوث خطأ)
  Future<void> refreshCategories() async {
    await fetchCategories(action: PaginationAction.refresh);
  }

  /// Fetch subcategories for a given parent category
  Future<void> fetchSubcategories(CategoryEntity parentCategory) async {
    state = state.copyWith(
      selectedParentCategory: parentCategory,
      subcategoriesStatus: RequestStatus.loading,
      subcategoriesErrorMessage: null,
      subcategories: [],
    );

    final result = await _getSubcategoriesUseCase(parentCategory.id);

    result.fold(
          (failure) {
        state = state.copyWith(
          subcategoriesStatus: RequestStatus.error,
          subcategoriesErrorMessage: failure.message,
        );
      },
          (subcats) {
        state = state.copyWith(
          subcategoriesStatus: RequestStatus.success,
          subcategories: subcats,
        );
      },
    );
  }

  /// Helper to fetch specific categories by IDs
  Future<List<CategoryEntity>> fetchCategoriesByIds(List<String> ids) async {
    final result = await _getCategoriesByIdsUseCase(ids);
    return result.fold(
          (_) => [],
          (categories) => categories,
    );
  }

  /// Clear selected subcategory state when bottom sheet closes
  void clearSubcategories() {
    state = state.copyWith(
      subcategoriesStatus: RequestStatus.initial,
      subcategories: [],
      subcategoriesErrorMessage: null,
      selectedParentCategory: null,
    );
  }
}

// ================= Riverpod Providers =================

final categoryRemoteDataSourceProvider = Provider<CategoryRemoteDataSource>((ref) {
  return CategoryRemoteDataSourceImpl();
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final remoteDataSource = ref.watch(categoryRemoteDataSourceProvider);
  return CategoryRepositoryImpl(remoteDataSource: remoteDataSource);
});

final getMainCategoriesPaginatedUseCaseProvider =
Provider<GetMainCategoriesPaginatedUseCase>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return GetMainCategoriesPaginatedUseCase(repository);
});

final getSubcategoriesUseCaseProvider = Provider<GetSubcategoriesUseCase>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return GetSubcategoriesUseCase(repository);
});

final getCategoriesByIdsUseCaseProvider = Provider<GetCategoriesByIdsUseCase>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return GetCategoriesByIdsUseCase(repository);
});

final categoriesNotifierProvider =
StateNotifierProvider<CategoriesNotifier, CategoriesState>((ref) {
  final getPaginatedUseCase = ref.watch(getMainCategoriesPaginatedUseCaseProvider);
  final getSubcategoriesUseCase = ref.watch(getSubcategoriesUseCaseProvider);
  final getCategoriesByIdsUseCase = ref.watch(getCategoriesByIdsUseCaseProvider);

  return CategoriesNotifier(
    getPaginatedUseCase,
    getSubcategoriesUseCase,
    getCategoriesByIdsUseCase,
  );
});



