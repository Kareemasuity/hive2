import 'package:flutter/material.dart';
import 'package:hive/family_data.dart';

class MemberListProvider with ChangeNotifier {
  List<FamilyEnrollmentEndPointDto> list = [];

  void addMember(FamilyEnrollmentEndPointDto member) {
    list.add(member);
    notifyListeners();
  }

  void removeMember(int index) {
    list.removeAt(index);
    notifyListeners();
  }

  void updateMember(int index, FamilyEnrollmentEndPointDto member) {
    list[index] = member;
    notifyListeners();
  }

  List<Map<String, dynamic>> toJson() {
    return list.map((member) => member.toJson()).toList();
  }
}
