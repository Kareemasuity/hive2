// New Class to handle the specific JSON response
import 'dart:convert';

import 'package:hive/family_data.dart';

class FamilyResponseDto {
  FamilyDto familyDto;
  FamilyEnrollmentDto familyEnrollmentDto;

  FamilyResponseDto({
    required this.familyDto,
    required this.familyEnrollmentDto,
  });

  factory FamilyResponseDto.fromJson(Map<String, dynamic> json) {
    return FamilyResponseDto(
      familyDto: FamilyDto.fromJson(json['familyDto']),
      familyEnrollmentDto:
          FamilyEnrollmentDto.fromJson(json['familyEnrollmentDto']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'familyDto': familyDto.toJson(),
      'familyEnrollmentDto': familyEnrollmentDto.toJson(),
    };
  }
}

// New Class for family details
class FamilyDto {
  int familyId;
  String name;
  String familyMission;
  String familyVision;
  String imagePath;
  String deanApproval;
  String headApproval;
  String viceHeadApproval;
  Status status;
  int familyRulesId;
  DateTime createdDate;

  FamilyDto({
    required this.familyId,
    required this.name,
    required this.familyMission,
    required this.familyVision,
    required this.imagePath,
    required this.deanApproval,
    required this.headApproval,
    required this.viceHeadApproval,
    required this.status,
    required this.familyRulesId,
    required this.createdDate,
  });

  factory FamilyDto.fromJson(Map<String, dynamic> json) {
    return FamilyDto(
      familyId: json['familyId'],
      name: json['name'],
      familyMission: json['familyMission'],
      familyVision: json['familyVision'],
      imagePath: json['imagePath'],
      deanApproval: json['deanApproval'],
      headApproval: json['headApproval'],
      viceHeadApproval: json['viceHeadApproval'],
      status: StatusExtension.fromIndex(json['status']),
      familyRulesId: json['familyRulesId'],
      createdDate: DateTime.parse(json['createdDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'familyId': familyId,
      'name': name,
      'familyMission': familyMission,
      'familyVision': familyVision,
      'imagePath': imagePath,
      'deanApproval': deanApproval,
      'headApproval': headApproval,
      'viceHeadApproval': viceHeadApproval,
      'status': status.toIndex(),
      'familyRulesId': familyRulesId,
      'createdDate': createdDate.toIso8601String(),
    };
  }
}

// New Class for enrollment details
class FamilyEnrollmentDto {
  int familyEnrollmentId;
  Role role;
  int familyId;
  int userId;

  FamilyEnrollmentDto({
    required this.familyEnrollmentId,
    required this.role,
    required this.familyId,
    required this.userId,
  });

  factory FamilyEnrollmentDto.fromJson(Map<String, dynamic> json) {
    return FamilyEnrollmentDto(
      familyEnrollmentId: json['familyEnrollmentId'],
      role: RoleExtension.fromIndex(json['role']),
      familyId: json['familyId'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'familyEnrollmentId': familyEnrollmentId,
      'role': role.toIndex(),
      'familyId': familyId,
      'userId': userId,
    };
  }
}

// Function to parse the JSON response

List<FamilyResponseDto> parseFamilyResponseDto(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<FamilyResponseDto>((json) => FamilyResponseDto.fromJson(json))
      .toList();
}
