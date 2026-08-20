import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'app/app_initializer.dart';

void main() async {
  await AppInitializer.init();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
