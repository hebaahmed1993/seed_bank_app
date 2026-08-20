import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_paths.dart';
import '../../../../core/utils/firebase_safe_call.dart';
import '../models/city_model.dart';
import '../models/region_model.dart';
import 'location_remote_datasource.dart';

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  final FirebaseFirestore? firestore;

  LocationRemoteDataSourceImpl({this.firestore});

  FirebaseFirestore get _firestore => firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<CityModel>> getCities() async {
    return firebaseSafeCall(
      operationName: 'LocationRemoteDataSource.getCities',
      call: () async {
        final snapshot = await _firestore
            .collection(FirestorePaths.cities)
            .where('isActive', isEqualTo: true)
            .get();

        return snapshot.docs
            .map((doc) => CityModel.fromJson(doc.data(), doc.id))
            .toList();
      },
    );
  }

  @override
  Future<List<RegionModel>> getRegionsByCity(String cityId) async {
    return firebaseSafeCall(
      operationName: 'LocationRemoteDataSource.getRegionsByCity',
      call: () async {
        if (cityId.isEmpty) return <RegionModel>[];

        final snapshot = await _firestore
            .collection(FirestorePaths.regions)
            .where('cityId', isEqualTo: cityId)
            .where('isAvailable', isEqualTo: true)
            .get();

        return snapshot.docs
            .map((doc) => RegionModel.fromJson(doc.data(), doc.id))
            .toList();
      },
    );
  }
}
