// ignore_for_file: unused_import

import 'dart:ffi';
import 'dart:io';

import 'package:hive/provider/member_list_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum Status { Accepted, Rejected, Pending }

extension StatusExtension on Status {
  int toIndex() {
    return this.index;
  }

  static Status fromIndex(int index) {
    return Status.values[index];
  }
}

enum gender { Male, Female }

extension genderExtension on gender {
  int toIndex() {
    return this.index;
  }

  static gender fromIndex(int index) {
    return gender.values[index];
  }
}

enum Role {
  familyRapporteur,
  SecretaryOfTheFamiliesCommittee,
  DeputyFamilyRapporteur,
  SecretaryOfTheSportsCommittee,
  SecretaryOfTheSocialCommittee,
  SecretaryOfTheCulturalCommittee,
  SecretaryOfTheTechnicalCommittee,
  SecretaryOfTheScientificCommittee,
  SecretaryOfTheMobileCommitte,
  Member
}

extension RoleExtension on Role {
  int toIndex() {
    return this.index;
  }

  static Role fromIndex(int index) {
    return Role.values[index];
  }
}

enum SuperVisorRole { leader, ViceLeader }

extension SuperVisorRoleExtension on SuperVisorRole {
  int toIndex() {
    return this.index;
  }

  static SuperVisorRole fromIndex(int index) {
    return SuperVisorRole.values[index];
  }
}

class AddingFamilyDto {
  CreateAndUpdateFamilyDto familyDto;
  List<FamilyEnrollmentEndPointDto> familyEnrollmentDtos;
  List<CreateAndUpdateFamilyPlanDto> familyPlanDtos;
  List<CreateAndUpdateFamilySupervisorsDto> familySupervisorsDtos;

  AddingFamilyDto({
    required this.familyDto,
    required this.familyEnrollmentDtos,
    required this.familyPlanDtos,
    required this.familySupervisorsDtos,
  });

  factory AddingFamilyDto.fromJson(Map<String, dynamic> json) {
    return AddingFamilyDto(
      familyDto: CreateAndUpdateFamilyDto.fromJson(json['familyDto']),
      familyEnrollmentDtos: (json['familyEnrollmentDtos'] as List<dynamic>)
          .map((e) =>
              FamilyEnrollmentEndPointDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      familyPlanDtos: (json['familyPlanDtos'] as List<dynamic>)
          .map((e) =>
              CreateAndUpdateFamilyPlanDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      familySupervisorsDtos: (json['familySupervisorsDtos'] as List<dynamic>)
          .map((e) => CreateAndUpdateFamilySupervisorsDto.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'familyDto': familyDto.toJson(),
      'familyEnrollmentDtos':
          familyEnrollmentDtos.map((e) => e.toJson()).toList(),
      'familyPlanDtos': familyPlanDtos.map((e) => e.toJson()).toList(),
      'familySupervisorsDtos':
          familySupervisorsDtos.map((e) => e.toJson()).toList(),
    };
    print('AddingFamilyDto JSON Payload: $json'); // Debug output
    return json;
  }
}

class CreateAndUpdateFamilyDto {
  String name;
  String familyMission;
  String familyVision;
  File? imagePath;
  File? deanApproval;
  File? headApproval;
  File? viceHeadApproval;
  Status status;
  int familyRulesId;

  CreateAndUpdateFamilyDto({
    required this.name,
    required this.familyMission,
    required this.familyVision,
    this.imagePath,
    this.deanApproval,
    this.headApproval,
    this.viceHeadApproval,
    required this.status,
    required this.familyRulesId,
  });

  factory CreateAndUpdateFamilyDto.fromJson(Map<String, dynamic> json) {
    return CreateAndUpdateFamilyDto(
      name: json['name'],
      familyMission: json['familyMission'],
      familyVision: json['familyVision'],
      imagePath: json['imagePath'],
      deanApproval: json['deanApproval'],
      headApproval: json['headApproval'],
      viceHeadApproval: json['viceHeadApproval'],
      status: StatusExtension.fromIndex(json['status']),
      familyRulesId: json['familyRulesId'],
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'name': name,
      'familyMission': familyMission,
      'familyVision': familyVision,
      'imagePath': _fileToBase64(imagePath),
      'deanApproval': _fileToBase64(deanApproval),
      'headApproval': _fileToBase64(headApproval),
      'viceHeadApproval': _fileToBase64(viceHeadApproval),
      'status': status.toIndex(),
      'familyRulesId': familyRulesId,
    };
    print('CreateAndUpdateFamilyPlanDto JSON Payload: $json');
    return json;
  }

  String? _fileToBase64(File? file) {
    if (file == null) return null;
    return base64Encode(file.readAsBytesSync());
  }
}

class FamilyEnrollmentEndPointDto {
  Role role;
  int familyId;
  String? userName;

  FamilyEnrollmentEndPointDto({
    required this.role,
    required this.familyId,
    this.userName,
  });
  factory FamilyEnrollmentEndPointDto.fromJson(Map<String, dynamic> json) {
    return FamilyEnrollmentEndPointDto(
      role: RoleExtension.fromIndex(json['role']),
      familyId: json['familyId'],
      userName: json['userName'],
    );
  }
  Map<String, dynamic> toJson() {
    final json = {
      'role': role.toIndex(),
      'familyId': familyId,
      'userName': userName,
    };
    print('Family enrollments  JSON Payload: $json');
    return json;
  }
}

class CreateAndUpdateFamilyPlanDto {
  int familyId = 0;
  String eventName;
  String placeOfImplementation;
  DateTime startDate;
  DateTime endDate;

  CreateAndUpdateFamilyPlanDto({
    required this.familyId,
    required this.eventName,
    required this.placeOfImplementation,
    required this.startDate,
    required this.endDate,
  });

  factory CreateAndUpdateFamilyPlanDto.fromJson(Map<String, dynamic> json) {
    return CreateAndUpdateFamilyPlanDto(
      familyId: json['familyId'],
      eventName: json['eventName'],
      placeOfImplementation: json['placeOfImplementation'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'familyId': familyId,
      'eventName': eventName,
      'placeOfImplementation': placeOfImplementation,
      'startDate': _formatDate(startDate),
      'endDate': _formatDate(endDate),
    };
    print('AddingFamilyDto JSON Payload: $json'); // Debug output
    return json;
  }

  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat("yyyy-MM-ddTHH:mm:ss");
    return formatter.format(date);
  }
}

class CreateAndUpdateFamilySupervisorsDto {
  String name;
  gender Gender;
  String nationalId;
  String address;
  String phoneNumber;
  SuperVisorRole role;

  CreateAndUpdateFamilySupervisorsDto({
    required this.name,
    required this.Gender,
    required this.nationalId,
    required this.address,
    required this.phoneNumber,
    required this.role,
  });
  factory CreateAndUpdateFamilySupervisorsDto.fromJson(
      Map<String, dynamic> json) {
    return CreateAndUpdateFamilySupervisorsDto(
      name: json['name'],
      Gender: genderExtension.fromIndex(json['gender']),
      nationalId: json['nationalId'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      role: SuperVisorRoleExtension.fromIndex(json['role']),
    );
  }
  Map<String, dynamic> toJson() {
    final json = {
      'name': name,
      'gender': Gender.toIndex(),
      'nationalId': nationalId,
      'address': address,
      'phoneNumber': phoneNumber,
      'role': role.toIndex(),
    };
    print('AddingFamily Supervisors JSON Payload: $json'); // Debug output
    return json;
  }
}

class FamilySupervisor {
  String name;
  String gender;
  String nationalId;
  String address;
  String phoneNumber;
  String role;

  FamilySupervisor({
    required this.name,
    required this.gender,
    required this.nationalId,
    required this.address,
    required this.phoneNumber,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    final json = {
      'name': name,
      'gender': gender,
      'nationalId': nationalId,
      'address': address,
      'phoneNumber': phoneNumber,
      'role': role,
    };
    print("Adding Supervisors : $json");
    return json;
  }
}
