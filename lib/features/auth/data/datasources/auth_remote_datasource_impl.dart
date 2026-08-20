import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/constants/firestore_paths.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/firebase_safe_call.dart';
import '../models/sign_in_request_model.dart';
import '../models/sign_up_request_model.dart';
import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth? firebaseAuth;
  final FirebaseFirestore? firestore;

  AuthRemoteDataSourceImpl({
    this.firebaseAuth,
    this.firestore,
  });

  FirebaseAuth get _firebaseAuth => firebaseAuth ?? FirebaseAuth.instance;
  FirebaseFirestore get _firestore => firestore ?? FirebaseFirestore.instance;

  @override
  Future<UserModel> signIn(SignInRequestModel request) async {
    return firebaseSafeCall(
      operationName: 'AuthRemoteDataSource.signIn',
      call: () async {
        // 🎯 التعديل هنا: استخدام firebaseEmail بدلاً من phone
        final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: request.firebaseEmail,
          password: request.password,
        );

        final user = credential.user;
        if (user == null) {
          throw const ServerException(message: 'User authentication failed.');
        }

        final doc = await _firestore.collection(FirestorePaths.users).doc(user.uid).get();

        if (!doc.exists || doc.data() == null) {
          throw const ServerException(message: 'User profile not found.');
        }

        return UserModel.fromJson(doc.data()!, doc.id);
      },
    );
  }

  @override
  Future<void> signUp(SignUpRequestModel request) async {
    return firebaseSafeCall(
      operationName: 'AuthRemoteDataSource.signUp',
      call: () async {
        final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: request.firebaseEmail,
          password: request.password,
        );

        final user = credential.user;
        if (user == null) {
          throw const ServerException(message: 'Failed to create user account.');
        }

        // 2. الإيميل الحقيقي ورقم الهاتف سيتم حفظهما هنا في Firestore
        final userData = request.toFirestore();
        userData['createdAt'] = FieldValue.serverTimestamp();

        // 3. حفظ البيانات في جدول users
        await _firestore
            .collection(FirestorePaths.users)
            .doc(user.uid)
            .set(userData);

        // 4. تسجيل الخروج فوراً لمنع الدخول التلقائي
        await _firebaseAuth.signOut();
      },
    );
  }

  @override
  Future<void> signOut() async {
    return firebaseSafeCall(
      operationName: 'AuthRemoteDataSource.signOut',
      call: () async {
        await _firebaseAuth.signOut();
      },
    );
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    return firebaseSafeCall(
      operationName: 'AuthRemoteDataSource.getCurrentUser',
      call: () async {
        final firebaseUser = _firebaseAuth.currentUser;
        if (firebaseUser == null) return null;

        final doc = await _firestore
            .collection(FirestorePaths.users)
            .doc(firebaseUser.uid)
            .get();

        if (!doc.exists || doc.data() == null) return null;

        return UserModel.fromJson(doc.data()!, doc.id);
      },
    );
  }
}