

class SignInRequestModel {
  final String phone;
  final String password;

  SignInRequestModel({
    required this.phone,
    required this.password,
  });


  String get firebaseEmail => '$phone@seedbank.ly';
}