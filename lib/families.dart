import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/data.dart';
import 'package:hive/families_form.dart';
import 'package:hive/family_data.dart';
import 'package:hive/token_manage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class Families extends StatefulWidget {
  const Families({super.key});

  @override
  State<Families> createState() => _FamiliesState();
}

class _FamiliesState extends State<Families> {
  late List<AddingFamilyDto> families;
  late Status familyStatus;
  final storage = new FlutterSecureStorage();
  Future<String?> _getToken() async {
    return await storage.read(key: 'access_token');
  }

  Future<bool> isTokenExpired(String token) async {
    return JwtDecoder.isExpired(token);
  }

  Future<bool> _isUserEnrolled() async {
    bool? isEnrolled;
    String? token = await _getToken();
    if (token == null) {
      return false;
    }

    if (await isTokenExpired(token)) {
      await refreshToken();
      token = await _getToken();
    }

    Map<String, dynamic> payload = JwtDecoder.decode(token!);
    String userId =
        payload['uid']; // Replace 'sub' with the correct key if different
    //located at services folder / TokenService / CreateJwtToken function
    final response = await http.get(
      Uri.parse('$url/api/FamilyEndPoint/myFamilies/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data != null && data.isNotEmpty) {
        // Assuming 'status' is a field in the returned data
        List<dynamic> familiesJson = data as List<dynamic>;
        List<AddingFamilyDto> families = familiesJson
            .map((json) =>
                AddingFamilyDto.fromJson(json as Map<String, dynamic>))
            .toList();
        print(families);
        // Assuming you want to check the status of the first family in the list

        return isEnrolled! == true;
      } else
        return isEnrolled! == false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Families committee'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body:
          //here i want to add if condition that checks if the user is enrolled in a family or not
          FutureBuilder<bool>(
        future: _isUserEnrolled(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data == true) {
            if (families.isNotEmpty) {
              AddingFamilyDto firstFamily = families.first;
              // Assuming the status you want to check is within the familyDto
              familyStatus = firstFamily.familyDto.status;
              _checkOnFamilyStatus(familyStatus);
            }

            return EnrolledPendingFamiliesWidget();
          } else {
            // The user is not enrolled in any family
            return NoFamiliesWidget();
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

Widget _checkOnFamilyStatus(Status familyStatus) {
  if (familyStatus == 0)
    return EnrolledAcceptedFamiliesWidget();
  else if (familyStatus == 1) {
    return EnrolledRejectedFamiliesWidget();
  } else
    return EnrolledPendingFamiliesWidget();
}

class EnrolledPendingFamiliesWidget extends StatefulWidget {
  const EnrolledPendingFamiliesWidget({super.key});

  @override
  State<EnrolledPendingFamiliesWidget> createState() =>
      _EnrolledPendingFamilyState();
}

class _EnrolledPendingFamilyState extends State<EnrolledPendingFamiliesWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(" Pending "));
  }
}

class EnrolledAcceptedFamiliesWidget extends StatefulWidget {
  const EnrolledAcceptedFamiliesWidget({super.key});

  @override
  State<EnrolledPendingFamiliesWidget> createState() =>
      _EnrolledPendingFamilyState();
}

class _EnrolledAcceptedFamilyState
    extends State<EnrolledPendingFamiliesWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(" Accepted "));
  }
}

class EnrolledRejectedFamiliesWidget extends StatefulWidget {
  const EnrolledRejectedFamiliesWidget({super.key});

  @override
  State<EnrolledPendingFamiliesWidget> createState() =>
      _EnrolledPendingFamilyState();
}

class _EnrolledRejectedFamilyState
    extends State<EnrolledRejectedFamiliesWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(" RejectedS "));
  }
}

class NoFamiliesWidget extends StatefulWidget {
  const NoFamiliesWidget({super.key});

  @override
  State<NoFamiliesWidget> createState() => _NoFamiliesWidgetState();
}

class _NoFamiliesWidgetState extends State<NoFamiliesWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(66, 57, 49, 81),
                blurRadius: 10,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'No families',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'You haven’t enrolled at any family, tap on the button to create now',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _showWarningDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 1, 52, 130),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Create family',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showWarningDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Important Notice'),
          content: Text(
              'You should download 3 files before going to the Families form.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Download files
                await _downloadFile('DeanApproval');
                await _downloadFile('HeadApproval');
                await _downloadFile('ViceHeadApproval');

                Navigator.of(context).pop();
                // Close the dialog
                Fluttertoast.showToast(
                  msg: "Files downloaded successfully",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FamiliesForm(),
                  ),
                );
              },
              child: Text('Proceed'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _downloadFile(String fileType) async {
    final url = 'https://10.0.2.2:7147/api/File/GetFamilyRulesFile/$fileType';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileType.pdf';
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      print('File downloaded to $filePath');
    } else {
      print('Failed to download file: ${response.reasonPhrase}');
    }
  }
}
