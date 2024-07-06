import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive/data.dart';

class FamilyFileWidget extends StatefulWidget {
  final int familyId;
  final String fileType;

  FamilyFileWidget({required this.familyId, required this.fileType});

  @override
  _FamilyFileWidgetState createState() => _FamilyFileWidgetState();
}

class _FamilyFileWidgetState extends State<FamilyFileWidget> {
  Future<Uint8List?> _fetchFamilyFile() async {
    final response = await http.get(Uri.parse(
        '$url/api/FamilyEndPoint/GetFamilyFile/${widget.familyId}/${widget.fileType}'));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      print(
          "---------------------------------------------------failed to get family files");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _fetchFamilyFile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          return Image.memory(snapshot.data!);
        } else {
          return Center(child: Text('File not found'));
        }
      },
    );
  }
}
