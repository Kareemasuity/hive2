// FamilyDto class
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

  FamilyActivityEnrollmentDtos.fromJson(Map<String, dynamic> json) {
    familyActivityEnrollmentId = json['familyActivityEnrollmentId'];
    entityActivityId = json['entityActivityId'];
    entityActivityDto = json['entityActivityDto'] != null
        ? new EntityActivityDto.fromJson(json['entityActivityDto'])
        : null;
    familyId = json['familyId'];
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

class FamilyEventEnrollmentDtos {
  int? familyEventEnrollmentId;
  Null? rate;
  int? status;
  int? familyId;
  int? currentEventId;
  CurrentEventDtos? currentEventDtos;

  FamilyEventEnrollmentDtos(
      {this.familyEventEnrollmentId,
      this.rate,
      this.status,
      this.familyId,
      this.currentEventId,
      this.currentEventDtos});

  FamilyEventEnrollmentDtos.fromJson(Map<String, dynamic> json) {
    familyEventEnrollmentId = json['familyEventEnrollmentId'];
    rate = json['rate'];
    status = json['status'];
    familyId = json['familyId'];
    currentEventId = json['currentEventId'];
    currentEventDtos = json['currentEventDtos'] != null
        ? new CurrentEventDtos.fromJson(json['currentEventDtos'])
        : null;
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

class CurrentEventDtos {
  int? currentEventId;
  int? eventStatus;
  String? startDate;
  String? endDate;
  String? formSubmissionDeadline;
  String? location;
  String? englishDescription;
  String? arabicDescription;
  int? activityId;
  int? eventId;

  CurrentEventDtos(
      {this.currentEventId,
      this.eventStatus,
      this.startDate,
      this.endDate,
      this.formSubmissionDeadline,
      this.location,
      this.englishDescription,
      this.arabicDescription,
      this.activityId,
      this.eventId});

  CurrentEventDtos.fromJson(Map<String, dynamic> json) {
    currentEventId = json['currentEventId'];
    eventStatus = json['eventStatus'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    formSubmissionDeadline = json['formSubmissionDeadline'];
    location = json['location'];
    englishDescription = json['englishDescription'];
    arabicDescription = json['arabicDescription'];
    activityId = json['activityId'];
    eventId = json['eventId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentEventId'] = this.currentEventId;
    data['eventStatus'] = this.eventStatus;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['formSubmissionDeadline'] = this.formSubmissionDeadline;
    data['location'] = this.location;
    data['englishDescription'] = this.englishDescription;
    data['arabicDescription'] = this.arabicDescription;
    data['activityId'] = this.activityId;
    data['eventId'] = this.eventId;
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
