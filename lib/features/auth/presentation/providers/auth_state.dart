import 'package:equatable/equatable.dart';

import '../../../../core/enums/app_enums.dart';
import '../../domain/entities/user_entity.dart';

class AuthState extends Equatable {
  final RequestStatus checkStatus;
  final RequestStatus signInStatus;
  final RequestStatus signUpStatus;
  final RequestStatus signOutStatus; // 👈 إضافة الحالة هنا
  final UserEntity? user;
  final String? errorMessage;

  const AuthState({
    this.checkStatus = RequestStatus.initial,
    this.signInStatus = RequestStatus.initial,
    this.signUpStatus = RequestStatus.initial,
    this.signOutStatus = RequestStatus.initial, // 👈 القيمة الافتراضية
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    RequestStatus? checkStatus,
    RequestStatus? signInStatus,
    RequestStatus? signUpStatus,
    RequestStatus? signOutStatus, // 👈 إضافتها هنا
    UserEntity? user,
    String? errorMessage,
    bool clearUser = false,
  }) {
    return AuthState(
      checkStatus: checkStatus ?? this.checkStatus,
      signInStatus: signInStatus ?? this.signInStatus,
      signUpStatus: signUpStatus ?? this.signUpStatus,
      signOutStatus: signOutStatus ?? this.signOutStatus, // 👈 تحديثها هنا
      user: clearUser ? null : (user ?? this.user),
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    checkStatus,
    signInStatus,
    signUpStatus,
    signOutStatus, // 👈 إضافتها لـ props
    user,
    errorMessage,
  ];
}