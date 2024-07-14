import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/Data_Models/All_FamilyEventsAndActivities_data.dart';

class FamilyActivitiesAndEventsEnrollements extends StatefulWidget {
  final int familyId;
  const FamilyActivitiesAndEventsEnrollements(
      {super.key, required this.familyId});

  @override
  State<FamilyActivitiesAndEventsEnrollements> createState() =>
      _FamilyActivitiesAndEventsEnrollmentsState();
}

class _FamilyActivitiesAndEventsEnrollmentsState
    extends State<FamilyActivitiesAndEventsEnrollements> {
  late Future<FamilyActivitiesAndEvents?> _familyEventsAndActivitiesFuture;

  @override
  void initState() {
    super.initState();
    _familyEventsAndActivitiesFuture =
        getFamilyEventsAndActivities(widget.familyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Family Activities and Events'),
      ),
      body: FutureBuilder<FamilyActivitiesAndEvents?>(
        future: _familyEventsAndActivitiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data found'));
          } else {
            var familyEventsAndActivities = snapshot.data!;
            return ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                Text(
                  'Family Activity Enrollments',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ...familyEventsAndActivities.familyActivityEnrollments
                        ?.map((activity) {
                      return Padding(
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
                                activity.entityActivity?.activity
                                        ?.englishName ??
                                    'No name',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontWeight: FontWeight.w700,
                                  height: 1.2,
                                ),
                              ),
                              subtitle: Text(
                                'Activity Description: ${activity.entityActivity!.activity?.englishDescription!}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Plus Jakarta Sans',
                                  height: 1.2,
                                ),
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
                            height: 90.55,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 27, vertical: 13),
                          ),
                        ),
                      );
                    }).toList() ??
                    [Text('No activity enrollments')],
                SizedBox(height: 20),
                Text(
                  'Family Event Enrollments',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ...familyEventsAndActivities.familyEventEnrollments
                        ?.map((event) {
                      return Padding(
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
                                event.currentEvent?.event?.englishName ??
                                    'No name',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontWeight: FontWeight.w700,
                                  height: 1.2,
                                ),
                              ),
                              subtitle: Text(
                                'Event Description: ${event.currentEvent?.englishDescription!}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Plus Jakarta Sans',
                                  height: 1.2,
                                ),
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
                            height: 90.55,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 27, vertical: 13),
                          ),
                        ),
                      );
                    }).toList() ??
                    [Text('No event enrollments')],
              ],
            );
          }
        },
      ),
    );
  }
}
