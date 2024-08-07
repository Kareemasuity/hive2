import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/family_events.dart';
//import 'package:hive/myFamily_response_data.dart';
import 'package:hive/pendAcceptFamily_GetFamily_data.dart';
import 'package:hive/family_activities.dart';
import 'package:hive/widgets/familyActivitiesAndEventEnrollement.dart';
import 'package:intl/intl.dart';

// Assuming you have your NewFamilyDto and other related classes defined as in the previous response

class EnrolledAcceptedFamiliesWidget extends StatefulWidget {
  final int familyId;

  const EnrolledAcceptedFamiliesWidget({
    Key? key,
    required this.familyId,
  }) : super(key: key);

  @override
  _EnrolledAcceptedFamiliesWidgetState createState() =>
      _EnrolledAcceptedFamiliesWidgetState();
}

class _EnrolledAcceptedFamiliesWidgetState
    extends State<EnrolledAcceptedFamiliesWidget> {
  late Future<GetFamilyWithDetailsDto> _futureFamilyDetails;

  @override
  void initState() {
    super.initState();
    _futureFamilyDetails = fetchFamilyDetails(widget.familyId);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch family details whenever the dependencies change (i.e., every time the widget is displayed)
    _futureFamilyDetails = fetchFamilyDetails(widget.familyId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GetFamilyWithDetailsDto>(
      future: _futureFamilyDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('No data available'));
        } else {
          final GetFamilyWithDetailsDto familyDetails = snapshot.data!;
          print("---------------------------------------$familyDetails");
          print(
              '--------------------------------------------------------Family Activity Enrollment DTOs: ${familyDetails.familyActivityEnrollmentDtos}');
          print(
              '--------------------------------------------------------Family Event Enrollment DTOs: ${familyDetails.familyEventEnrollmentDtos}');

          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Your family is Accepted',
                textAlign: TextAlign.center,
              ),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Family Name: ${familyDetails.familyDto?.name ?? 'N/A'}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Column(children: [
                    Text(
                      'Family Mission:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(' ${familyDetails.familyDto?.familyMission ?? 'N/A'}',
                        style: TextStyle(fontSize: 16)),
                  ]),
                  SizedBox(height: 12),
                  Column(children: [
                    Text(
                      'Family Vision: ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      ' ${familyDetails.familyDto?.familyVision ?? 'N/A'}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ]),
                  SizedBox(height: 24),
                  Text(
                    'Family Members:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  if (familyDetails.familyMembersDtos != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: familyDetails.familyMembersDtos!.map((member) {
                        return ListTile(
                          title: Text(
                              'Name: ${member.studentDto?.firstName ?? 'N/A'} ${member.studentDto?.lastName ?? ''}'),
                          subtitle: Text(
                              'Email: ${member.studentDto?.email ?? 'N/A'}'),
                        );
                      }).toList(),
                    ),
                  if (familyDetails.familyMembersDtos == null ||
                      familyDetails.familyMembersDtos!.isEmpty)
                    Text('No family members found'),
                  SizedBox(height: 24),
                  Text(
                    'Family Plans:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  if (familyDetails.familyPlanDtos != null &&
                      familyDetails.familyPlanDtos!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: familyDetails.familyPlanDtos!
                          .map((plan) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Event Name: ${plan.eventName ?? 'N/A'}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    'Place of Implementation: ${plan.placeOfImplementation ?? 'N/A'}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    'Start Date: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(plan.startDate!)) ?? 'N/A'}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    'End Date: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(plan.endDate!)) ?? 'N/A'}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 12),
                                ],
                              ))
                          .toList(),
                    ),
                  SizedBox(height: 24),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FamilyActivitiesAndEventsEnrollements(
                                  familyId: widget.familyId),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 500,
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Text(
                            "Go to your enrolled activities and events",
                            style: TextStyle(fontSize: 16),
                          )),
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 217, 238, 255),
                          borderRadius: BorderRadius.circular(5.0),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(66, 57, 49, 81),
                              blurRadius: 10,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Text(
                  //   'Family Activity Enrollments:',
                  //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  // ),
                  // SizedBox(height: 6,),
                  // Text("Event description"),
                  // SizedBox(height: 12),
                  // if (familyDetails.familyActivityEnrollmentDtos != null &&
                  //     familyDetails.familyActivityEnrollmentDtos!.isNotEmpty)
                  //   Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: familyDetails.familyActivityEnrollmentDtos!
                  //         .map((enrollment) => Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 if (enrollment.entityActivityDto != null &&
                  //                     enrollment.entityActivityDto!.activity !=
                  //                         null)
                  //                   Column(
                  //                     crossAxisAlignment:
                  //                         CrossAxisAlignment.start,
                  //                     children: [
                  //                       Text(
                  //                         'Activity Name: ${enrollment.entityActivityDto!.activity!.englishName ?? 'N/A'}',
                  //                         style: TextStyle(fontSize: 16),
                  //                       ),
                  //                       SizedBox(height: 6),
                  //                       Text(
                  //                         'Activity Description: ${enrollment.entityActivityDto!.activity!.englishDescription ?? 'N/A'}',
                  //                         style: TextStyle(fontSize: 16),
                  //                       ),
                  //                       SizedBox(height: 6),
                  //                     ],
                  //                   ),
                  //                 SizedBox(height: 12),
                  //               ],
                  //             ))
                  //         .toList(),
                  //   ),
                  // SizedBox(height: 24),
                  // Text(
                  //   'Family Event Enrollments:',
                  //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  // ),
                  // SizedBox(height: 12),
                  // if (familyDetails.familyEventEnrollmentDtos != null &&
                  //     familyDetails.familyEventEnrollmentDtos!.isNotEmpty)
                  //   ListView.builder(
                  //     shrinkWrap: true,
                  //     itemCount:
                  //         familyDetails.familyEventEnrollmentDtos!.length,
                  //     itemBuilder: (context, index) {
                  //       var event =
                  //           familyDetails.familyEventEnrollmentDtos![index];
                  //       return ListTile(
                  //         title: Text(
                  //           event.currentEventDtos?.englishDescription ?? 'N/A',
                  //           style: TextStyle(color: Colors.black),
                  //         ),
                  //         subtitle: Text(
                  //           event.currentEventDtos?.startDate as String ??
                  //               'N/A',
                  //           style: TextStyle(color: Colors.black54),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // if (familyDetails.familyEventEnrollmentDtos == null ||
                  //     familyDetails.familyEventEnrollmentDtos!.isEmpty)
                  //   Text('No family event enrollments found'),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(-0.68, -0.74),
                            end: Alignment(0.68, 0.74),
                            colors: [
                              Color(0xFF9DA9DF),
                              Color(0xFF27B5D4),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(
                              20), // Match your desired border radius
                        ),
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              shadowColor:
                                  MaterialStateProperty.all(Colors.transparent),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FamilyActivities(
                                      familyId: widget.familyId),
                                ),
                              );
                            },
                            child: Text(
                              "Available Activities",
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(-0.68, -0.74),
                            end: Alignment(0.68, 0.74),
                            colors: [
                              Color(0xFF9DA9DF),
                              Color(0xFF27B5D4),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(
                              20), // Match your desired border radius
                        ),
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              shadowColor:
                                  MaterialStateProperty.all(Colors.transparent),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FamilyEvents(familyId: widget.familyId),
                                ),
                              );
                            },
                            child: Text("Available Events",
                                style: TextStyle(color: Colors.white))),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
