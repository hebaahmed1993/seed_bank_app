import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; // مهم من أجل debugPrint
import '../../../../core/constants/firestore_paths.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/models/pagination_model.dart';
import '../../../../core/utils/firebase_safe_call.dart';
import '../../domain/usecases/get_products_params.dart';
import '../models/product_model.dart';
import 'product_remote_datasource.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final FirebaseFirestore? firestore;

  ProductRemoteDataSourceImpl({this.firestore});

  FirebaseFirestore get _firestore => firestore ?? FirebaseFirestore.instance;

  @override
  Future<PaginationModel<ProductModel>> getProductsPaginated(
      GetProductsParams params,
      ) async {
    return firebaseSafeCall(
      operationName: 'ProductRemoteDataSource.getProductsPaginated',
      call: () async {
        debugPrint('⏳ [فايربيس] بدء جلب المنتجات الديناميكية...');

        // 1. جلب كل المنتجات بدون أي شروط (استعلام خام لتفادي تعليق فايربيس)
        final snapshot = await _firestore.collection(FirestorePaths.products).get();

        debugPrint('📦 [فايربيس] تم الجلب! العدد الكلي: ${snapshot.docs.length}');

        // 2. الفلترة اليدوية (يجب أن تكون المنتجات نشطة)
        List<ProductModel> items = snapshot.docs
            .map((doc) => ProductModel.fromJson(doc.data(), doc.id))
            .where((product) => product.isActive)
            .toList();

        // 3. الترتيب الزمني محلياً (الأحدث أولاً)
        items.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        // 4. فلترة بالقسم إذا طلب ذلك
        if (params.categoryId != null && params.categoryId!.isNotEmpty) {
          items = items.where((p) => p.categoryId == params.categoryId).toList();
        }

        // 5. فلترة بالبحث إذا طلب ذلك
        final searchQuery = params.searchQuery;
        if (searchQuery != null && searchQuery.trim().isNotEmpty) {
          final queryText = searchQuery.trim().toLowerCase();
          items = items.where((p) => p.name.toLowerCase().contains(queryText)).toList();
        }

        // 6. تقليم القائمة لتطابق الحد المطلوب
        final limit = params.paginationParams.limit;
        final hasMore = items.length > limit;
        if(items.length > limit) {
          items = items.sublist(0, limit);
        }

        return PaginationModel<ProductModel>(
          items: items,
          firstDoc: snapshot.docs.isNotEmpty ? snapshot.docs.first : null,
          lastDoc: snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
          hasMore: hasMore,
        );
      },
    );
  }

  @override
  Future<List<ProductModel>> getProductsByIds(List<String> ids) async {
    return firebaseSafeCall(
      operationName: 'ProductRemoteDataSource.getProductsByIds',
      call: () async {
        if (ids.isEmpty) return <ProductModel>[];

        debugPrint('⏳ [فايربيس] محاولة جلب منتجات مخصصة بالمعرفات...');
        final List<ProductModel> products = [];
        const int chunkSize = 10;

        for (var i = 0; i < ids.length; i += chunkSize) {
          final chunk = ids.sublist(
            i,
            i + chunkSize > ids.length ? ids.length : i + chunkSize,
          );

          final snapshot = await _firestore
              .collection(FirestorePaths.products)
              .where(FieldPath.documentId, whereIn: chunk)
              .get();

          final chunkProducts = snapshot.docs
              .map((doc) => ProductModel.fromJson(doc.data(), doc.id))
              .where((product) => product.isActive) // التأكد أنها نشطة
              .toList();

          products.addAll(chunkProducts);
        }

        debugPrint('📦 [فايربيس] نجاح! تم جلب ${products.length} منتج مخصص.');
        return products;
      },
    );
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    return firebaseSafeCall(
      operationName: 'ProductRemoteDataSource.getProductById',
      call: () async {
        final doc = await _firestore
            .collection(FirestorePaths.products)
            .doc(id)
            .get();

        if (!doc.exists || doc.data() == null) {
          throw const ServerException(message: 'Product not found');
        }

        return ProductModel.fromJson(doc.data()!, doc.id);
      },
    );
  }
}