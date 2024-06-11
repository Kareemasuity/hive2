// ignore_for_file: unnecessary_import, unused_import

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/families_info.dart';
import 'package:hive/models/member_list_model.dart';
import 'package:hive/provider/member_list_provider.dart';
import 'package:provider/provider.dart';

class FamiliesForm extends StatefulWidget {
  const FamiliesForm({super.key});

  @override
  State<FamiliesForm> createState() => _FamiliesFormState();
}

class _FamiliesFormState extends State<FamiliesForm> {
  int currentStep = 0;
  int counter = 0;
  late MemberList memberList;
  bool get isFirstStep => currentStep == 0;
  bool get isLastStep => currentStep == steps().length - 1;

  var familyMembers;
  var FMemberName = TextEditingController();
  late GlobalKey<FormState> _globalKey;

  final FamilyName = TextEditingController();
  final FMission = TextEditingController();
  final FVision = TextEditingController();
  final FamilyRapporteur = TextEditingController();

  final leaderName = TextEditingController();
  final leaderID = TextEditingController();
  final leaderPhone = TextEditingController();
  final leaderAddress = TextEditingController();

  final VleaderName = TextEditingController();
  final VleaderID = TextEditingController();
  final VleaderPhone = TextEditingController();
  final VleaderAddress = TextEditingController();

  @override
  void initState() {
    super.initState();
    memberList = MemberList([]);
    familyMembers = Provider.of<MemberListProvider>(context, listen: false);
    FMemberName = TextEditingController();
    _globalKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    FMemberName.dispose();
    super.dispose();
  }

  void _showFamilyInfoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Family Information"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Family Name: ${FamilyName.text}"),
                Text("Mission: ${FMission.text}"),
                Text("Vision: ${FVision.text}"),
                Text("Family Rapporteur: ${FamilyRapporteur.text}"),
                Text("Leader Name: ${leaderName.text}"),
                Text("Leader ID: ${leaderID.text}"),
                Text("Leader Phone: ${leaderPhone.text}"),
                Text("Leader Address: ${leaderAddress.text}"),
                Text("Vice Leader Name: ${VleaderName.text}"),
                Text("Vice Leader ID: ${VleaderID.text}"),
                Text("Vice Leader Phone: ${VleaderPhone.text}"),
                Text("Vice Leader Address: ${VleaderAddress.text}"),
                Consumer<MemberListProvider>(
                  builder: (context, provider, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: provider.list
                          .map((member) => Text("Member: $member"))
                          .toList(),
                    );
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                // Handle the submit action here
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Back to edit'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showMemberAddedToast() {
    Fluttertoast.showToast(
      msg: "Member added",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Families"),
      ),
      body: Stepper(
        steps: steps(),
        currentStep: currentStep,
        onStepContinue: () {
          if (isLastStep) {
            _showFamilyInfoDialog();
          } else {
            setState(() {
              currentStep += 1;
            });
          }
        },
        onStepCancel: isFirstStep
            ? null
            : () => setState(() {
                  currentStep -= 1;
                }),
        onStepTapped: (step) => setState(() => currentStep = step),
      ),
    );
  }

  List<Step> steps() {
    return [
      Step(
          title: Text("Family"),
          content: Column(
            children: [
              TextFormField(
                controller: FamilyName,
                decoration: InputDecoration(labelText: ' name'),
                keyboardType: TextInputType.name,
              ),
              TextFormField(
                controller: FMission,
                decoration: InputDecoration(labelText: ' mission'),
                keyboardType: TextInputType.multiline,
              ),
              TextFormField(
                controller: FVision,
                decoration: InputDecoration(labelText: 'vision'),
                keyboardType: TextInputType.multiline,
              ),
            ],
          ),
          isActive: currentStep >= 0),
      Step(
          title: Text("Leader"),
          content: Column(
            children: [
              TextFormField(
                controller: leaderName,
                decoration: InputDecoration(labelText: ' name'),
                keyboardType: TextInputType.name,
              ),
              TextFormField(
                controller: leaderID,
                decoration: InputDecoration(labelText: ' ID'),
                keyboardType: TextInputType.multiline,
              ),
              TextFormField(
                controller: leaderPhone,
                decoration: InputDecoration(labelText: 'phone number'),
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: leaderAddress,
                decoration: InputDecoration(labelText: 'Address'),
                keyboardType: TextInputType.multiline,
              ),
            ],
          ),
          isActive: currentStep >= 0),
      Step(
          title: Text("Vice Leader"),
          content: Column(
            children: [
              TextFormField(
                controller: VleaderName,
                decoration: InputDecoration(
                  labelText: ' name',
                ),
                keyboardType: TextInputType.name,
              ),
              TextFormField(
                controller: VleaderID,
                decoration: InputDecoration(labelText: ' ID'),
                keyboardType: TextInputType.multiline,
              ),
              TextFormField(
                controller: VleaderPhone,
                decoration: InputDecoration(labelText: 'phone number'),
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: VleaderAddress,
                decoration: InputDecoration(labelText: 'Address'),
                keyboardType: TextInputType.multiline,
              ),
            ],
          ),
          isActive: currentStep >= 1),
      Step(
          title: Text("Organizational Structure"),
          content: Column(
            children: [
              TextFormField(
                controller: FamilyRapporteur,
                decoration:
                    InputDecoration(labelText: 'Family Rapporteur Name'),
                keyboardType: TextInputType.multiline,
              ),
              TextFormField(
                controller: FamilyRapporteur,
                decoration:
                    InputDecoration(labelText: 'Family Rapporteur Name'),
                keyboardType: TextInputType.multiline,
              ),
            ],
          ),
          isActive: currentStep >= 2),
      Step(
        title: Text("Add members"),
        content: ChangeNotifierProvider<MemberListProvider>(
          create: (context) => MemberListProvider(),
          child: Column(
            children: [
              Form(
                key: _globalKey,
                child: TextFormField(
                  controller: FMemberName,
                  onSaved: (newValue) => familyMembers.addMember(newValue),
                  validator: (value) {
                    if (value!.length > 0) {
                      return null;
                    } else {
                      return "Add member name";
                    }
                  },
                ),
              ),
              SizedBox(
                height: 5,
              ),
              ElevatedButton(
                child: Text("Add members"),
                onPressed: () {
                  if (_globalKey.currentState!.validate()) {
                    // familyMembers.addMember(FMemberName.text);
                    _globalKey.currentState!.save();
                    _showMemberAddedToast();
                    FMemberName.clear(); // Clear the text field
                  }
                },
              ),
            ],
          ),
        ),
        isActive: currentStep >= 3,
      ),
      Step(
        title: Text("View Final Family Information"),
        content: SizedBox(
          height: 2,
        ),
        isActive: currentStep >= 4,
      )
    ];
  }
}
