import 'package:flutter/material.dart';

class FamiliyInformation extends StatefulWidget {
  const FamiliyInformation({super.key});

  @override
  State<FamiliyInformation> createState() => _FamiliyInformationState();
}

class _FamiliyInformationState extends State<FamiliyInformation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Family Information"),
      ),
    );
  }
}
