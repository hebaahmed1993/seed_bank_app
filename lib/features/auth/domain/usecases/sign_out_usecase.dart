import '../../../../core/utils/typedefs.dart';
import '../repositories/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository _repository;

  const SignOutUseCase(this._repository);

  ResultFuture<void> call() async {
    return await _repository.signOut();
  }
}
