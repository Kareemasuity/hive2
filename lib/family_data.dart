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
}

enum SuperVisorRole { leader, ViceLeader }

extension SuperVisorRoleExtension on SuperVisorRole {
  int toIndex() {
    return this.index;
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

// class Family {
//   List<Member> members;
//   String familyName;
//   String mission;
//   String vision;
//   String? imagePath;
//   String? filePath;
//   int familyRulesId;
//   int status;
//   List<CreateAndUpdateFamilyPlanDto> familyPlans;
//   List<FamilySupervisor> familySupervisors;

//   Family({
//     required this.familyName,
//     required this.mission,
//     required this.vision,
//     this.imagePath,
//     this.filePath,
//     required this.status,
//     required this.familyRulesId,
//     required this.members,
//     required this.familyPlans,
//     required this.familySupervisors,
//   });

//   Map<String, dynamic> toJson() => {
//         'name': familyName,
//         'familyMission': mission,
//         'familyVision': vision,
//         'imagePath': imagePath,
//         'filePath': filePath,
//         'status': status,
//         'familyRulesId': familyRulesId,
//         'familyEnrollmentDtos': members.map((e) => e.toJson()).toList(),
//         'familyPlanDtos': familyPlans.map((e) => e.toJson()).toList(),
//         'familySupervisorsDtos':
//             familySupervisors.map((e) => e.toJson()).toList(),
//       };
// }

class Member {
  String role;
  String userName;

  Member({
    required this.role,
    required this.userName,
  });

  Map<String, dynamic> toJson() {
    final json = {
      'role': role,
      'userName': userName,
    };
    print("Adding Supervisors : $json");
    return json;
  }
}

// class FamilyPlan {
//   String eventName;
//   String placeOfImplementation;
//   String startDate;
//   String endDate;

//   FamilyPlan({
//     required this.eventName,
//     required this.placeOfImplementation,
//     required this.startDate,
//     required this.endDate,
//   });

//   Map<String, dynamic> toJson() => {
//         'eventName': eventName,
//         'placeOfImplementation': placeOfImplementation,
//         'startDate': startDate,
//         'endDate': endDate,
//       };
// }

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
