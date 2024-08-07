// FamilyDto class
import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/Data_Models/GetAllCurrentEventsWithoutTrips_data.dart';
import 'package:hive/data.dart';

import 'package:http/http.dart' as http;
import 'package:hive/family_data.dart';

enum EventStatus { Global, local }

class GetFamilyWithDetailsDto {
  FamilyDto? familyDto;
  List<FamilyPlanDtos>? familyPlanDtos;
  List<FamilyActivityEnrollmentDtos>? familyActivityEnrollmentDtos;
  List<FamilyEventEnrollmentDtos>? familyEventEnrollmentDtos;
  List<FamilySupervisorsDtos>? familySupervisorsDtos;
  List<FamilyMembersDtos>? familyMembersDtos;

  GetFamilyWithDetailsDto(
      {this.familyDto,
      this.familyPlanDtos,
      this.familyActivityEnrollmentDtos,
      this.familyEventEnrollmentDtos,
      this.familySupervisorsDtos,
      this.familyMembersDtos});

  GetFamilyWithDetailsDto.fromJson(Map<String, dynamic> json) {
    familyDto = json['familyDto'] != null
        ? new FamilyDto.fromJson(json['familyDto'])
        : null;
    if (json['familyPlanDtos'] != null) {
      familyPlanDtos = <FamilyPlanDtos>[];
      json['familyPlanDtos'].forEach((v) {
        familyPlanDtos!.add(new FamilyPlanDtos.fromJson(v));
      });
    }
    if (json['familyActivityEnrollmentDtos'] != null) {
      familyActivityEnrollmentDtos = <FamilyActivityEnrollmentDtos>[];
      json['familyActivityEnrollmentDtos'].forEach((v) {
        familyActivityEnrollmentDtos!
            .add(new FamilyActivityEnrollmentDtos.fromJson(v));
      });
    }
    if (json['familyEventEnrollmentDtos'] != null) {
      familyEventEnrollmentDtos = <FamilyEventEnrollmentDtos>[];
      json['familyEventEnrollmentDtos'].forEach((v) {
        familyEventEnrollmentDtos!
            .add(new FamilyEventEnrollmentDtos.fromJson(v));
      });
    }
    if (json['familySupervisorsDtos'] != null) {
      familySupervisorsDtos = <FamilySupervisorsDtos>[];
      json['familySupervisorsDtos'].forEach((v) {
        familySupervisorsDtos!.add(new FamilySupervisorsDtos.fromJson(v));
      });
    }
    if (json['familyMembersDtos'] != null) {
      familyMembersDtos = <FamilyMembersDtos>[];
      json['familyMembersDtos'].forEach((v) {
        familyMembersDtos!.add(new FamilyMembersDtos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.familyDto != null) {
      data['familyDto'] = this.familyDto!.toJson();
    }
    if (this.familyPlanDtos != null) {
      data['familyPlanDtos'] =
          this.familyPlanDtos!.map((v) => v.toJson()).toList();
    }
    if (this.familyActivityEnrollmentDtos != null) {
      data['familyActivityEnrollmentDtos'] =
          this.familyActivityEnrollmentDtos!.map((v) => v.toJson()).toList();
    }
    if (this.familyEventEnrollmentDtos != null) {
      data['familyEventEnrollmentDtos'] =
          this.familyEventEnrollmentDtos!.map((v) => v.toJson()).toList();
    }
    if (this.familySupervisorsDtos != null) {
      data['familySupervisorsDtos'] =
          this.familySupervisorsDtos!.map((v) => v.toJson()).toList();
    }
    if (this.familyMembersDtos != null) {
      data['familyMembersDtos'] =
          this.familyMembersDtos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FamilyDto {
  int? familyId;
  String? name;
  String? familyMission;
  String? familyVision;
  String? imagePath;
  String? deanApproval;
  String? headApproval;
  String? viceHeadApproval;
  int? status;
  int? familyRulesId;
  String? createdDate;

  FamilyDto(
      {this.familyId,
      this.name,
      this.familyMission,
      this.familyVision,
      this.imagePath,
      this.deanApproval,
      this.headApproval,
      this.viceHeadApproval,
      this.status,
      this.familyRulesId,
      this.createdDate});

  FamilyDto.fromJson(Map<String, dynamic> json) {
    familyId = json['familyId'];
    name = json['name'];
    familyMission = json['familyMission'];
    familyVision = json['familyVision'];
    imagePath = json['imagePath'];
    deanApproval = json['deanApproval'];
    headApproval = json['headApproval'];
    viceHeadApproval = json['viceHeadApproval'];
    status = json['status'];
    familyRulesId = json['familyRulesId'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['familyId'] = this.familyId;
    data['name'] = this.name;
    data['familyMission'] = this.familyMission;
    data['familyVision'] = this.familyVision;
    data['imagePath'] = this.imagePath;
    data['deanApproval'] = this.deanApproval;
    data['headApproval'] = this.headApproval;
    data['viceHeadApproval'] = this.viceHeadApproval;
    data['status'] = this.status;
    data['familyRulesId'] = this.familyRulesId;
    data['createdDate'] = this.createdDate;
    return data;
  }
}

class FamilyPlanDtos {
  int? familyPlanId;
  int? familyId;
  String? eventName;
  String? placeOfImplementation;
  String? startDate;
  String? endDate;

  FamilyPlanDtos(
      {this.familyPlanId,
      this.familyId,
      this.eventName,
      this.placeOfImplementation,
      this.startDate,
      this.endDate});

  FamilyPlanDtos.fromJson(Map<String, dynamic> json) {
    familyPlanId = json['familyPlanId'];
    familyId = json['familyId'];
    eventName = json['eventName'];
    placeOfImplementation = json['placeOfImplementation'];
    startDate = json['startDate'];
    endDate = json['endDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['familyPlanId'] = this.familyPlanId;
    data['familyId'] = this.familyId;
    data['eventName'] = this.eventName;
    data['placeOfImplementation'] = this.placeOfImplementation;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    return data;
  }
}

class FamilyActivityEnrollmentDtos {
  int? familyActivityEnrollmentId;
  int? entityActivityId;
  EntityActivityDto? entityActivityDto;
  int? familyId;

  FamilyActivityEnrollmentDtos(
      {this.familyActivityEnrollmentId,
      this.entityActivityId,
      this.entityActivityDto,
      this.familyId});

  factory FamilyActivityEnrollmentDtos.fromJson(Map<String, dynamic> json) {
    try {
      return FamilyActivityEnrollmentDtos(
        familyActivityEnrollmentId: json['familyActivityEnrollmentId'],
        entityActivityId: json['entityActivityId'],
        entityActivityDto: json['entityActivityDto'] != null
            ? EntityActivityDto.fromJson(json['entityActivityDto'])
            : null,
        familyId: json['familyId'],
      );
    } catch (e) {
      print('Error parsing FamilyActivityEnrollmentDtos: $e');
      return FamilyActivityEnrollmentDtos();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['familyActivityEnrollmentId'] = this.familyActivityEnrollmentId;
    data['entityActivityId'] = this.entityActivityId;
    if (this.entityActivityDto != null) {
      data['entityActivityDto'] = this.entityActivityDto!.toJson();
    }
    data['familyId'] = this.familyId;
    return data;
  }
}

class EntityActivityDto {
  int? entityActivityId;
  int? unEntityId;
  int? activityId;
  Activity? activity;

  EntityActivityDto(
      {this.entityActivityId, this.unEntityId, this.activityId, this.activity});

  EntityActivityDto.fromJson(Map<String, dynamic> json) {
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
  ActivityType? activityType;
  String? imagePath;
  CommitteeDto? committy;
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
    activityType = activityTypeFromInt(json['activityType']);
    imagePath = json['imagePath'];
    committy = json['committy'] != null
        ? CommitteeDto.fromJson(json['committy'])
        : null;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'activityId': activityId,
      'englishName': englishName,
      'arabicName': arabicName,
      'englishDescription': englishDescription,
      'arabicDescription': arabicDescription,
      'activityType': activityType?.index, // Convert enum to int
      'imagePath': imagePath,
      'committy': committy?.toJson(),
    };
    return data;
  }
}

class CommitteeDto {
  int committeeId;
  String englishName;
  String arabicName;
  String englishDescription;
  String arabicDescription;

  CommitteeDto({
    required this.committeeId,
    required this.englishName,
    required this.arabicName,
    required this.englishDescription,
    required this.arabicDescription,
  });

  // Factory method to create CommitteeDto from JSON
  factory CommitteeDto.fromJson(Map<String, dynamic> json) {
    return CommitteeDto(
      committeeId: json['committeeId'],
      englishName: json['englishName'],
      arabicName: json['arabicName'],
      englishDescription: json['englishDescription'],
      arabicDescription: json['arabicDescription'],
    );
  }

  // Method to convert CommitteeDto to JSON map
  Map<String, dynamic> toJson() {
    return {
      'committeeId': committeeId,
      'englishName': englishName,
      'arabicName': arabicName,
      'englishDescription': englishDescription,
      'arabicDescription': arabicDescription,
    };
  }
}

enum ActivityType {
  Individual,
  Collective,
}

// Function to convert from int to enum
ActivityType activityTypeFromInt(int value) {
  switch (value) {
    case 0:
      return ActivityType.Individual;
    case 1:
      return ActivityType.Collective;
    default:
      throw ArgumentError('Unknown ActivityType value: $value');
  }
}

// Function to convert from enum to int
int activityTypeToInt(ActivityType type) {
  return type.index;
}

class FamilyEventEnrollmentDtos {
  int? familyEventEnrollmentId;
  FamilyRole? role;
  Double? rate;
  Status? status;
  int? familyId;
  int? currentEventId;
  CurrentEventDtos? currentEventDtos;

  FamilyEventEnrollmentDtos(
      {this.familyEventEnrollmentId,
      this.role,
      this.rate,
      this.status,
      this.familyId,
      this.currentEventId,
      this.currentEventDtos});

  factory FamilyEventEnrollmentDtos.fromJson(Map<String, dynamic> json) {
    try {
      return FamilyEventEnrollmentDtos(
        familyEventEnrollmentId: json['familyEventEnrollmentId'],
        role: familyRoleFromInt(json['role']), // Convert int to FamilyRole
        rate: json['rate']?.toDouble(), // Handle double conversion
        status: StatusExtension.fromIndex(
            json['status']), // Convert int to Status enum
        familyId: json['familyId'],
        currentEventId: json['currentEventId'],
        currentEventDtos: json['currentEventDtos'] != null
            ? CurrentEventDtos.fromJson(json['currentEventDtos'])
            : null,
      );
    } catch (e) {
      print('Error parsing FamilyEventEnrollmentDtos: $e');
      return FamilyEventEnrollmentDtos();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['familyEventEnrollmentId'] = this.familyEventEnrollmentId;
    data['rate'] = this.rate;
    data['status'] = this.status;
    data['familyId'] = this.familyId;
    data['currentEventId'] = this.currentEventId;
    if (this.currentEventDtos != null) {
      data['currentEventDtos'] = this.currentEventDtos!.toJson();
    }
    return data;
  }
}

enum FamilyRole {
  organizers,
  participants,
}

// Function to convert int to FamilyRole enum
FamilyRole familyRoleFromInt(int? value) {
  switch (value) {
    case 0:
      return FamilyRole.organizers;
    case 1:
      return FamilyRole.participants;
    default:
      throw ArgumentError('Unknown FamilyRole value: $value');
  }
}

class CurrentEventDtos {
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
  CurrentEventDtos({
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

  factory CurrentEventDtos.fromJson(Map<String, dynamic> json) {
    print(
        '----------------------------------------------------------Parsing CurrentEvent: $json');
    try {
      return CurrentEventDtos(
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
        startDate?.toIso8601String(); // Convert DateTime to ISO8601 string
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

class FamilySupervisorsDtos {
  FamilySupervisorEnrollmentDtos? familySupervisorEnrollmentDtos;
  FamilySupervisorsDto? familySupervisorsDto;

  FamilySupervisorsDtos(
      {this.familySupervisorEnrollmentDtos, this.familySupervisorsDto});

  FamilySupervisorsDtos.fromJson(Map<String, dynamic> json) {
    familySupervisorEnrollmentDtos =
        json['familySupervisorEnrollmentDtos'] != null
            ? new FamilySupervisorEnrollmentDtos.fromJson(
                json['familySupervisorEnrollmentDtos'])
            : null;
    familySupervisorsDto = json['familySupervisorsDto'] != null
        ? new FamilySupervisorsDto.fromJson(json['familySupervisorsDto'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.familySupervisorEnrollmentDtos != null) {
      data['familySupervisorEnrollmentDtos'] =
          this.familySupervisorEnrollmentDtos!.toJson();
    }
    if (this.familySupervisorsDto != null) {
      data['familySupervisorsDto'] = this.familySupervisorsDto!.toJson();
    }
    return data;
  }
}

class FamilySupervisorEnrollmentDtos {
  int? familyEnrollmentId;
  int? familyId;
  int? supervisorId;

  FamilySupervisorEnrollmentDtos(
      {this.familyEnrollmentId, this.familyId, this.supervisorId});

  FamilySupervisorEnrollmentDtos.fromJson(Map<String, dynamic> json) {
    familyEnrollmentId = json['familyEnrollmentId'];
    familyId = json['familyId'];
    supervisorId = json['supervisorId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['familyEnrollmentId'] = this.familyEnrollmentId;
    data['familyId'] = this.familyId;
    data['supervisorId'] = this.supervisorId;
    return data;
  }
}

class FamilySupervisorsDto {
  int? supervisorId;
  String? name;
  int? gender;
  String? nationalId;
  String? address;
  String? phoneNumber;
  int? role;

  FamilySupervisorsDto(
      {this.supervisorId,
      this.name,
      this.gender,
      this.nationalId,
      this.address,
      this.phoneNumber,
      this.role});

  FamilySupervisorsDto.fromJson(Map<String, dynamic> json) {
    supervisorId = json['supervisorId'];
    name = json['name'];
    gender = json['gender'];
    nationalId = json['nationalId'];
    address = json['address'];
    phoneNumber = json['phoneNumber'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['supervisorId'] = this.supervisorId;
    data['name'] = this.name;
    data['gender'] = this.gender;
    data['nationalId'] = this.nationalId;
    data['address'] = this.address;
    data['phoneNumber'] = this.phoneNumber;
    data['role'] = this.role;
    return data;
  }
}

class FamilyMembersDtos {
  FamilyEnrollmentDto? familyEnrollmentDto;
  StudentDto? studentDto;
  UnEntity? unEntityDto;
  City? cityDto;

  FamilyMembersDtos(
      {this.familyEnrollmentDto,
      this.studentDto,
      this.unEntityDto,
      this.cityDto});

  FamilyMembersDtos.fromJson(Map<String, dynamic> json) {
    familyEnrollmentDto = json['familyEnrollmentDto'] != null
        ? new FamilyEnrollmentDto.fromJson(json['familyEnrollmentDto'])
        : null;
    studentDto = json['studentDto'] != null
        ? new StudentDto.fromJson(json['studentDto'])
        : null;
    unEntityDto = json['unEntityDto'] != null
        ? new UnEntity.fromJson(json['unEntityDto'])
        : null;
    cityDto =
        json['cityDto'] != null ? new City.fromJson(json['cityDto']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.familyEnrollmentDto != null) {
      data['familyEnrollmentDto'] = this.familyEnrollmentDto!.toJson();
    }
    if (this.studentDto != null) {
      data['studentDto'] = this.studentDto!.toJson();
    }
    if (this.unEntityDto != null) {
      data['unEntityDto'] = this.unEntityDto!.toJson();
    }
    if (this.cityDto != null) {
      data['cityDto'] = this.cityDto!.toJson();
    }
    return data;
  }
}

class FamilyEnrollmentDto {
  int? familyEnrollmentId;
  int? role;
  int? familyId;
  int? userId;

  FamilyEnrollmentDto(
      {this.familyEnrollmentId, this.role, this.familyId, this.userId});

  FamilyEnrollmentDto.fromJson(Map<String, dynamic> json) {
    familyEnrollmentId = json['familyEnrollmentId'];
    role = json['role'];
    familyId = json['familyId'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['familyEnrollmentId'] = this.familyEnrollmentId;
    data['role'] = this.role;
    data['familyId'] = this.familyId;
    data['userId'] = this.userId;
    return data;
  }
}

class StudentDto {
  int? studentId;
  String? userId;
  String? email;
  String? userName;
  String? phoneNumber;
  String? firstName;
  String? lastName;
  String? birthDate;
  String? nationalId;
  int? gender;
  String? addressDetails;
  String? imagePath;
  UnEntity? unEntity;
  City? city;
  int? level;
  String? collegeDepartment;
  bool? hasDisability;
  int? disabilityType;

  StudentDto(
      {this.studentId,
      this.userId,
      this.email,
      this.userName,
      this.phoneNumber,
      this.firstName,
      this.lastName,
      this.birthDate,
      this.nationalId,
      this.gender,
      this.addressDetails,
      this.imagePath,
      this.unEntity,
      this.city,
      this.level,
      this.collegeDepartment,
      this.hasDisability,
      this.disabilityType});

  StudentDto.fromJson(Map<String, dynamic> json) {
    studentId = json['studentId'];
    userId = json['userId'];
    email = json['email'];
    userName = json['userName'];
    phoneNumber = json['phoneNumber'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    birthDate = json['birthDate'];
    nationalId = json['nationalId'];
    gender = json['gender'];
    addressDetails = json['addressDetails'];
    imagePath = json['imagePath'];
    unEntity = json['unEntity'] != null
        ? new UnEntity.fromJson(json['unEntity'])
        : null;
    city = json['city'] != null ? new City.fromJson(json['city']) : null;
    level = json['level'];
    collegeDepartment = json['collegeDepartment'];
    hasDisability = json['hasDisability'];
    disabilityType = json['disabilityType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['studentId'] = this.studentId;
    data['userId'] = this.userId;
    data['email'] = this.email;
    data['userName'] = this.userName;
    data['phoneNumber'] = this.phoneNumber;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['birthDate'] = this.birthDate;
    data['nationalId'] = this.nationalId;
    data['gender'] = this.gender;
    data['addressDetails'] = this.addressDetails;
    data['imagePath'] = this.imagePath;
    if (this.unEntity != null) {
      data['unEntity'] = this.unEntity!.toJson();
    }
    if (this.city != null) {
      data['city'] = this.city!.toJson();
    }
    data['level'] = this.level;
    data['collegeDepartment'] = this.collegeDepartment;
    data['hasDisability'] = this.hasDisability;
    data['disabilityType'] = this.disabilityType;
    return data;
  }
}

class UnEntity {
  int? unEntityId;
  String? englishEntityName;
  String? arabicEntityName;

  UnEntity({this.unEntityId, this.englishEntityName, this.arabicEntityName});

  UnEntity.fromJson(Map<String, dynamic> json) {
    unEntityId = json['unEntityId'];
    englishEntityName = json['englishEntityName'];
    arabicEntityName = json['arabicEntityName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unEntityId'] = this.unEntityId;
    data['englishEntityName'] = this.englishEntityName;
    data['arabicEntityName'] = this.arabicEntityName;
    return data;
  }
}

class City {
  int? id;
  int? governorateId;
  String? cityNameAr;
  String? cityNameEn;
  String? governorateNameAr;
  String? governorateNameEn;

  City(
      {this.id,
      this.governorateId,
      this.cityNameAr,
      this.cityNameEn,
      this.governorateNameAr,
      this.governorateNameEn});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    governorateId = json['governorate_id'];
    cityNameAr = json['city_name_ar'];
    cityNameEn = json['city_name_en'];
    governorateNameAr = json['governorate_name_ar'];
    governorateNameEn = json['governorate_name_en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['governorate_id'] = this.governorateId;
    data['city_name_ar'] = this.cityNameAr;
    data['city_name_en'] = this.cityNameEn;
    data['governorate_name_ar'] = this.governorateNameAr;
    data['governorate_name_en'] = this.governorateNameEn;
    return data;
  }
}

Future<GetFamilyWithDetailsDto> fetchFamilyDetails(int familyId) async {
  final storage = FlutterSecureStorage();
  String? token = await storage.read(key: 'access_token');

  if (token == null || token.isEmpty) {
    throw Exception('User is not authenticated');
  }

  final headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  String apiUrl =
      '$url/api/FamilyEndPoint/getFamily/$familyId'; // Replace with your actual API endpoint
  final response = await http.get(Uri.parse(apiUrl), headers: headers);

  if (response.statusCode == 200) {
    print(
        "------------------------------------------GetFamily function called");
    // Check if response body is not empty
    if (response.body.isNotEmpty) {
      // Parse JSON response
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print("---------------------------------------${jsonResponse}");
      return GetFamilyWithDetailsDto.fromJson(jsonResponse);
    } else {
      throw Exception('Empty response received');
    }
  } else {
    print(
        "------------------------------------------GetFamily function has error");
    // Error handling
    throw Exception('Failed to load family details');
  }
}
