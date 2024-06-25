class Activity {
  final int activityId;
  final String englishName;
  final String arabicName;
  final String englishDescription;
  final String arabicDescription;
  final int committeeId;

  Activity({
    required this.activityId,
    required this.englishName,
    required this.arabicName,
    required this.englishDescription,
    required this.arabicDescription,
    required this.committeeId,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      activityId: json['activityId'],
      englishName: json['englishName'],
      arabicName: json['arabicName'],
      englishDescription: json['englishDescription'],
      arabicDescription: json['arabicDescription'],
      committeeId: json['committeeId'],
    );
  }
}

class EntityActivity {
  final int entityActivityId;
  final int unEntityId;
  final int activityId;
  final Activity activity;

  EntityActivity({
    required this.entityActivityId,
    required this.unEntityId,
    required this.activityId,
    required this.activity,
  });

  factory EntityActivity.fromJson(Map<String, dynamic> json) {
    return EntityActivity(
      entityActivityId: json['entityActivityId'],
      unEntityId: json['unEntityId'],
      activityId: json['activityId'],
      activity: Activity.fromJson(json['activity']),
    );
  }
}
