import 'package:flutter/material.dart';
import 'package:hive/family_data.dart';

class FamilyPlanListProvider with ChangeNotifier {
  List<CreateAndUpdateFamilyPlanDto> _plans = [];

  List<CreateAndUpdateFamilyPlanDto> get plans => _plans;

  void addPlan(CreateAndUpdateFamilyPlanDto plan) {
    _plans.add(plan);
    notifyListeners();
  }

  void removePlan(int index) {
    _plans.removeAt(index);
    notifyListeners();
  }
}
