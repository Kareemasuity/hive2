import 'package:flutter/material.dart';

class MemberListProvider with ChangeNotifier {
  List<String> list = [];
  void addMember(String memberName) {
    list.add(memberName);
    notifyListeners();
  }

  void removeMember(int index) {
    list.removeAt(index);
    notifyListeners();
  }
}
