import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class AppInitializer {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
    );
  }
}