import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enums/app_enums.dart';
import '../../data/models/sign_in_request_model.dart';
import '../../data/models/sign_up_request_model.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthNotifier({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
    required this.getCurrentUserUseCase,
  }) : super(const AuthState()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    state = state.copyWith(checkStatus: RequestStatus.loading, errorMessage: null);

    final result = await getCurrentUserUseCase();

    result.fold(
          (failure) {
        state = state.copyWith(
          checkStatus: RequestStatus.error,
          clearUser: true,
          errorMessage: failure.message,
        );
      },
          (user) {
        state = state.copyWith(
          checkStatus: RequestStatus.success,
          user: user,
          clearUser: user == null,
        );
      },
    );
  }

  Future<void> signIn(SignInRequestModel request) async {
    state = state.copyWith(signInStatus: RequestStatus.loading, errorMessage: null);

    final result = await signInUseCase(request);

    result.fold(
          (failure) {
        state = state.copyWith(
          signInStatus: RequestStatus.error,
          errorMessage: failure.message,
        );
      },
          (user) {
        state = state.copyWith(
          signInStatus: RequestStatus.success,
          user: user,
        );
      },
    );
  }

  Future<void> signUp(SignUpRequestModel request) async {
    state = state.copyWith(signUpStatus: RequestStatus.loading, errorMessage: null);

    final result = await signUpUseCase(request);

    result.fold(
          (failure) {
        state = state.copyWith(
          signUpStatus: RequestStatus.error,
          errorMessage: failure.message,
        );
      },
          (_) {
        state = state.copyWith(
          signUpStatus: RequestStatus.success,
        );
      },
    );
  }

  Future<void> signOut() async {
    state = state.copyWith(signOutStatus: RequestStatus.loading, errorMessage: null);

    final result = await signOutUseCase();

    result.fold(
          (failure) {
        state = state.copyWith(
          signOutStatus: RequestStatus.error,
          errorMessage: failure.message,
        );
      },
          (_) {
        state = state.copyWith(
          signOutStatus: RequestStatus.success,
          checkStatus: RequestStatus.initial,
          signInStatus: RequestStatus.initial,
          signUpStatus: RequestStatus.initial,
          clearUser: true,
        );
      },
    );
  }}