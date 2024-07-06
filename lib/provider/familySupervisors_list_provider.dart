import 'package:flutter/foundation.dart';
import 'package:hive/family_data.dart';

class FamilySupervisorListProvider extends ChangeNotifier {
  List<CreateAndUpdateFamilySupervisorsDto> _list = [];

  List<CreateAndUpdateFamilySupervisorsDto> get list => _list;

  void addSupervisor(CreateAndUpdateFamilySupervisorsDto supervisor) {
    _list.add(supervisor);
    notifyListeners();
  }

  void removeSupervisor(CreateAndUpdateFamilySupervisorsDto supervisor) {
    _list.remove(supervisor);
    notifyListeners();
  }
}
