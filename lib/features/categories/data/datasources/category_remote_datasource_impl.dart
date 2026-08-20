import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_paths.dart';
import '../../../../core/enums/pagination_action.dart';
import '../../../../core/models/pagination_model.dart';
import '../../../../core/params/pagination_params.dart';
import '../../../../core/utils/firebase_safe_call.dart';
import '../models/category_model.dart';
import 'category_remote_datasource.dart';

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final FirebaseFirestore? firestore;

  CategoryRemoteDataSourceImpl({this.firestore});

  FirebaseFirestore get _firestore => firestore ?? FirebaseFirestore.instance;

  @override
  Future<PaginationModel<CategoryModel>> getMainCategoriesPaginated(
      PaginationParams params,
      ) async {
    return firebaseSafeCall(
      operationName: 'CategoryRemoteDataSource.getMainCategoriesPaginated',
      call: () async {
        Query<Map<String, dynamic>> query = _firestore
            .collection(FirestorePaths.categories)
            .where('isActive', isEqualTo: true)
            .orderBy('sortOrder');

        // 🎯 تطبيق الهيكلية الموحدة للاتجاهات
        switch (params.action) {
          case PaginationAction.next:
            if (params.lastDoc != null) {
              query = query.startAfterDocument(params.lastDoc!);
            }
            break;
          case PaginationAction.previous:
            if (params.firstDoc != null) {
              query = query.endBeforeDocument(params.firstDoc!);
            }
            break;
          case PaginationAction.refresh:
            break;
        }

        query = query.limit(params.limit);

        final snapshot = await query.get();

        final items = snapshot.docs
            .map((doc) => CategoryModel.fromJson(doc.data(), doc.id))
            .where((category) => category.parentId == null || category.parentId!.isEmpty)
            .toList();

        final hasMore = snapshot.docs.length >= params.limit;
        final newFirstDoc = snapshot.docs.isNotEmpty ? snapshot.docs.first : null;
        final newLastDoc = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

        return PaginationModel<CategoryModel>(
          items: items,
          firstDoc: newFirstDoc,
          lastDoc: newLastDoc,
          hasMore: hasMore,
        );
      },
    );
  }

  @override
  Future<List<CategoryModel>> getSubcategories({
    required String parentId,
  }) async {
    return firebaseSafeCall(
      operationName: 'CategoryRemoteDataSource.getSubcategories',
      call: () async {
        final snapshot = await _firestore
            .collection(FirestorePaths.categories)
            .where('parentId', isEqualTo: parentId)
            .where('isActive', isEqualTo: true)
            .get();

        final items = snapshot.docs
            .map((doc) => CategoryModel.fromJson(doc.data(), doc.id))
            .toList()
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

        return items;
      },
    );
  }

  @override
  Future<List<CategoryModel>> getCategoriesByIds({
    required List<String> categoryIds,
  }) async {
    return firebaseSafeCall(
      operationName: 'CategoryRemoteDataSource.getCategoriesByIds',
      call: () async {
        if (categoryIds.isEmpty) return <CategoryModel>[];

        final List<CategoryModel> categories = [];
        const int chunkSize = 10;

        for (var i = 0; i < categoryIds.length; i += chunkSize) {
          final chunk = categoryIds.sublist(
            i,
            i + chunkSize > categoryIds.length ? categoryIds.length : i + chunkSize,
          );

          final snapshot = await _firestore
              .collection(FirestorePaths.categories)
              .where(FieldPath.documentId, whereIn: chunk)
              .get();

          final chunkCategories = snapshot.docs
              .map((doc) => CategoryModel.fromJson(doc.data(), doc.id))
              .toList();

          categories.addAll(chunkCategories);
        }

        return categories;
      },
    );
  }
}