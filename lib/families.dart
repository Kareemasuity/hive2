import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/data.dart';
import 'package:hive/families_form.dart';
import 'package:hive/family_data.dart';
import 'package:hive/myFamily_response_data.dart';
import 'package:hive/widgets/accepted_family_widget.dart';
import 'package:hive/widgets/pending_family_widget.dart';
import 'package:hive/widgets/rejected_family_widget.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class Families extends StatefulWidget {
  const Families({super.key});

  @override
  State<Families> createState() => _FamiliesState();
}

class _FamiliesState extends State<Families> {
  late FamilyResponseDto family;
  late Status familyStatus;
  final storage = new FlutterSecureStorage();
  bool _shouldNavigate = true;

  late Role userRole;

  Future<String?> _getToken() async {
    return await storage.read(key: 'access_token');
  }

  Future<bool> isTokenExpired(String token) async {
    return JwtDecoder.isExpired(token);
  }

  Future<void> refreshToken() async {
    // Implement your token refresh logic here
  }

  Future<bool> _isUserEnrolled() async {
    String? token = await _getToken();
    if (token == null) {
      return false;
    }

    if (await isTokenExpired(token)) {
      await refreshToken();
      token = await _getToken();
    }

    Map<String, dynamic> payload = JwtDecoder.decode(token!);
    String userId = payload['uid'];

    final response = await http.get(
      Uri.parse('$url/api/FamilyEndPoint/myFamilies/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data != null && data.isNotEmpty) {
        // Assuming the API returns a list of families, and we are interested in the first family
        var firstFamilyJson = data[0] as Map<String, dynamic>;
        var familyResponse = FamilyResponseDto.fromJson(firstFamilyJson);
        // Since FamilyDto handles file initialization internally, we don't need to call it separately here

        family = familyResponse;

        return true;
      } else {
        return false;
      }
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
      body: FutureBuilder<bool>(
        future: _isUserEnrolled(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(
                "-----------------------------------------------myFamily function has error");
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data == true) {
            print(
                "-----------------------------------------------myFamily function called");
            familyStatus =
                family.familyDto.status; // Ensure familyStatus is correctly set
            userRole = family.familyEnrollmentDto.role;
            print(
                "---------------------------------------------------$familyStatus");
            // Call fetchFamilyDetails after the UI build phase is complete
            if (_shouldNavigate) {
              _shouldNavigate = false; // Prevent re-triggering navigation
              WidgetsBinding.instance.addPostFrameCallback((_) {
                fetchFamilyDetails(
                    familyStatus, family.familyDto.familyId, context, userRole);
              });
            }
            if (familyStatus == Status.Accepted) {
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
                          'You have enrolled at a family, tap on the button to check your activities and enrollements now',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EnrolledAcceptedFamiliesWidget(
                                        familyId: family.familyDto.familyId),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 1, 52, 130),
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Show Family information',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (familyStatus == Status.Pending) {
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
                          'You have family is pending',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EnrolledPendingFamiliesWidget(
                                        familyId: family.familyDto.familyId),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 1, 52, 130),
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Show Family information',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else
              return _buildNoFamiliesWidget();
          } else {
            // Calling a method that returns a widget
            return _buildNoFamiliesWidget();
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

Widget _buildFamilyPage(int familyId, Status familyStatus) {
  switch (familyStatus) {
    case Status.Accepted:
      return EnrolledAcceptedFamiliesWidget(familyId: familyId);
    case Status.Rejected:
      return EnrolledRejectedFamiliesWidget(familyId: familyId);
    case Status.Pending:
      return EnrolledPendingFamiliesWidget(familyId: familyId);
    default:
      return Container(); // Handle any other status or fallback
  }
}

Widget _buildNoFamiliesWidget() {
  return NoFamiliesWidget();
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

Future<void> fetchFamilyDetails(Status familyStatus, int familyId,
    BuildContext context, Role userRole) async {
  try {
    if (familyStatus == Status.Accepted) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              EnrolledAcceptedFamiliesWidget(familyId: familyId),
        ),
      );
    } else if (familyStatus == Status.Rejected &&
        userRole == Role.FAMILY_COORDINATOR) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              EnrolledRejectedFamiliesWidget(familyId: familyId),
        ),
      );
    } else if (familyStatus == Status.Pending &&
        userRole == Role.FAMILY_COORDINATOR) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              EnrolledPendingFamiliesWidget(familyId: familyId),
        ),
      );
    } else {
      return;
    }
  } catch (e) {
    print("Error fetching family details: $e");
  }
}
