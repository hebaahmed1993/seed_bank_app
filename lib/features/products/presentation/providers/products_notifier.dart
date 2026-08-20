import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enums/app_enums.dart';
import '../../../../core/enums/pagination_action.dart';
import '../../../../core/models/pagination_model.dart';
import '../../../../core/params/pagination_params.dart';
import '../../data/datasources/product_remote_datasource.dart';
import '../../data/datasources/product_remote_datasource_impl.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/get_product_by_id_usecase.dart';
import '../../domain/usecases/get_products_by_ids_usecase.dart';
import '../../domain/usecases/get_products_paginated_usecase.dart';
import '../../domain/usecases/get_products_params.dart';
import 'products_state.dart';

class ProductsNotifier extends StateNotifier<ProductsState> {
  final GetProductsPaginatedUseCase getProductsPaginatedUseCase;
  final GetProductsByIdsUseCase getProductsByIdsUseCase;
  final GetProductByIdUseCase getProductByIdUseCase;

  Timer? _debounce;

  ProductsNotifier({
    required this.getProductsPaginatedUseCase,
    required this.getProductsByIdsUseCase,
    required this.getProductByIdUseCase,
  }) : super(const ProductsState()) {
    fetchProducts();
  }

  Future<void> fetchProducts({
    PaginationAction action = PaginationAction.refresh,
  }) async {
    if (state.fetchStatus == RequestStatus.loading) return;

    if (action == PaginationAction.next && !state.pagination.hasMore) return;

    final isRefresh = action == PaginationAction.refresh;

    state = state.copyWith(
      fetchStatus: RequestStatus.loading,
      pagination: isRefresh
          ? const PaginationModel(items: [], hasMore: true)
          : state.pagination,
      errorMessage: null,
    );

    final params = GetProductsParams(
      paginationParams: PaginationParams(
        limit: 10,
        action: action,
        firstDoc: isRefresh ? null : state.pagination.firstDoc,
        lastDoc: isRefresh ? null : state.pagination.lastDoc,
      ),
      categoryId: state.selectedCategoryId,
      searchQuery: state.searchQuery,
    );

    final result = await getProductsPaginatedUseCase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          fetchStatus: RequestStatus.error,
          errorMessage: failure.message,
        );
      },
      (newPagination) {
        if (action == PaginationAction.next) {
          final mergedItems = [
            ...state.pagination.items,
            ...newPagination.items,
          ];

          final updatedPagination = PaginationModel<ProductEntity>(
            items: mergedItems,
            firstDoc: state.pagination.firstDoc ?? newPagination.firstDoc,
            lastDoc: newPagination.lastDoc ?? state.pagination.lastDoc,
            hasMore: newPagination.hasMore,
            currentPage: state.pagination.currentPage + 1,
          );

          state = state.copyWith(
            fetchStatus: RequestStatus.success,
            pagination: updatedPagination,
          );
        } else {
          state = state.copyWith(
            fetchStatus: RequestStatus.success,
            pagination: newPagination,
          );
        }
      },
    );
  }

  void onSearchChanged(String query) {
    _debounce?.cancel();
    state = state.copyWith(searchQuery: query);

    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchProducts(action: PaginationAction.refresh);
    });
  }

  void onCategoryChanged(String? categoryId) {
    if (categoryId == null || categoryId.isEmpty) {
      state = state.copyWith(
        selectedCategoryId: null,
        clearSelectedCategory: true,
      );
    } else {
      state = state.copyWith(selectedCategoryId: categoryId);
    }
    fetchProducts(action: PaginationAction.refresh);
  }

  Future<void> fetchMoreProducts() async {
    await fetchProducts(action: PaginationAction.next);
  }

  Future<void> refreshProducts() async {
    await fetchProducts(action: PaginationAction.refresh);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

// ==========================================
// 🎯 Dependency Injection & Riverpod Providers
// ==========================================

final productRemoteDataSourceProvider =
    Provider<ProductRemoteDataSource>((ref) {
  return ProductRemoteDataSourceImpl();
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final remoteDataSource = ref.watch(productRemoteDataSourceProvider);
  return ProductRepositoryImpl(remoteDataSource: remoteDataSource);
});

final getProductsPaginatedUseCaseProvider =
    Provider<GetProductsPaginatedUseCase>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return GetProductsPaginatedUseCase(repository);
});

final getProductsByIdsUseCaseProvider =
    Provider<GetProductsByIdsUseCase>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return GetProductsByIdsUseCase(repository);
});

final getProductByIdUseCaseProvider = Provider<GetProductByIdUseCase>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return GetProductByIdUseCase(repository);
});

final productsNotifierProvider =
    StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  return ProductsNotifier(
    getProductsPaginatedUseCase:
        ref.watch(getProductsPaginatedUseCaseProvider),
    getProductsByIdsUseCase: ref.watch(getProductsByIdsUseCaseProvider),
    getProductByIdUseCase: ref.watch(getProductByIdUseCaseProvider),
  );
});
