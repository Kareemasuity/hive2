import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/Data_Models/GetAllCurrentEventsWithoutTrips_data.dart';
import 'package:hive/data.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

class FamilyEvents extends StatefulWidget {
  final int familyId;
  const FamilyEvents({super.key, required this.familyId});

  @override
  State<FamilyEvents> createState() => _FamilyEventsState();
}

class _FamilyEventsState extends State<FamilyEvents> {
  late Future<List<AllCurrentEventsWithoutTrips>> allCurrentEventsWithoutTrips;

  @override
  void initState() {
    super.initState();
    allCurrentEventsWithoutTrips =
        getAllCurrentEventsWithoutTrips(widget.familyId);
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   allCurrentEventsWithoutTrips =
  //       getAllCurrentEventsWithoutTrips(widget.familyId);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Current Events'),
      ),
      body: FutureBuilder<List<AllCurrentEventsWithoutTrips>>(
        future: allCurrentEventsWithoutTrips,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No events available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final event = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.all(5.0),
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
                          event.currentEvent?.englishDescription ??
                              'No Description',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                        subtitle: Text(
                          event.mainEvent?.englishName ?? 'No Name',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7200000286102295),
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
                          child: Text("Join"),
                          onPressed: () async {
                            final enrollmentDto =
                                CreateAndUpdateFamilyEventEnrollmentDto(
                              familyId: widget.familyId,
                              rate: null,
                              role: 1,
                              currentEventId:
                                  event.currentEvent?.currentEventId ?? 0,
                            );

                            try {
                              await createFamilyEventEnrollment(
                                  enrollmentDto); // Wait for enrollment to complete
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Enrollment created successfully'),
                                ),
                              );
                              Navigator.pop(context);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Failed to create enrollment: $e')),
                              );
                            }
                          },
                        ),
                      ),
                      decoration: ShapeDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(-0.68, -0.74),
                          end: Alignment(0.68, 0.74),
                          colors: [Color(0xFF9DA9DF), Color(0xFF27B5D4)],
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
                );
              },
            );
          }
        },
      ),
    );
  }
}

Future<http.Response?> createFamilyEventEnrollment(
    CreateAndUpdateFamilyEventEnrollmentDto enrollmentDto) async {
  final storage = FlutterSecureStorage();
  Future<String?> getToken() async {
    return await storage.read(key: 'access_token');
  }

  String? token = await getToken();

  if (token == null) {
    print('Token not found');
    return null;
  }
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token', // Include the JWT token here
  };

  final body = jsonEncode(enrollmentDto.toJson());

  final response = await http.post(
      Uri.parse("$url/api/FamilyEventEnrollment/CreateFamilyEventEnrollment"),
      headers: headers,
      body: body);

  if (response.statusCode == 200) {
    return response;
  } else {
    throw Exception(
        'Failed to create family event enrollment: ${response.reasonPhrase}');
  }
}

class CreateAndUpdateFamilyEventEnrollmentDto {
  int familyId;
  double? rate;
  int? role;
  int currentEventId;

  CreateAndUpdateFamilyEventEnrollmentDto({
    required this.familyId,
    this.rate,
    this.role,
    required this.currentEventId,
  });

  factory CreateAndUpdateFamilyEventEnrollmentDto.fromJson(
      Map<String, dynamic> json) {
    return CreateAndUpdateFamilyEventEnrollmentDto(
      familyId: json['familyId'],
      rate: json['rate']?.toDouble(),
      role: json['role'] ?? 'Participants', // Convert to double
      currentEventId: json['currentEventId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['familyId'] = familyId;
    if (rate != null) {
      data['rate'] = rate;
    }
    data['role'] = role;
    data['currentEventId'] = currentEventId;
    return data;
  }
}
