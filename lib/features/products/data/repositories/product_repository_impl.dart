import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/models/pagination_model.dart';
import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/get_products_params.dart';
import '../datasources/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  const ProductRepositoryImpl({required this.remoteDataSource});

  @override
  ResultFuture<PaginationModel<ProductEntity>> getProductsPaginated(
    GetProductsParams params,
  ) async {
    try {
      final paginatedModels = await remoteDataSource.getProductsPaginated(params);

      final entities =
          paginatedModels.items.map((model) => model.toEntity()).toList();

      final paginatedEntities = PaginationModel<ProductEntity>(
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
  ResultFuture<List<ProductEntity>> getProductsByIds(
    List<String> ids,
  ) async {
    try {
      final models = await remoteDataSource.getProductsByIds(ids);
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  ResultFuture<ProductEntity> getProductById(
    String id,
  ) async {
    try {
      final model = await remoteDataSource.getProductById(id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(e.toFailure());
    }
  }
}
