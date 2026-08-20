import '../../../../core/utils/typedefs.dart';
import '../../data/models/sign_in_request_model.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository _repository;

  const SignInUseCase(this._repository);

  ResultFuture<UserEntity> call(SignInRequestModel request) async {
    return await _repository.signIn(request);
  }
}
