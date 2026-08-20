import '../../../../core/params/no_params.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/user_profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  const GetProfileUseCase(this.repository);

  ResultFuture<UserProfileEntity> call(NoParams params) {
    return repository.getProfile();
  }
}
