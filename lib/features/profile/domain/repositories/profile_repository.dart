import '../../../../core/utils/typedefs.dart';
import '../entities/user_profile_entity.dart';

abstract class ProfileRepository {
  ResultFuture<UserProfileEntity> getProfile();
}
