import 'dart:io';

import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:hive/activites.dart';
// ignore: unused_import
import 'package:hive/home_page.dart';
// ignore: unused_import
import 'package:hive/image_slider.dart';
// ignore: unused_import
import 'package:hive/login.dart';
// ignore: unused_import
// ignore: unused_import
import 'package:hive/search.dart';
// ignore: unused_import
import 'package:hive/sign_in.dart';
// ignore: unused_import
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
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
