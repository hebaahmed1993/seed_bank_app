import '../models/sign_in_request_model.dart';
import '../models/sign_up_request_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn(SignInRequestModel request);

  Future<void> signUp(SignUpRequestModel request) ;

  Future<void> signOut();

  Future<UserModel?> getCurrentUser();
}
