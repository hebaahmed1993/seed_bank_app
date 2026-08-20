import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_paths.dart';
import '../../../../core/utils/firebase_safe_call.dart';
import '../models/favorite_model.dart';

abstract class FavoritesRemoteDataSource {
  Future<List<FavoriteModel>> getFavorites(String userId);
  Future<void> addFavorite(FavoriteModel favorite);
  Future<void> removeFavorite({
    required String userId,
    required String productId,
  });
  Future<bool> isFavorite({
    required String userId,
    required String productId,
  });
}

class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  final FirebaseFirestore _firestore;

  FavoritesRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _favoritesCollection =>
      _firestore.collection(FirestorePaths.favorites);

  @override
  Future<List<FavoriteModel>> getFavorites(String userId) async {
    return firebaseSafeCall(
      operationName: 'getFavorites',
      call: () async {
        final querySnapshot = await _favoritesCollection
            .where('userId', isEqualTo: userId)
            .get();

        return querySnapshot.docs
            .map((doc) => FavoriteModel.fromJson(doc.data(), doc.id))
            .toList();
      },
    );
  }

  @override
  Future<void> addFavorite(FavoriteModel favorite) async {
    return firebaseSafeCall(
      operationName: 'addFavorite',
      call: () async {
        final docRef = favorite.id.isNotEmpty
            ? _favoritesCollection.doc(favorite.id)
            : _favoritesCollection.doc('${favorite.userId}_${favorite.productId}');

        await docRef.set(favorite.toDocumentJson());
      },
    );
  }

  @override
  Future<void> removeFavorite({
    required String userId,
    required String productId,
  }) async {
    return firebaseSafeCall(
      operationName: 'removeFavorite',
      call: () async {
        final docId = '${userId}_$productId';
        final docRef = _favoritesCollection.doc(docId);
        final docSnapshot = await docRef.get();

        if (docSnapshot.exists) {
          await docRef.delete();
        } else {
          // في حال لم يكن الـ ID مركب، ابحث عبر query واحذف
          final query = await _favoritesCollection
              .where('userId', isEqualTo: userId)
              .where('productId', isEqualTo: productId)
              .get();

          for (var doc in query.docs) {
            await doc.reference.delete();
          }
        }
      },
    );
  }

  @override
  Future<bool> isFavorite({
    required String userId,
    required String productId,
  }) async {
    return firebaseSafeCall(
      operationName: 'isFavorite',
      call: () async {
        final querySnapshot = await _favoritesCollection
            .where('userId', isEqualTo: userId)
            .where('productId', isEqualTo: productId)
            .limit(1)
            .get();

        return querySnapshot.docs.isNotEmpty;
      },
    );
  }
}
