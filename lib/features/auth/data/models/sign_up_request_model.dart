class SignUpRequestModel {
  final String name;
  final String email;
  final String password;
  final String phone;
  final String cityId;
  final String cityName;

  final String accountTypeId;
  final bool isBlocked;

  SignUpRequestModel({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.cityId,
    required this.cityName,
    this.accountTypeId = 'user',
    this.isBlocked = false,
  });

  // تكوين الإيميل الوهمي للمصادقة
  String get firebaseEmail => '${phone.trim()}@seedbank.ly';

  // تحويل البيانات لرفعها إلى Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'cityId': cityId,
      'cityName': cityName,
      'accountTypeId': accountTypeId,
      'isBlocked': isBlocked,
    };
  }
}