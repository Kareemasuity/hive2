import 'dart:io';

import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:hive/activites.dart';
import 'package:hive/art.dart';
import 'package:hive/culture.dart';
import 'package:hive/families.dart';
// ignore: unused_import
import 'package:hive/image_slider.dart';
// ignore: unused_import
import 'package:hive/login.dart';
import 'package:hive/other_activities.dart';
import 'package:hive/provider/familySupervisors_list_provider.dart';
import 'package:hive/provider/familyplan_list_provider.dart';
import 'package:hive/provider/member_list_provider.dart';
import 'package:hive/rovers.dart';
import 'package:hive/science.dart';
// ignore: unused_import
import 'package:hive/search.dart';
// ignore: unused_import
import 'package:hive/sign_in.dart';
// ignore: unused_import
import 'package:hive/sign_up.dart';
import 'package:hive/sports.dart';
import 'package:provider/provider.dart';

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

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => MemberListProvider()),
      ChangeNotifierProvider(create: (context) => FamilyPlanListProvider()),
      ChangeNotifierProvider(
          create: (context) => FamilySupervisorListProvider()),
    ],
    child: MyApp(),
  ));
  WidgetsFlutterBinding.ensureInitialized();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
          //SportsPage(),
          //Families(),
          SignUpPage(),
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
