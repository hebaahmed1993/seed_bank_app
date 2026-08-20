import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/params/no_params.dart';
import '../../data/datasources/home_remote_datasource.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/usecases/get_home_sections_usecase.dart';
import 'home_state.dart';

class HomeNotifier extends StateNotifier<HomeState> {
  final GetHomeSectionsUseCase _getHomeSectionsUseCase;

  HomeNotifier(this._getHomeSectionsUseCase) : super(const HomeState()) {
    getHomeSections();
  }

  Future<void> getHomeSections() async {
    state = state.copyWith(
      fetchStatus: RequestStatus.loading,
      errorMessage: null,
    );

    final result = await _getHomeSectionsUseCase(const NoParams());

    result.fold(
          (failure) {
        state = state.copyWith(
          fetchStatus: RequestStatus.error,
          errorMessage: failure.message,
        );
      },
          (sections) {
        state = state.copyWith(
          fetchStatus: RequestStatus.success,
          sections: sections,
        );
      },
    );
  }
}

// ================= Providers =================
final homeRemoteDataSourceProvider = Provider<HomeRemoteDataSource>((ref) {
  return HomeRemoteDataSourceImpl();
});

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final remoteDataSource = ref.watch(homeRemoteDataSourceProvider);
  return HomeRepositoryImpl(remoteDataSource: remoteDataSource);
});

final getHomeSectionsUseCaseProvider = Provider<GetHomeSectionsUseCase>((ref) {
  final repository = ref.watch(homeRepositoryProvider);
  return GetHomeSectionsUseCase(repository);
});

final homeNotifierProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  final getSectionsUseCase = ref.watch(getHomeSectionsUseCaseProvider);
  return HomeNotifier(getSectionsUseCase);
});