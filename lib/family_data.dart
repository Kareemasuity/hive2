// ignore_for_file: unused_import

import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:hive/provider/member_list_provider.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum Status { Accepted, Rejected, Pending }

extension StatusExtension on Status {
  int toIndex() {
    switch (this) {
      case Status.Accepted:
        return 0;
      case Status.Rejected:
        return 1;
      case Status.Pending:
        return 2;
    }
  }

  static Status fromIndex(int index) {
    switch (index) {
      case 0:
        return Status.Accepted;
      case 1:
        return Status.Rejected;
      case 2:
        return Status.Pending;
      default:
        throw Exception('Invalid status index');
    }
  }

  static Status fromValue(dynamic value) {
    if (value is int) {
      return fromIndex(value);
    } else if (value is String) {
      switch (value.toLowerCase()) {
        case 'accepted':
          return Status.Accepted;
        case 'rejected':
          return Status.Rejected;
        case 'pending':
          return Status.Pending;
        default:
          throw Exception('Invalid status value');
      }
    } else {
      throw Exception('Invalid status type');
    }
  }
}

enum gender { Male, Female }

extension genderExtension on gender {
  Map<String, dynamic> toJson() {
    return {
      'index': this.index,
      'name': this.toString().split('.').last,
    };
  }

  int toIndex() {
    return this.index;
  }

  static gender fromJson(String json) {
    return gender.values.firstWhere(
      (e) => e.toString().split('.').last == json,
      orElse: () => gender.Male, // Default value or handle missing case
    );
  }

  static gender fromIndex(int index) {
    return gender.values[index];
  }
}

enum Role {
  FAMILY_COORDINATOR,
  DEPUTY_FAMILY_COORDINATOR,
  SPORTS_COMMITTEE_SECRETARY,
  SOCIAL_COMMITTEE_SECRETARY,
  CULTURAL_COMMITTEE_SECRETARY,
  TECHNICAL_COMMITTEE_SECRETARY,
  SCIENTIFIC_COMMITTEE_SECRETARY,
  EXPLORERS_COMMITTEE_SECRETARY,
  FAMILY_COMMITTEE_SECRETARY,
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

  initializeFiles(Map<String, dynamic> json) {}
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
    return {
      'name': name,
      'familyMission': familyMission,
      'familyVision': familyVision,
      'imagePath': imagePath,
      'deanApproval': deanApproval,
      'headApproval': headApproval,
      'viceHeadApproval': viceHeadApproval,
      'status': status.toIndex(),
      'familyRulesId': familyRulesId,
    };
  }

  Future<void> initializeFiles() async {
    imagePath = (await _fetchFile(imagePath as String?)) as File?;
    deanApproval = (await _fetchFile(deanApproval as String?)) as File?;
    headApproval = (await _fetchFile(headApproval as String?)) as File?;
    viceHeadApproval = (await _fetchFile(viceHeadApproval as String?)) as File?;
  }

  Future<String?> _fetchFile(String? base64Content) async {
    if (base64Content == null) return null;
    Uint8List fileBytes = base64Decode(base64Content);
    final tempDir = await getTemporaryDirectory();
    String fileName =
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.file';
    File file = File(fileName);
    await file.writeAsBytes(fileBytes);
    return file.path;
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
