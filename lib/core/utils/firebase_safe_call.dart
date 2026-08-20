import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../errors/exceptions.dart';

Future<T> firebaseSafeCall<T>({
  required Future<T> Function() call,
  String? operationName,
}) async {
  final tag = operationName != null ? '[$operationName]' : '[Firebase Operation]';
  try {
    final result = await call();
    debugPrint('✅ $tag Completed successfully.');
    return result;
  } on FirebaseException catch (e) {
    debugPrint('🔥❌ $tag [FirebaseException] Code: ${e.code} | Message: ${e.message}');
    throw ServerException(message: e.code);
  } catch (e, stackTrace) {
    debugPrint('💥❌ $tag [Internal/Parsing Error] ${e.toString()}');
    debugPrint('📍 $tag StackTrace:\n$stackTrace');
    throw ServerException(message: e.toString());
  }
}