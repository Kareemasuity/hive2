import 'dart:io';

import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:hive/activites.dart';
// ignore: unused_import
import 'package:hive/image_slider.dart';
// ignore: unused_import
import 'package:hive/login.dart';
import 'package:hive/search.dart';
import 'package:hive/sign_up.dart';

// ignore: unused_import
import 'create_activity.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);

    // **Only bypass certificate verification in development environments**

    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;

    return client;
  }
}

void main() {
  // Set HttpOverrides for development environments
  HttpOverrides.global = MyHttpOverrides();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUpScreen(),
    );
  }
}
