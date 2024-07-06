import 'package:flutter/material.dart';
//import 'package:hive/myFamily_response_data.dart';
import 'package:hive/pendAcceptFamily_GetFamily_data.dart';
import 'package:intl/intl.dart';

// Assuming you have your NewFamilyDto and other related classes defined as in the previous response

class EnrolledPendingFamiliesWidget extends StatefulWidget {
  final int familyId;

  const EnrolledPendingFamiliesWidget({
    Key? key,
    required this.familyId,
  }) : super(key: key);

  @override
  _EnrolledPendingFamiliesWidgetState createState() =>
      _EnrolledPendingFamiliesWidgetState();
}

class _EnrolledPendingFamiliesWidgetState
    extends State<EnrolledPendingFamiliesWidget> {
  late Future<GetFamilyWithDetailsDto> _futureFamilyDetails;

  @override
  void initState() {
    super.initState();
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

          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Your family is Pending',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w700,
                  height: 0.03,
                ),
              ),
              backgroundColor: const Color.fromARGB(255, 1, 52, 130),
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
                  Text(
                    'Family Mission: ${familyDetails.familyDto?.familyMission ?? 'N/A'}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Family Vision: ${familyDetails.familyDto?.familyVision ?? 'N/A'}',
                    style: TextStyle(fontSize: 16),
                  ),
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
                                    'Start Date: ${plan.startDate ?? 'N/A'}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    'End Date: ${plan.endDate ?? 'N/A'}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 12),
                                ],
                              ))
                          .toList(),
                    ),
                  SizedBox(height: 24),
                  Text(
                    'Family Activity Enrollments:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  if (familyDetails.familyActivityEnrollmentDtos != null &&
                      familyDetails.familyActivityEnrollmentDtos!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: familyDetails.familyActivityEnrollmentDtos!
                          .map((enrollment) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Entity Activity ID: ${enrollment.entityActivityId ?? 'N/A'}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 6),
                                  if (enrollment.entityActivityDto != null)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Activity Name: ${enrollment.entityActivityDto!.activity?.englishName ?? 'N/A'}',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          'Activity Description: ${enrollment.entityActivityDto!.activity?.englishDescription ?? 'N/A'}',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(height: 6),
                                      ],
                                    ),
                                  SizedBox(height: 12),
                                ],
                              ))
                          .toList(),
                    ),
                  SizedBox(height: 24),
                  Text(
                    'Family Event Enrollments:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  if (familyDetails.familyEventEnrollmentDtos != null &&
                      familyDetails.familyEventEnrollmentDtos!.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount:
                          familyDetails.familyEventEnrollmentDtos!.length,
                      itemBuilder: (context, index) {
                        var event =
                            familyDetails.familyEventEnrollmentDtos![index];
                        return ListTile(
                          title: Text(
                              event.currentEventDtos?.englishDescription ??
                                  'N/A'),
                          subtitle:
                              Text(event.currentEventDtos?.startDate ?? 'N/A'),
                        );
                      },
                    ),
                  if (familyDetails.familyEventEnrollmentDtos == null ||
                      familyDetails.familyEventEnrollmentDtos!.isEmpty)
                    Text('No family event enrollments found'),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
