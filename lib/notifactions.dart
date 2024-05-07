import 'package:flutter/material.dart';
import 'package:hive/nav_bar.dart';

class notifcatons extends StatelessWidget {
  const notifcatons({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('not'),
      ),
      bottomNavigationBar: CustomBottomMenu(),
    );
  }
}
