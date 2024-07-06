import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/family_data.dart';
import 'package:http/http.dart' as http;
import 'package:hive/data.dart';

class RejectedFamily {
  FamilyDto? familyDto;
  List<FamilyMembersDtos>? familyMembersDtos;
  List<FamilyPlanDtos>? familyPlanDtos;
  List<FamilySupervisorsDtos>? familySupervisorsDtos;

  RejectedFamily(
      {this.familyDto,
      this.familyMembersDtos,
      this.familyPlanDtos,
      this.familySupervisorsDtos});

  RejectedFamily.fromJson(Map<String, dynamic> json) {
    familyDto = json['familyDto'] != null
        ? new FamilyDto.fromJson(json['familyDto'])
        : null;
    if (json['familyMembersDtos'] != null) {
      familyMembersDtos = <FamilyMembersDtos>[];
      json['familyMembersDtos'].forEach((v) {
        familyMembersDtos!.add(new FamilyMembersDtos.fromJson(v));
      });
    }
    if (json['familyPlanDtos'] != null) {
      familyPlanDtos = <FamilyPlanDtos>[];
      json['familyPlanDtos'].forEach((v) {
        familyPlanDtos!.add(new FamilyPlanDtos.fromJson(v));
      });
    }
    if (json['familySupervisorsDtos'] != null) {
      familySupervisorsDtos = <FamilySupervisorsDtos>[];
      json['familySupervisorsDtos'].forEach((v) {
        familySupervisorsDtos!.add(new FamilySupervisorsDtos.fromJson(v));
      });
      print("------------------------------------$familySupervisorsDtos");
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.familyDto != null) {
      data['familyDto'] = this.familyDto!.toJson();
    }
    if (this.familyMembersDtos != null) {
      data['familyMembersDtos'] =
          this.familyMembersDtos!.map((v) => v.toJson()).toList();
    }
    if (this.familyPlanDtos != null) {
      data['familyPlanDtos'] =
          this.familyPlanDtos!.map((v) => v.toJson()).toList();
    }
    if (this.familySupervisorsDtos != null) {
      data['familySupervisorsDtos'] =
          this.familySupervisorsDtos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FamilyDto {
  int? familyId;
  String? name;
  String? familyMission;
  String? familyVision;
  Null? imagePath;
  Null? deanApproval;
  Null? headApproval;
  Null? viceHeadApproval;
  Status? status;
  String? adminMessage;
  int? familyRulesId;

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
      this.adminMessage,
      this.familyRulesId});

  FamilyDto.fromJson(Map<String, dynamic> json) {
    familyId = json['familyId'];
    name = json['name'];
    familyMission = json['familyMission'];
    familyVision = json['familyVision'];
    imagePath = json['imagePath'];
    deanApproval = json['deanApproval'];
    headApproval = json['headApproval'];
    viceHeadApproval = json['viceHeadApproval'];
    status = StatusExtension.fromIndex(json['status']);
    adminMessage = json['adminMessage'];
    familyRulesId = json['familyRulesId'];
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
    data['status'] = this.status!.toIndex();
    data['adminMessage'] = this.adminMessage;
    data['familyRulesId'] = this.familyRulesId;
    return data;
  }
}

class FamilyMembersDtos {
  FamilyEnrollmentDto? familyEnrollmentDto;
  String? userName;

  FamilyMembersDtos({this.familyEnrollmentDto, this.userName});

  FamilyMembersDtos.fromJson(Map<String, dynamic> json) {
    familyEnrollmentDto = json['familyEnrollmentDto'] != null
        ? new FamilyEnrollmentDto.fromJson(json['familyEnrollmentDto'])
        : null;
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.familyEnrollmentDto != null) {
      data['familyEnrollmentDto'] = this.familyEnrollmentDto!.toJson();
    }
    data['userName'] = this.userName;
    return data;
  }
}

class FamilyEnrollmentDto {
  int? familyEnrollmentId;
  Role? role;
  int? familyId;
  int? userId;

  FamilyEnrollmentDto(
      {this.familyEnrollmentId, this.role, this.familyId, this.userId});

  FamilyEnrollmentDto.fromJson(Map<String, dynamic> json) {
    familyEnrollmentId = json['familyEnrollmentId'];
    role = json['role'] != null ? RoleExtension.fromIndex(json['role']) : null;
    familyId = json['familyId'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['familyEnrollmentId'] = this.familyEnrollmentId;
    data['role'] = this.role != null ? this.role!.toIndex() : null;
    data['familyId'] = this.familyId;
    data['userId'] = this.userId;
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
  gender? Gender;
  String? nationalId;
  String? address;
  String? phoneNumber;
  SuperVisorRole? role;

  FamilySupervisorsDto(
      {this.supervisorId,
      this.name,
      this.Gender,
      this.nationalId,
      this.address,
      this.phoneNumber,
      this.role});

  FamilySupervisorsDto.fromJson(Map<String, dynamic> json) {
    supervisorId = json['supervisorId'];
    name = json['name'];
    Gender = json['Gender'] != null
        ? genderExtension.fromIndex(json['gender'])
        : null;
    nationalId = json['nationalId'];
    address = json['address'];
    phoneNumber = json['phoneNumber'];
    role = json['role'] != null
        ? SuperVisorRoleExtension.fromIndex(json['role'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['supervisorId'] = this.supervisorId;
    data['name'] = this.name;
    data['Gender'] = this.Gender != null ? Gender?.toIndex() : null;
    data['nationalId'] = this.nationalId;
    data['address'] = this.address;
    data['phoneNumber'] = this.phoneNumber;
    data['role'] = this.role != null ? role?.toIndex() : null;
    return data;
  }
}

Future<RejectedFamily> fetchRejectedFamily(int familyId) async {
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
      '$url/api/FamilyEndPoint/getRejectedFamily/$familyId'; // Replace with your actual API endpoint
  final response = await http.get(Uri.parse(apiUrl), headers: headers);

  if (response.statusCode == 200) {
    print(
        '------------------------------------------getRejectedFamily function called');
    // Check if response body is not empty
    if (response.body.isNotEmpty) {
      // Parse JSON response
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return RejectedFamily.fromJson(jsonResponse);
    } else {
      throw Exception('Empty response received');
    }
  } else {
    print(
        '------------------------------------------getRejectedFamily function has error');
    // Error handling
    throw Exception('Failed to load rejected family details');
  }
}
