import 'package:flutter/material.dart';
import 'package:hive/art.dart';
import 'package:hive/culture.dart';
import 'package:hive/families.dart';
// ignore: unused_import
import 'package:hive/image_slider.dart';
import 'package:hive/login.dart';
import 'package:hive/other_activities.dart';
import 'package:hive/provider/member_list_provider.dart';
import 'package:hive/rovers.dart';
import 'package:hive/science.dart';
import 'package:hive/sports.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);

    // *Only bypass certificate verification in development environments*

    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;

    return client;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    ChangeNotifierProvider(
      create: (context) => MemberListProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginApp(),
      routes: {
        'sports': (context) => SportsPage(),
        'families': (context) => Families(),
        'culture': (context) => CulturePage(),
        'science': (context) => SciencePage(),
        'art': (context) => ArtsPage(),
        'rovers': (context) => RoversPage(),
        'otherActivities': (context) => OtherActivities(),
      },
    );
  }
}
