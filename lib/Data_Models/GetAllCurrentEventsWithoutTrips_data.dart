// ignore_for_file: unnecessary_new
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/data.dart';
import 'package:hive/family_data.dart';
import 'package:http/http.dart' as http;
import 'package:hive/pendAcceptFamily_GetFamily_data.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

enum EventType {
  Event,
  Competition,
  Trip,
}

EventType eventTypeFromInt(int value) {
  switch (value) {
    case 0:
      return EventType.Event;
    case 1:
      return EventType.Competition;
    case 2:
      return EventType.Trip;
    default:
      throw ArgumentError('Invalid event type value');
  }
}

int eventTypeToInt(EventType eventType) {
  switch (eventType) {
    case EventType.Event:
      return 0;
    case EventType.Competition:
      return 1;
    case EventType.Trip:
      return 2;
    default:
      throw ArgumentError('Invalid event type');
  }
}

enum EventStatus {
  Global,
  Local,
}

/// Helper method to convert from server-side string to Dart enum
EventStatus parseEventStatus(String status) {
  switch (status.toLowerCase()) {
    case 'global':
      return EventStatus.Global;
    case 'local':
      return EventStatus.Local;
    default:
      throw ArgumentError('Unknown EventStatus: $status');
  }
}

/// Helper method to convert from Dart enum to server-side string
String eventStatusToString(EventStatus status) {
  switch (status) {
    case EventStatus.Global:
      return 'Global';
    case EventStatus.Local:
      return 'Local';
    default:
      throw ArgumentError('Unknown EventStatus enum value: $status');
  }
}

enum VariationType {
  color,
  text,
  datetime,
  file,
  number,
}

enum EventImageType {
  main,
  random,
}

int enumToInt(dynamic enumValue) {
  return enumValue.index;
}

EventImageType intToEnumEventImageType(int index) {
  return EventImageType.values[index];
}

EventType convertIntToEventType(int value) {
  switch (value) {
    case 0:
      return EventType.Event;
    case 1:
      return EventType.Competition;
    case 2:
      return EventType.Trip;
    default:
      throw ArgumentError('Invalid EventType value: $value');
  }
}

class AllCurrentEventsWithoutTrips {
  MainEvent? mainEvent;
  CurrentEvent? currentEvent;
  List<EventRequirementVariationDto>? eventRequirementVariation;
  List<VariationValuesDto>? variationValuesDtos;
  List<EventProgramDto>? eventProgramDtos;
  UnEntityDto? unEntityDto;

  AllCurrentEventsWithoutTrips(
      {this.mainEvent,
      this.currentEvent,
      this.eventRequirementVariation,
      this.variationValuesDtos,
      this.eventProgramDtos,
      this.unEntityDto});

  AllCurrentEventsWithoutTrips.fromJson(Map<String, dynamic> json) {
    print(
        '---------------------------------------------------Parsing AllCurrentEventsWithoutTrips: $json');
    mainEvent = json['mainEvent'] != null
        ? MainEvent.fromJson(json['mainEvent'])
        : null;
    currentEvent = json['currentEvent'] != null
        ? CurrentEvent.fromJson(json['currentEvent'])
        : null;
    // Parsing EventRequirementVariationDto list
    if (json['eventRequirementVariation'] != null) {
      eventRequirementVariation = List<EventRequirementVariationDto>.from(
          json['eventRequirementVariation']
              .map((v) => EventRequirementVariationDto.fromJson(v))
              .toList());
    }
    // Parsing VariationValuesDto list
    if (json['variationValuesDtos'] != null) {
      variationValuesDtos = List<VariationValuesDto>.from(
          json['variationValuesDtos']
              .map((v) => VariationValuesDto.fromJson(v))
              .toList());
    }
    // Parsing EventProgramDto list
    if (json['eventProgramDtos'] != null) {
      eventProgramDtos = List<EventProgramDto>.from(json['eventProgramDtos']
          .map((v) => EventProgramDto.fromJson(v))
          .toList());
    }
    if (json['unEntityDto'] != null) {
      unEntityDto = UnEntityDto.fromJson(json['unEntityDto']);
    } else {
      // Handle case where unEntityDto is null or missing in the JSON
      unEntityDto = null; // Or set a default value as needed
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (mainEvent != null) {
      data['mainEvent'] = mainEvent!.toJson();
    }
    if (currentEvent != null) {
      data['currentEvent'] = currentEvent!.toJson();
    }
    if (eventRequirementVariation != null) {
      data['eventRequirementVariation'] =
          eventRequirementVariation!.map((v) => v.toJson()).toList();
    }
    if (variationValuesDtos != null) {
      data['variationValuesDtos'] =
          variationValuesDtos!.map((v) => v.toJson()).toList();
    }
    if (eventProgramDtos != null) {
      data['eventProgramDtos'] =
          eventProgramDtos!.map((v) => v.toJson()).toList();
    }
    if (unEntityDto != null) {
      data['unEntityDto'] = unEntityDto!.toJson();
    }
    return data;
  }
}

class EventProgramDto {
  int eventProgramId;
  String name;
  String description;
  int eventId;

  EventProgramDto({
    required this.eventProgramId,
    required this.name,
    this.description = '',
    required this.eventId,
  });

  // Named constructor for JSON deserialization
  factory EventProgramDto.fromJson(Map<String, dynamic> json) {
    print(
        '----------------------------------------------Parsing EventProgramDto: $json');
    return EventProgramDto(
      eventProgramId: json['eventProgramId'],
      name: json['name'],
      description: json['description'] ?? '',
      eventId: json['eventId'],
    );
  }

  // Method to convert this object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'eventProgramId': eventProgramId,
      'name': name,
      'description': description,
      'eventId': eventId,
    };
  }
}

class EventRequirementVariationDto {
  int eventRequirementVariationId;
  String name;
  VariationType type;
  String? description;
  int currentEventId;

  EventRequirementVariationDto({
    required this.eventRequirementVariationId,
    required this.name,
    required this.type,
    this.description,
    required this.currentEventId,
  });

  // Named constructor for JSON deserialization
  factory EventRequirementVariationDto.fromJson(Map<String, dynamic> json) {
    print(
        "--------------------------------------------------EventRequirementVariationDto");
    try {
      return EventRequirementVariationDto(
        eventRequirementVariationId: json['eventRequirementVariationId'],
        name: json['name'],
        type: _parseVariationType(json['type']),
        description: json['description'],
        currentEventId: json['currentEventId'],
      );
    } catch (e) {
      print('Error parsing EventRequirementVariationDto from JSON: $e');
      throw Exception('Failed to parse EventRequirementVariationDto from JSON');
    }
  }

  // Method to convert VariationType from int to enum
  static VariationType _parseVariationType(int type) {
    switch (type) {
      case 0:
        return VariationType.color;
      case 1:
        return VariationType.text;
      case 2:
        return VariationType.datetime;
      case 3:
        return VariationType.file;
      case 4:
        return VariationType.number;
      default:
        return VariationType.color; // Default value, handle appropriately
    }
  }

  // Method to convert this object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'eventRequirementVariationId': eventRequirementVariationId,
      'name': name,
      'type': type.toString().split('.').last, // Convert enum to string
      'description': description,
      'currentEventId': currentEventId,
    };
  }
}

class VariationValuesDto {
  int variationValuesId;
  String? value;
  int? userEventEnrollmentId;
  int eventRequirementVariationId;

  VariationValuesDto({
    required this.variationValuesId,
    this.value,
    this.userEventEnrollmentId,
    required this.eventRequirementVariationId,
  });

  // Named constructor for JSON deserialization
  factory VariationValuesDto.fromJson(Map<String, dynamic> json) {
    print("----------------------------------------------VariationValuesDto");
    return VariationValuesDto(
      variationValuesId: json['variationValuesId'],
      value: json['value'],
      userEventEnrollmentId: json['userEventEnrollmentId'],
      eventRequirementVariationId: json['eventRequirementVariationId'],
    );
  }

  // Method to convert this object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'variationValuesId': variationValuesId,
      'value': value,
      'userEventEnrollmentId': userEventEnrollmentId,
      'eventRequirementVariationId': eventRequirementVariationId,
    };
  }
}

class MainEvent {
  int? mainEventId;
  String? englishName;
  String? arabicName;
  String? englishDescription;
  String? arabicDescription;
  Status? status;
  EventType? eventType;

  MainEvent(
      {this.mainEventId,
      this.englishName,
      this.arabicName,
      this.englishDescription,
      this.arabicDescription,
      this.status,
      this.eventType});

  MainEvent.fromJson(Map<String, dynamic> json) {
    mainEventId = json['mainEventId'];
    englishName = json['englishName'];
    arabicName = json['arabicName'];
    englishDescription = json['englishDescription'];
    arabicDescription = json['arabicDescription'];
    status = StatusExtension.fromIndex(json['status']);
    eventType = eventTypeFromInt(json['eventType']);
    print(
        '------------------------------------------------------Parsing MainEvent: $json');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mainEventId'] = this.mainEventId;
    data['englishName'] = this.englishName;
    data['arabicName'] = this.arabicName;
    data['englishDescription'] = this.englishDescription;
    data['arabicDescription'] = this.arabicDescription;
    data['status'] = status?.toIndex();
    data['eventType'] = eventTypeToInt(eventType! as EventType);
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

class UnEntityDto {
  int? unEntityId;
  String? englishEntityName;
  String? arabicEntityName;

  UnEntityDto({this.unEntityId, this.englishEntityName, this.arabicEntityName});

  UnEntityDto.fromJson(Map<String, dynamic> json) {
    unEntityId = json['unEntityId'];
    englishEntityName = json['englishEntityName'];
    arabicEntityName = json['arabicEntityName'];
    print("----------------------------------------------UnEntityDto");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unEntityId'] = this.unEntityId;
    data['englishEntityName'] = this.englishEntityName;
    data['arabicEntityName'] = this.arabicEntityName;
    return data;
  }
}

final storage = FlutterSecureStorage();

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

Future<List<AllCurrentEventsWithoutTrips>> getAllCurrentEventsWithoutTrips(
    int familyId) async {
  int unEntityId = await _getUnEntityIdFromToken();

  final String apiUrl =
      '$url/api/CommitteeEntityActivity/GetAllCurrentEventsWithoutTrips/$unEntityId/$familyId';
  final response = await http.get(Uri.parse(apiUrl), headers: {
    'Authorization': 'Bearer ${await _getToken()}',
  });

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data
        .map((json) => AllCurrentEventsWithoutTrips.fromJson(json))
        .toList();
  } else {
    throw Exception('Failed to load current events');
  }
}
