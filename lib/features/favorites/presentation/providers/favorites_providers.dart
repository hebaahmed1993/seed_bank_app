import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/favorites_remote_datasource.dart';
import '../../data/repositories/favorites_repository_impl.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../domain/usecases/add_favorite_usecase.dart';
import '../../domain/usecases/get_favorites_usecase.dart';
import '../../domain/usecases/remove_favorite_usecase.dart';
import 'favorites_notifier.dart';
import 'favorites_state.dart';

final favoritesRemoteDataSourceProvider = Provider<FavoritesRemoteDataSource>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return FavoritesRemoteDataSourceImpl(firestore: firestore);
});

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  final remoteDataSource = ref.watch(favoritesRemoteDataSourceProvider);
  return FavoritesRepositoryImpl(remoteDataSource: remoteDataSource);
});

final getFavoritesUseCaseProvider = Provider<GetFavoritesUseCase>((ref) {
  final repository = ref.watch(favoritesRepositoryProvider);
  return GetFavoritesUseCase(repository);
});

final addFavoriteUseCaseProvider = Provider<AddFavoriteUseCase>((ref) {
  final repository = ref.watch(favoritesRepositoryProvider);
  return AddFavoriteUseCase(repository);
});

final removeFavoriteUseCaseProvider = Provider<RemoveFavoriteUseCase>((ref) {
  final repository = ref.watch(favoritesRepositoryProvider);
  return RemoveFavoriteUseCase(repository);
});

final favoritesNotifierProvider =
    StateNotifierProvider<FavoritesNotifier, FavoritesState>((ref) {
  final getFavoritesUseCase = ref.watch(getFavoritesUseCaseProvider);
  final addFavoriteUseCase = ref.watch(addFavoriteUseCaseProvider);
  final removeFavoriteUseCase = ref.watch(removeFavoriteUseCaseProvider);

  final notifier = FavoritesNotifier(
    getFavoritesUseCase,
    addFavoriteUseCase,
    removeFavoriteUseCase,
  );

  // جلب المفضلة تلقائياً إذا كان المستخدم مسجلاً
  final currentUserId = ref.watch(firebaseAuthProvider).currentUser?.uid;
  if (currentUserId != null && currentUserId.isNotEmpty) {
    notifier.fetchFavorites(currentUserId);
  }

  return notifier;
});
