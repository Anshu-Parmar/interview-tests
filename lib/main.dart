import 'dart:ui';

import 'package:challenges/presentation/product/product_screen.dart' show ProductScreen;
import 'package:challenges/service_locator.dart' show initializeDependencies;
import 'package:flutter/material.dart';

void main() async {
  await initializeDependencies();
  runApp(
    const MyApp()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Challenge',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      scrollBehavior: MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch,
          PointerDeviceKind.stylus, PointerDeviceKind.unknown},
      ),
      // home: TaskUi(),
      home: ProductScreen(),
    );
  }
}

