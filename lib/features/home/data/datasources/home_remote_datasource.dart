import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_paths.dart';
import '../../../../core/utils/firebase_safe_call.dart';
import '../models/home_section_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<HomeSectionModel>> getHomeSections();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final FirebaseFirestore? firestore;

  HomeRemoteDataSourceImpl({this.firestore});

  FirebaseFirestore get _firestore => firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<HomeSectionModel>> getHomeSections() {
    return firebaseSafeCall(
      operationName: 'HomeRemoteDataSource.getHomeSections',
      call: () async {
        final snapshot = await _firestore.collection(FirestorePaths.homeSections).get();

        return snapshot.docs
            .map((doc) => HomeSectionModel.fromJson(doc.data(), doc.id))
            .where((section) => section.isActive)
            .toList()
          ..sort((a, b) => a.order.compareTo(b.order));
      },
    );
  }
}