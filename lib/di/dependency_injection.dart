import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/storage/local_storage.dart';

/// Centralized Dependency Injection Setup via Riverpod Providers
final localStorageProvider = Provider<LocalStorage>((ref) {
  return MemoryLocalStorage();
});
