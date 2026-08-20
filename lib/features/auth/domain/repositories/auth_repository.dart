import '../../../../core/utils/typedefs.dart';
import '../../data/models/sign_in_request_model.dart';
import '../../data/models/sign_up_request_model.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  ResultFuture<UserEntity> signIn(SignInRequestModel request);

  ResultFuture<void> signUp(SignUpRequestModel request);
  ResultFuture<void> signOut();

  ResultFuture<UserEntity?> getCurrentUser();
}
