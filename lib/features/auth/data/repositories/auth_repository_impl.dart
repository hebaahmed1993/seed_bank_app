import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/sign_in_request_model.dart';
import '../models/sign_up_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepositoryImpl({required this.remoteDataSource});

  @override
  ResultFuture<UserEntity> signIn(SignInRequestModel request) async {
    try {
      final userModel = await remoteDataSource.signIn(request);
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  ResultFuture<void> signUp(SignUpRequestModel request) async {
    try {
      await remoteDataSource.signUp(request);

      return const Right(null);
    } catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  ResultFuture<void> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  ResultFuture<UserEntity?> getCurrentUser() async {
    try {
      final userModel = await remoteDataSource.getCurrentUser();
      return Right(userModel?.toEntity());
    } catch (e) {
      return Left(e.toFailure());
    }
  }
}
