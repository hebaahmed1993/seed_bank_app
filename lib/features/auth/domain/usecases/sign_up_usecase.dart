import '../../../../core/utils/typedefs.dart';
import '../../data/models/sign_up_request_model.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository _repository;

  const SignUpUseCase(this._repository);

  ResultFuture<void> call(SignUpRequestModel request) async {
    return await _repository.signUp(request);
  }
}