import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/data.dart';

class EntityActivitiesForFamilies {
  int? entityActivityId;
  int? unEntityId;
  int? activityId;
  Activity? activity;
  Committy? committy;

  EntityActivitiesForFamilies(
      {this.entityActivityId,
      this.unEntityId,
      this.activityId,
      this.activity,
      this.committy});

  EntityActivitiesForFamilies.fromJson(Map<String, dynamic> json) {
    entityActivityId = json['entityActivityId'];
    unEntityId = json['unEntityId'];
    activityId = json['activityId'];
    activity = json['activity'] != null
        ? new Activity.fromJson(json['activity'])
        : null;
    committy = json['committy'] != null
        ? new Committy.fromJson(json['committy'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['entityActivityId'] = this.entityActivityId;
    data['unEntityId'] = this.unEntityId;
    data['activityId'] = this.activityId;
    if (this.activity != null) {
      data['activity'] = this.activity!.toJson();
    }
    if (this.committy != null) {
      data['committy'] = this.committy!.toJson();
    }
    return data;
  }
}

class Activity {
  int? activityId;
  String? englishName;
  String? arabicName;
  String? englishDescription;
  String? arabicDescription;

  Activity(
      {this.activityId,
      this.englishName,
      this.arabicName,
      this.englishDescription,
      this.arabicDescription});

  Activity.fromJson(Map<String, dynamic> json) {
    activityId = json['activityId'];
    englishName = json['englishName'];
    arabicName = json['arabicName'];
    englishDescription = json['englishDescription'];
    arabicDescription = json['arabicDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['activityId'] = this.activityId;
    data['englishName'] = this.englishName;
    data['arabicName'] = this.arabicName;
    data['englishDescription'] = this.englishDescription;
    data['arabicDescription'] = this.arabicDescription;
    return data;
  }
}

class Committy {
  int? committeeId;
  String? englishName;
  String? arabicName;
  String? englishDescreption;
  String? arabicDescreption;

  Committy(
      {this.committeeId,
      this.englishName,
      this.arabicName,
      this.englishDescreption,
      this.arabicDescreption});

  Committy.fromJson(Map<String, dynamic> json) {
    committeeId = json['committeeId'];
    englishName = json['englishName'];
    arabicName = json['arabicName'];
    englishDescreption = json['englishDescreption'];
    arabicDescreption = json['arabicDescreption'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['committeeId'] = this.committeeId;
    data['englishName'] = this.englishName;
    data['arabicName'] = this.arabicName;
    data['englishDescreption'] = this.englishDescreption;
    data['arabicDescreption'] = this.arabicDescreption;
    return data;
  }
}

Future<List<EntityActivitiesForFamilies>> getEntityActivitiesForFamilies(
    int unEntityId, int familyId) async {
  final String Apiurl =
      '$url/api/CommitteEntityActivity/GetEntityActivitiesForFamilies/$unEntityId'; // Replace with your API endpoint
  final response = await http.get(Uri.parse(Apiurl));

  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    List<EntityActivitiesForFamilies> entityActivities = body
        .map((dynamic item) => EntityActivitiesForFamilies.fromJson(item))
        .toList();
    return entityActivities;
  } else {
    throw Exception('Failed to load entity activities');
  }
}
