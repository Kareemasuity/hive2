import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/Data_Models/GetEntityActivitiesForFamilies_data.dart';

import 'package:hive/data.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class FamilyActivities extends StatefulWidget {
  final int familyId;
  const FamilyActivities({Key? key, required this.familyId}) : super(key: key);

  @override
  State<FamilyActivities> createState() => _FamilyActivitiesState();
}

class _FamilyActivitiesState extends State<FamilyActivities> {
  late Future<List<EntityActivitiesForFamilies>> futureEntityActivities;
  final storage = FlutterSecureStorage();
  List<Committy> committees = [];
  Committy? selectedCommittee;
  Future<String?> _getToken() async {
    return await storage.read(key: 'access_token');
  }

  Future<bool> isTokenExpired(String token) async {
    return JwtDecoder.isExpired(token);
  }

  Future<void> refreshToken() async {
    // Implement your token refresh logic here
  }

  Future<int> _getUnEntityIdFromToken() async {
    String? token = await _getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    if (await isTokenExpired(token)) {
      await refreshToken();
      token = await _getToken();
    }

    Map<String, dynamic> payload = JwtDecoder.decode(token!);
    return int.parse(payload['unEntity']);
  }

  Future<List<EntityActivitiesForFamilies>> getEntityActivitiesForFamilies(
      int familyId) async {
    int unEntityId = await _getUnEntityIdFromToken();
    final String apiUrl =
        '$url/api/CommitteeEntityActivity/GetEntityActivitiesForFamilies/$unEntityId/$familyId';
    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Authorization': 'Bearer ${await _getToken()}',
    });

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<EntityActivitiesForFamilies> entityActivities = body
          .map((dynamic item) => EntityActivitiesForFamilies.fromJson(item))
          .toList();
      print(
          "-------------------------------------------------------GetEntityActivitiesForFamilies called");
      return entityActivities;
    } else {
      throw Exception('Failed to load entity activities');
    }
  }

  Future<void> _fetchCommittees() async {
    // Fetch committees from the API
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$url/api/Committee/GetAllCommittees'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      setState(() {
        committees =
            body.map((dynamic item) => Committy.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load committees');
    }
  }

  Future<List<EntityActivitiesForFamilies>>
      getFilteredEntityActivitiesForFamilies(
          int familyId, int committeeId) async {
    List<EntityActivitiesForFamilies> allActivities =
        await getEntityActivitiesForFamilies(familyId);
    List<EntityActivitiesForFamilies> filteredActivities = allActivities
        .where((activity) => activity.committy?.committeeId == committeeId)
        .toList();
    return filteredActivities;
  }

  @override
  void initState() {
    super.initState();
    _fetchCommittees();
    futureEntityActivities = getEntityActivitiesForFamilies(widget.familyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Available Activities",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w700,
            height: 0.03,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 1, 52, 130),
      ),
      body: Column(
        children: [
          DropdownButton<Committy>(
            hint: Text("Select a Committee"),
            value: selectedCommittee,
            onChanged: (Committy? newValue) {
              setState(() {
                selectedCommittee = newValue;
                if (selectedCommittee != null) {
                  futureEntityActivities =
                      getFilteredEntityActivitiesForFamilies(
                          widget.familyId, selectedCommittee!.committeeId!);
                } else {
                  futureEntityActivities =
                      getEntityActivitiesForFamilies(widget.familyId);
                }
              });
            },
            items: committees.map((Committy committee) {
              return DropdownMenuItem<Committy>(
                value: committee,
                child: Text(committee.englishName!),
              );
            }).toList(),
          ),
          Expanded(
            child: FutureBuilder<List<EntityActivitiesForFamilies>>(
              future: futureEntityActivities,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No activities found.'));
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: snapshot.data!.map((activity) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(
                                    20.0), // Adjust the radius to your preference
                                topLeft: Radius.circular(5.0),
                                bottomRight: Radius.circular(5.0),
                                bottomLeft: Radius.circular(20.0),
                              ),
                              child: Container(
                                child: ListTile(
                                  title: Text(
                                    activity.activity?.englishName ?? 'No name',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontWeight: FontWeight.w700,
                                      height: 1.2,
                                    ),
                                  ),
                                  subtitle: Text(
                                    activity.activity?.englishDescription ??
                                        'No description',
                                    style: TextStyle(
                                      color: Colors.white
                                          .withOpacity(0.7200000286102295),
                                      fontSize: 13,
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontWeight: FontWeight.w500,
                                      height: 1.2,
                                    ),
                                    maxLines:
                                        null, // Allows the text to occupy as many lines as necessary
                                    overflow: TextOverflow.visible,
                                  ),
                                  trailing: TextButton(
                                      onPressed: () async {
                                        CreateAndUpdateFamilyActivityEnrollmentDto
                                            enrollmentDto =
                                            CreateAndUpdateFamilyActivityEnrollmentDto(
                                          entityActivityId:
                                              activity.entityActivityId!,
                                          familyId: widget.familyId,
                                        );

                                        bool success =
                                            await createFamilyActivityEnrollment(
                                                enrollmentDto);
                                        if (success) {
                                          Fluttertoast.showToast(
                                            msg: "joined successfully",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Color.fromARGB(
                                                163, 39, 180, 212),
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                          Navigator.pop(context);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Failed to join the activity')),
                                          );
                                        }
                                      },
                                      child: Text("join")),
                                ),
                                decoration: ShapeDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment(-0.68, -0.74),
                                    end: Alignment(0.68, 0.74),
                                    colors: [
                                      Color(0xFF9DA9DF),
                                      Color(0xFF27B5D4)
                                    ],
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(21),
                                      bottomLeft: Radius.circular(21),
                                      bottomRight: Radius.circular(5),
                                    ),
                                  ),
                                ),
                                width: 350.07,
                                height: 100.55,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 27, vertical: 13),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> createFamilyActivityEnrollment(
      CreateAndUpdateFamilyActivityEnrollmentDto enrollmentDto) async {
    final String apiUrl =
        '$url/api/FamilyActivityEnrollment/CreateFamilyActivityEnrollment';
    final storage = FlutterSecureStorage();

    final String? token = await storage.read(key: 'access_token');
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(enrollmentDto.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      // Optionally handle different status codes and log errors
      print('Failed to create family activity enrollment: ${response.body}');
      return false;
    }
  }
}

class CreateAndUpdateFamilyActivityEnrollmentDto {
  int entityActivityId;
  int familyId;

  CreateAndUpdateFamilyActivityEnrollmentDto({
    required this.entityActivityId,
    required this.familyId,
  });

  factory CreateAndUpdateFamilyActivityEnrollmentDto.fromJson(
      Map<String, dynamic> json) {
    return CreateAndUpdateFamilyActivityEnrollmentDto(
      entityActivityId: json['entityActivityId'],
      familyId: json['familyId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'entityActivityId': entityActivityId,
      'familyId': familyId,
    };
  }
}
