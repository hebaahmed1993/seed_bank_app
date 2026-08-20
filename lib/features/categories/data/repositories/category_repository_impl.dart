import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/models/pagination_model.dart';
import '../../../../core/params/pagination_params.dart';
import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_datasource.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  const CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  ResultFuture<PaginationModel<CategoryEntity>> getMainCategoriesPaginated(
      PaginationParams params,
      ) async {
    try {
      final paginatedModels = await remoteDataSource.getMainCategoriesPaginated(params);

      final entities = paginatedModels.items.map((model) => model.toEntity()).toList();

      final paginatedEntities = PaginationModel<CategoryEntity>(
        items: entities,
        firstDoc: paginatedModels.firstDoc,
        lastDoc: paginatedModels.lastDoc,
        hasMore: paginatedModels.hasMore,
        currentPage: paginatedModels.currentPage,
      );

      return Right(paginatedEntities);
    } catch (e) {
      return Left(e.toFailure());
    }
  }



  @override
  ResultFuture<List<CategoryEntity>> getSubcategories({
    required String parentId,
  }) async {
    try {
      final models = await remoteDataSource.getSubcategories(parentId: parentId);
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  ResultFuture<List<CategoryEntity>> getCategoriesByIds({
    required List<String> categoryIds,
  }) async {
    try {
      final models = await remoteDataSource.getCategoriesByIds(categoryIds: categoryIds);
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(e.toFailure());
    }
  }
}
