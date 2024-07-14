import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/Data_Models/GetAllCurrentEventsWithoutTrips_data.dart';
import 'package:hive/data.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

class FamilyActivitiesAndEvents {
  List<FamilyActivityEnrollments>? familyActivityEnrollments;
  List<FamilyEventEnrollments>? familyEventEnrollments;

  FamilyActivitiesAndEvents(
      {this.familyActivityEnrollments, this.familyEventEnrollments});

  FamilyActivitiesAndEvents.fromJson(Map<String, dynamic> json) {
    if (json['familyActivityEnrollments'] != null) {
      familyActivityEnrollments = <FamilyActivityEnrollments>[];
      json['familyActivityEnrollments'].forEach((v) {
        familyActivityEnrollments!
            .add(new FamilyActivityEnrollments.fromJson(v));
      });
    }
    if (json['familyEventEnrollments'] != null) {
      familyEventEnrollments = <FamilyEventEnrollments>[];
      json['familyEventEnrollments'].forEach((v) {
        familyEventEnrollments!.add(new FamilyEventEnrollments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.familyActivityEnrollments != null) {
      data['familyActivityEnrollments'] =
          this.familyActivityEnrollments!.map((v) => v.toJson()).toList();
    }
    if (this.familyEventEnrollments != null) {
      data['familyEventEnrollments'] =
          this.familyEventEnrollments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FamilyActivityEnrollments {
  int? familyActivityEnrollmentId;
  int? entityActivityId;
  EntityActivity? entityActivity;
  int? familyId;

  FamilyActivityEnrollments(
      {this.familyActivityEnrollmentId,
      this.entityActivityId,
      this.entityActivity,
      this.familyId});

  FamilyActivityEnrollments.fromJson(Map<String, dynamic> json) {
    familyActivityEnrollmentId = json['familyActivityEnrollmentId'];
    entityActivityId = json['entityActivityId'];
    entityActivity = json['entityActivity'] != null
        ? new EntityActivity.fromJson(json['entityActivity'])
        : null;
    familyId = json['familyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['familyActivityEnrollmentId'] = this.familyActivityEnrollmentId;
    data['entityActivityId'] = this.entityActivityId;
    if (this.entityActivity != null) {
      data['entityActivity'] = this.entityActivity!.toJson();
    }
    data['familyId'] = this.familyId;
    return data;
  }
}

class EntityActivity {
  int? entityActivityId;
  int? unEntityId;
  int? activityId;
  Activity? activity;

  EntityActivity(
      {this.entityActivityId, this.unEntityId, this.activityId, this.activity});

  EntityActivity.fromJson(Map<String, dynamic> json) {
    entityActivityId = json['entityActivityId'];
    unEntityId = json['unEntityId'];
    activityId = json['activityId'];
    activity = json['activity'] != null
        ? new Activity.fromJson(json['activity'])
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
    return data;
  }
}

class Activity {
  int? activityId;
  String? englishName;
  String? arabicName;
  String? englishDescription;
  String? arabicDescription;
  int? activityType;
  String? imagePath;
  Committee? committee;

  Activity(
      {this.activityId,
      this.englishName,
      this.arabicName,
      this.englishDescription,
      this.arabicDescription,
      this.activityType,
      this.imagePath,
      this.committee});

  Activity.fromJson(Map<String, dynamic> json) {
    activityId = json['activityId'];
    englishName = json['englishName'];
    arabicName = json['arabicName'];
    englishDescription = json['englishDescription'];
    arabicDescription = json['arabicDescription'];
    activityType = json['activityType'];
    imagePath = json['imagePath'];
    committee = json['committee'] != null
        ? new Committee.fromJson(json['committee'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['activityId'] = this.activityId;
    data['englishName'] = this.englishName;
    data['arabicName'] = this.arabicName;
    data['englishDescription'] = this.englishDescription;
    data['arabicDescription'] = this.arabicDescription;
    data['activityType'] = this.activityType;
    data['imagePath'] = this.imagePath;
    if (this.committee != null) {
      data['committee'] = this.committee!.toJson();
    }
    return data;
  }
}

class Committee {
  int? committeeId;
  String? englishName;
  String? arabicName;
  String? englishDescreption;
  String? arabicDescreption;

  Committee(
      {this.committeeId,
      this.englishName,
      this.arabicName,
      this.englishDescreption,
      this.arabicDescreption});

  Committee.fromJson(Map<String, dynamic> json) {
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

class FamilyEventEnrollments {
  int? familyEventEnrollmentId;
  int? role;
  Null? rate;
  int? status;
  int? familyId;
  int? currentEventId;
  CurrentEvent? currentEvent;

  FamilyEventEnrollments(
      {this.familyEventEnrollmentId,
      this.role,
      this.rate,
      this.status,
      this.familyId,
      this.currentEventId,
      this.currentEvent});

  FamilyEventEnrollments.fromJson(Map<String, dynamic> json) {
    familyEventEnrollmentId = json['familyEventEnrollmentId'];
    role = json['role'];
    rate = json['rate'];
    status = json['status'];
    familyId = json['familyId'];
    currentEventId = json['currentEventId'];
    currentEvent = json['currentEvent'] != null
        ? new CurrentEvent.fromJson(json['currentEvent'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['familyEventEnrollmentId'] = this.familyEventEnrollmentId;
    data['role'] = this.role;
    data['rate'] = this.rate;
    data['status'] = this.status;
    data['familyId'] = this.familyId;
    data['currentEventId'] = this.currentEventId;
    if (this.currentEvent != null) {
      data['currentEvent'] = this.currentEvent!.toJson();
    }
    return data;
  }
}

class CurrentEvent {
  int? currentEventId;
  int? eventStatus;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? formSubmissionDeadline;
  String? location;
  String? englishDescription;
  String? arabicDescription;
  int? activityId;
  int? eventId;
  MainEvent? event;
  List<EventImagesDto?>? eventImages;

  CurrentEvent({
    this.currentEventId,
    this.eventStatus,
    this.startDate,
    this.endDate,
    this.formSubmissionDeadline,
    this.location,
    this.englishDescription,
    this.arabicDescription,
    this.activityId,
    this.eventId,
    this.event,
    this.eventImages,
  });

  factory CurrentEvent.fromJson(Map<String, dynamic> json) {
    print(
        '----------------------------------------------------------Parsing CurrentEvent: $json');
    try {
      return CurrentEvent(
        currentEventId: json['currentEventId'],
        eventStatus: json['eventStatus'],
        // eventStatus: json['eventStatus'] != null
        //     ? parseEventStatus(json['eventStatus'])
        //     : null,
        startDate: json['startDate'] != null
            ? DateTime.parse(json['startDate'])
            : null,
        endDate:
            json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
        formSubmissionDeadline: json['formSubmissionDeadline'] != null
            ? DateTime.parse(json['formSubmissionDeadline'])
            : null,
        location: json['location'],
        englishDescription: json['englishDescription'],
        arabicDescription: json['arabicDescription'],
        activityId: json['activityId'],
        eventId: json['eventId'],
        event: json['event'] != null ? MainEvent.fromJson(json['event']) : null,
        eventImages: json['eventImages'] != null
            ? List<EventImagesDto>.from(
                json['eventImages'].map((x) => EventImagesDto.fromJson(x)))
            : [],
      );
    } catch (e) {
      print('Error parsing CurrentEvent from JSON: $e');
      throw Exception('Failed to parse CurrentEvent from JSON');
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['currentEventId'] = this.currentEventId;
    if (this.eventStatus != null) {
      data['eventStatus'] = eventTypeToInt(this.eventStatus!
          as EventType); // Assuming eventStatusToJson converts enum to int
    }
    data['startDate'] =
        this.startDate?.toIso8601String(); // Convert DateTime to ISO8601 string
    data['endDate'] =
        this.endDate?.toIso8601String(); // Convert DateTime to ISO8601 string
    data['formSubmissionDeadline'] = this
        .formSubmissionDeadline
        ?.toIso8601String(); // Convert DateTime to ISO8601 string
    data['location'] = this.location;
    data['englishDescription'] = this.englishDescription;
    data['arabicDescription'] = this.arabicDescription;
    data['activityId'] = this.activityId;
    data['eventId'] = this.eventId;
    if (this.event != null) {
      data['event'] = this.event!.toJson();
    }
    if (this.eventImages != null) {
      data['eventImages'] = this.eventImages!.map((v) => v?.toJson()).toList();
    }
    return data;
  }
}

enum EventImageType {
  main,
  random,
}

class EventImagesDto {
  int imageId;
  EventImageType? type;
  String? eventDescription;
  String filePath;
  int currentEventId;

  EventImagesDto({
    required this.imageId,
    this.type = EventImageType.random,
    this.eventDescription,
    required this.filePath,
    required this.currentEventId,
  });

  // Named constructor for JSON deserialization
  factory EventImagesDto.fromJson(Map<String, dynamic> json) {
    return EventImagesDto(
      imageId: json['imageId'],
      type: _parseImageType(json['type']),
      eventDescription: json['eventDescription'],
      filePath: json['filePath'],
      currentEventId: json['currentEventId'],
    );
  }

  // Method to convert EventImageType from int to enum
  static EventImageType _parseImageType(int type) {
    return EventImageType.values[type] ?? EventImageType.random;
  }

  // Method to convert this object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'imageId': imageId,
      'type': enumToInt(type!), // Convert enum to int
      'eventDescription': eventDescription,
      'filePath': filePath,
      'currentEventId': currentEventId,
    };
  }
}

class Event {
  int? mainEventId;
  String? englishName;
  String? arabicName;
  String? englishDescription;
  String? arabicDescription;
  int? status;
  int? eventType;

  Event(
      {this.mainEventId,
      this.englishName,
      this.arabicName,
      this.englishDescription,
      this.arabicDescription,
      this.status,
      this.eventType});

  Event.fromJson(Map<String, dynamic> json) {
    mainEventId = json['mainEventId'];
    englishName = json['englishName'];
    arabicName = json['arabicName'];
    englishDescription = json['englishDescription'];
    arabicDescription = json['arabicDescription'];
    status = json['status'];
    eventType = json['eventType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mainEventId'] = this.mainEventId;
    data['englishName'] = this.englishName;
    data['arabicName'] = this.arabicName;
    data['englishDescription'] = this.englishDescription;
    data['arabicDescription'] = this.arabicDescription;
    data['status'] = this.status;
    data['eventType'] = this.eventType;
    return data;
  }
}

Future<FamilyActivitiesAndEvents?> getFamilyEventsAndActivities(
    int familyId) async {
  final storage = FlutterSecureStorage();
  Future<String?> getToken() async {
    return await storage.read(key: 'access_token');
  }

  final String apiurl =
      '$url/api/CommitteeEntityActivity/GetFamilyEventsAndActivities/$familyId';
  String? token = await getToken();

  if (token == null) {
    print('Token not found');
    return null;
  }

  final response = await http.get(
    Uri.parse(apiurl),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );
  // final response = await http.get(Uri.parse(apiurl));

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    return FamilyActivitiesAndEvents.fromJson(jsonResponse);
  } else {
    print('Failed to load data');
    return null;
  }
}
