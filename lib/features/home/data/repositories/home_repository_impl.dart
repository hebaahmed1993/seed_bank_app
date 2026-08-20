import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/home_section_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  const HomeRepositoryImpl({required this.remoteDataSource});

  @override
  ResultFuture<List<HomeSectionEntity>> getHomeSections() async {
    try {
      final sectionModels = await remoteDataSource.getHomeSections();
      return Right(sectionModels.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(e.toFailure());
    }
  }
}