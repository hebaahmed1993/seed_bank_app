import '../models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getProfile();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  @override
  Future<UserProfileModel> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const UserProfileModel(
      id: 'usr_101',
      name: 'عبدالله الأحمد',
      email: 'abdallah@example.com',
      phone: '+966 50 123 4567',
      avatarUrl: '',
    );
  }
}
