// ignore_for_file: unnecessary_import, unused_import

import 'dart:io';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/provider/familySupervisors_list_provider.dart';
import 'package:hive/provider/familyplan_list_provider.dart';
import 'package:hive/provider/member_list_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive/family_data.dart';
import 'package:intl/intl.dart';

typedef FileSetter = void Function(File file);

class FamiliesForm extends StatefulWidget {
  const FamiliesForm({super.key});

  @override
  State<FamiliesForm> createState() => _FamiliesFormState();
}

class _FamiliesFormState extends State<FamiliesForm> {
  int currentStep = 0;
  int counter = 0;
  late MemberListProvider memberListProvider;
  late FamilyPlanListProvider familyPlanListProvider;
  late FamilySupervisorListProvider familySupervisorListProvider;
  gender _leaderGender = gender.Male;
  gender _viceleaderGender = gender.Male;
  var familyDTo;

  late File _imageFile;
  late File deanApprovalFile;
  late File headApprovalFile;
  late File viceHeadApprovalFile;
  bool get isFirstStep => currentStep == 0;
  bool get isLastStep => currentStep == steps().length - 1;
  DateTime PlanStartDate = DateTime.now();
  DateTime PlanEndDate = DateTime.now();
  var familyMembers;
  var FMemberName = TextEditingController();
  late GlobalKey<FormState> _globalKey;
  late GlobalKey<FormState> _PlanformKey;
  late GlobalKey<FormState> _leaderFormKey;
  late GlobalKey<FormState> _viceleaderFormKey;
  late GlobalKey<FormState> _orgStructureFormKey;

  final FamilyName = TextEditingController();
  final FMission = TextEditingController();
  final FVision = TextEditingController();
  final FamilyRapporteur = TextEditingController();
  final DeputyFamilyRapporteur = TextEditingController();
  final SecSportsCommitteeName = TextEditingController();
  final SecSocialCommitteeName = TextEditingController();
  final SecCulturalCommitteeName = TextEditingController();
  final SecTechnicalCommitteeName = TextEditingController();
  final SecScientificCommitteeName = TextEditingController();
  final SecFamiliesCommitteeName = TextEditingController();
  final SecMobileCommitteeName = TextEditingController();

  final FamilyPlanName = TextEditingController();
  final FamilyPlanPlaceOfEmp = TextEditingController();

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

    familyDTo;
    familyPlanListProvider = FamilyPlanListProvider();
    memberListProvider = MemberListProvider();
    familySupervisorListProvider = FamilySupervisorListProvider();
    FMemberName = TextEditingController();
    _globalKey = GlobalKey<FormState>();
    _PlanformKey = GlobalKey<FormState>();
    _leaderFormKey = GlobalKey<FormState>();
    _orgStructureFormKey = GlobalKey<FormState>();
    _viceleaderFormKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    FMemberName.dispose();
    FamilyName.dispose();
    FMission.dispose();
    FVision.dispose();
    FamilyRapporteur.dispose();
    leaderName.dispose();
    leaderID.dispose();
    leaderPhone.dispose();
    leaderAddress.dispose();
    VleaderName.dispose();
    VleaderID.dispose();
    VleaderPhone.dispose();
    VleaderAddress.dispose();
    DeputyFamilyRapporteur.dispose();
    SecSportsCommitteeName.dispose();
    SecSocialCommitteeName.dispose();
    SecCulturalCommitteeName.dispose();
    SecTechnicalCommitteeName.dispose();
    SecScientificCommitteeName.dispose();
    SecFamiliesCommitteeName.dispose();
    SecMobileCommitteeName.dispose();
    super.dispose();
  }

  void _showDatePicker(void Function(DateTime) onDateSelected) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    ).then((value) {
      if (value != null) {
        setState(() {
          onDateSelected(value);
        });
      }
    });
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _pickFile(FileSetter setter) async {
    final result = await FilePicker.platform.pickFiles();
    setState(() {
      if (result != null && result.files.single.path != null) {
        setter(File(result.files.single.path!));
      } else {
        print('No file selected.');
      }
    });
  }

  void setDeanApprovalFile(File file) {
    deanApprovalFile = file;
  }

  void setHeadApprovalFile(File file) {
    headApprovalFile = file;
  }

  void setViceHeadApprovalFile(File file) {
    viceHeadApprovalFile = file;
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
                Text("Leader Gender: ${_leaderGender ?? 'Not specified'}"),
                Text("Vice Leader Name: ${VleaderName.text}"),
                Text("Vice Leader ID: ${VleaderID.text}"),
                Text("Vice Leader Phone: ${VleaderPhone.text}"),
                Text("Vice Leader Address: ${VleaderAddress.text}"),
                Text(
                    "Vice Leader Gender: ${_viceleaderGender ?? 'Not specified'}"),
                Text(
                    "Vice Family Rapporteur Name: ${DeputyFamilyRapporteur.text}"),
                Text(
                    "Secertary of the Sports Committee Name: ${SecSportsCommitteeName.text}"),
                Text(
                    "Secertary of the Social Committee Name: ${SecSocialCommitteeName.text}"),
                Text(
                    "Secertary of the Cultural Committee Name: ${SecCulturalCommitteeName.text}"),
                Text(
                    "Secertary of the Technical Committee Name: ${SecTechnicalCommitteeName.text}"),
                Text(
                    "Secertary of the Scientific Committee: ${SecScientificCommitteeName.text}"),
                Text(
                    "Secertary of the Mobile Committee: ${SecMobileCommitteeName.text}"),
                Text(
                    "Secertary of the Families Committee: ${SecFamiliesCommitteeName.text}"),
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
                _submitForm();
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

  void _showMemberAddedToast(String a) {
    Fluttertoast.showToast(
      msg: "$a added",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> _submitForm() async {
    final memberListProvider = context.read<MemberListProvider>();
    final familyPlanListProvider = context.read<FamilyPlanListProvider>();
    final familySupervisorListProvider =
        context.read<FamilySupervisorListProvider>();
    final Family = AddingFamilyDto(
        familyDto: familyDTo,
        familyEnrollmentDtos: memberListProvider.list,
        familyPlanDtos: familyPlanListProvider.plans,
        familySupervisorsDtos: familySupervisorListProvider.list);

    try {
      print('Sending request to submit family data...');
      final response = await http.post(
        Uri.parse('https://10.0.2.2:7147/api/FamilyEndPoint/AddingFamily'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(Family.toJson()),
      );
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Form submitted successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else if (response.statusCode == 400) {
        final responseData = jsonDecode(response.body);
        print('Error: ${responseData.toString()}');

        // Extract and display validation errors
        if (responseData.containsKey('errors')) {
          Map<String, dynamic> errors = responseData['errors'];
          List<String> errorMessages = [];

          errors.forEach((key, value) {
            if (value is List) {
              errorMessages.addAll(value.map((e) => '$key: $e').toList());
            } else {
              errorMessages.add('$key: $value');
            }
          });

          // Display error messages to the user
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Validation Errors'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: errorMessages.map((error) => Text(error)).toList(),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        final errorResponse = jsonDecode(response.body);
        print('Failed to submit family form: ${response.statusCode}');
        print("Error response: $errorResponse"); // Debug statement
        Fluttertoast.showToast(
          msg: "Error: ${errorResponse['message']}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print("Exception occurred: $e"); // Debug statement
      Fluttertoast.showToast(
        msg: "Failed to submit form",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MemberListProvider()),
        ChangeNotifierProvider(create: (_) => FamilyPlanListProvider()),
        ChangeNotifierProvider(
            create: (context) => FamilySupervisorListProvider()),
      ],
      child: Scaffold(
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
                decoration: InputDecoration(labelText: 'Family Name'),
                keyboardType: TextInputType.name,
              ),
              TextFormField(
                controller: FMission,
                decoration: InputDecoration(labelText: 'Mission'),
                keyboardType: TextInputType.multiline,
              ),
              TextFormField(
                controller: FVision,
                decoration: InputDecoration(labelText: 'Vision'),
                keyboardType: TextInputType.multiline,
              ),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              ElevatedButton(
                onPressed: () => _pickFile(setDeanApprovalFile),
                child: Text('Pick Dean Approval'),
              ),
              ElevatedButton(
                onPressed: () => _pickFile(setHeadApprovalFile),
                child: Text('Pick Head Approval'),
              ),
              ElevatedButton(
                onPressed: () => _pickFile(setViceHeadApprovalFile),
                child: Text('Pick Vice Head Approval'),
              ),
              // to upload file 3
              TextButton(
                  onPressed: () {
                    setState(() {
                      familyDTo = CreateAndUpdateFamilyDto(
                          familyMission: FMission.text,
                          familyVision: FVision.text,
                          name: FamilyName.text,
                          imagePath: _imageFile,
                          deanApproval: deanApprovalFile,
                          headApproval: headApprovalFile,
                          viceHeadApproval: viceHeadApprovalFile,
                          familyRulesId: 0,
                          status: Status.Accepted);
                    });

                    Fluttertoast.showToast(
                      msg: "Saved",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  },
                  child: Text("save"))
            ],
          ),
          isActive: currentStep >= 0),
      Step(
          title: Text("Leader"),
          content: Form(
            key: _leaderFormKey,
            child: Column(
              children: [
                TextFormField(
                  controller: leaderName,
                  decoration: InputDecoration(labelText: 'Leader Name'),
                  keyboardType: TextInputType.name,
                ),
                TextFormField(
                  controller: leaderID,
                  decoration: InputDecoration(labelText: 'Leader ID'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: leaderPhone,
                  decoration: InputDecoration(labelText: 'Leader Phone Number'),
                  keyboardType: TextInputType.phone,
                ),
                TextFormField(
                  controller: leaderAddress,
                  decoration: InputDecoration(labelText: 'Leader Address'),
                  keyboardType: TextInputType.text,
                ),
                ListTile(
                  title: const Text('Male'),
                  leading: Radio<gender>(
                    value: gender.Male,
                    groupValue: _leaderGender,
                    onChanged: (gender? value) {
                      setState(() {
                        _leaderGender = value!;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Female'),
                  leading: Radio<gender>(
                    value: gender.Female,
                    groupValue: _leaderGender,
                    onChanged: (gender? value) {
                      setState(() {
                        _leaderGender = value!;
                      });
                    },
                  ),
                ),
                TextButton(
                    onPressed: () {
                      if (_leaderFormKey.currentState!.validate()) {
                        CreateAndUpdateFamilySupervisorsDto leader =
                            CreateAndUpdateFamilySupervisorsDto(
                                name: leaderName.text,
                                Gender: _leaderGender,
                                nationalId: leaderID.text,
                                address: leaderAddress.text,
                                phoneNumber: leaderPhone.text,
                                role: SuperVisorRole.leader);
                        context
                            .read<FamilySupervisorListProvider>()
                            .addSupervisor(leader);
                        _viceleaderFormKey.currentState!.save();
                        Fluttertoast.showToast(
                          msg: "Saved",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    },
                    child: Text("save"))
              ],
            ),
          ),
          isActive: currentStep >= 0),
      Step(
          title: Text("Vice Leader"),
          content: Form(
            key: _viceleaderFormKey,
            child: Column(
              children: [
                TextFormField(
                  controller: VleaderName,
                  decoration: InputDecoration(labelText: 'Vice Leader Name'),
                  keyboardType: TextInputType.name,
                ),
                TextFormField(
                  controller: VleaderID,
                  decoration: InputDecoration(labelText: 'Vice Leader ID'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: VleaderPhone,
                  decoration:
                      InputDecoration(labelText: 'Vice Leader Phone Number'),
                  keyboardType: TextInputType.phone,
                ),
                TextFormField(
                  controller: VleaderAddress,
                  decoration: InputDecoration(labelText: 'Vice Leader Address'),
                  keyboardType: TextInputType.text,
                ),
                ListTile(
                  title: const Text('Male'),
                  leading: Radio<gender>(
                    value: gender.Male,
                    groupValue: _viceleaderGender,
                    onChanged: (gender? value) {
                      setState(() {
                        _viceleaderGender = value!;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Female'),
                  leading: Radio<gender>(
                    value: gender.Female,
                    groupValue: _viceleaderGender,
                    onChanged: (gender? value) {
                      setState(() {
                        _viceleaderGender = value!;
                      });
                    },
                  ),
                ),
                TextButton(
                    onPressed: () {
                      if (_viceleaderFormKey.currentState!.validate()) {
                        CreateAndUpdateFamilySupervisorsDto viceleader =
                            CreateAndUpdateFamilySupervisorsDto(
                                name: VleaderName.text,
                                Gender: _viceleaderGender,
                                nationalId: VleaderID.text,
                                address: VleaderAddress.text,
                                phoneNumber: VleaderPhone.text,
                                role: SuperVisorRole.ViceLeader);

                        context
                            .read<FamilySupervisorListProvider>()
                            .addSupervisor(viceleader);
                        _viceleaderFormKey.currentState!.save();
                        Fluttertoast.showToast(
                          msg: "Saved",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    },
                    child: Text("save"))
              ],
            ),
          ),
          isActive: currentStep >= 1),
      Step(
          title: Text("Organizational Structure"),
          content: Form(
            key: _orgStructureFormKey,
            child: Column(
              children: [
                TextFormField(
                  controller: FamilyRapporteur,
                  decoration:
                      InputDecoration(labelText: 'Family Rapporteur Name'),
                  keyboardType: TextInputType.name,
                ),
                TextFormField(
                  controller: DeputyFamilyRapporteur,
                  onSaved: (newValue) {
                    FamilyEnrollmentEndPointDto member2 =
                        FamilyEnrollmentEndPointDto(
                            familyId: 1,
                            role: Role.DeputyFamilyRapporteur,
                            userName: FamilyRapporteur.text);
                    context.read<MemberListProvider>().addMember(member2);
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      labelText: 'Deputy Family Rapporteur Name'),
                  keyboardType: TextInputType.name,
                ),
                TextFormField(
                  controller: SecSportsCommitteeName,
                  decoration: InputDecoration(
                      labelText: 'Secertary of the Sports Committee Name'),
                  keyboardType: TextInputType.name,
                ),
                TextFormField(
                  controller: SecSocialCommitteeName,
                  onSaved: (newValue) {
                    FamilyEnrollmentEndPointDto member =
                        FamilyEnrollmentEndPointDto(
                            familyId: 1,
                            role: Role.SecretaryOfTheSocialCommittee,
                            userName: SecSocialCommitteeName.text);
                    context.read<MemberListProvider>().addMember(member);
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      labelText: 'Secertary of the Social Committee Name'),
                  keyboardType: TextInputType.name,
                ),
                TextFormField(
                  controller: SecCulturalCommitteeName,
                  onSaved: (newValue) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      labelText: 'Secertary of the Cultural Committee Name'),
                  keyboardType: TextInputType.name,
                ),
                TextFormField(
                  controller: SecTechnicalCommitteeName,
                  onSaved: (newValue) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      labelText: 'Secertary of the Technical Committee Name'),
                  keyboardType: TextInputType.name,
                ),
                TextFormField(
                  controller: SecScientificCommitteeName,
                  onSaved: (newValue) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      labelText: 'Secertary of the Scientific Committee Name'),
                  keyboardType: TextInputType.name,
                ),
                TextFormField(
                  controller: SecFamiliesCommitteeName,
                  onSaved: (newValue) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      labelText: 'Secertary of the Families Committee Name'),
                  keyboardType: TextInputType.name,
                ),
                TextFormField(
                  controller: SecMobileCommitteeName,
                  decoration: InputDecoration(
                      labelText: 'Secertary of the Mobile Committee Name'),
                  onSaved: (newValue) {
                    setState(() {});
                  },
                  keyboardType: TextInputType.name,
                ),
                ElevatedButton(
                  child: Text("Add"),
                  onPressed: () {
                    if (_orgStructureFormKey.currentState!.validate()) {
                      FamilyEnrollmentEndPointDto member1 =
                          FamilyEnrollmentEndPointDto(
                              familyId: 1,
                              role: Role.familyRapporteur,
                              userName: FamilyRapporteur.text);
                      context.read<MemberListProvider>().addMember(member1);
                      FamilyEnrollmentEndPointDto member2 =
                          FamilyEnrollmentEndPointDto(
                              familyId: 1,
                              role: Role.DeputyFamilyRapporteur,
                              userName: FamilyRapporteur.text);
                      context.read<MemberListProvider>().addMember(member2);
                      FamilyEnrollmentEndPointDto member3 =
                          FamilyEnrollmentEndPointDto(
                              familyId: 1,
                              role: Role.SecretaryOfTheSportsCommittee,
                              userName: SecSportsCommitteeName.text);
                      context.read<MemberListProvider>().addMember(member3);
                      FamilyEnrollmentEndPointDto member4 =
                          FamilyEnrollmentEndPointDto(
                              familyId: 1,
                              role: Role.SecretaryOfTheSocialCommittee,
                              userName: SecSocialCommitteeName.text);
                      context.read<MemberListProvider>().addMember(member4);
                      FamilyEnrollmentEndPointDto member5 =
                          FamilyEnrollmentEndPointDto(
                              familyId: 1,
                              role: Role.SecretaryOfTheCulturalCommittee,
                              userName: SecCulturalCommitteeName.text);
                      context.read<MemberListProvider>().addMember(member5);
                      FamilyEnrollmentEndPointDto member6 =
                          FamilyEnrollmentEndPointDto(
                              role: Role.SecretaryOfTheTechnicalCommittee,
                              familyId: 1,
                              userName: SecTechnicalCommitteeName.text);
                      context.read<MemberListProvider>().addMember(member6);
                      FamilyEnrollmentEndPointDto member7 =
                          FamilyEnrollmentEndPointDto(
                              role: Role.SecretaryOfTheScientificCommittee,
                              familyId: 1,
                              userName: SecScientificCommitteeName.text);
                      context.read<MemberListProvider>().addMember(member7);
                      FamilyEnrollmentEndPointDto member8 =
                          FamilyEnrollmentEndPointDto(
                              role: Role.SecretaryOfTheFamiliesCommittee,
                              familyId: 1,
                              userName: SecFamiliesCommitteeName.text);
                      context.read<MemberListProvider>().addMember(member8);
                      FamilyEnrollmentEndPointDto member9 =
                          FamilyEnrollmentEndPointDto(
                              role: Role.SecretaryOfTheMobileCommitte,
                              familyId: 1,
                              userName: SecMobileCommitteeName.text);
                      context.read<MemberListProvider>().addMember(member9);
                      _globalKey.currentState!.save();
                      _showMemberAddedToast("Members");
                      setState(() {});
                      // Clear the text field
                    } else {
                      Fluttertoast.showToast(
                        msg: " Not Saved",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          isActive: currentStep >= 3),
      Step(
        title: Text("Add Members"),
        content: Column(
          children: [
            Form(
              key: _globalKey,
              child: TextFormField(
                controller: FMemberName,
                onSaved: (newValue) {
                  if (newValue != null && newValue.isNotEmpty) {
                    FamilyEnrollmentEndPointDto member =
                        FamilyEnrollmentEndPointDto(
                            userName: newValue, role: Role.Member, familyId: 1);
                    context.read<MemberListProvider>().addMember(member);
                  }
                },
                validator: (value) {
                  if (value!.isNotEmpty) {
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
              child: Text("Add Member"),
              onPressed: () {
                if (_globalKey.currentState!.validate()) {
                  _globalKey.currentState!.save();
                  _showMemberAddedToast("Member");
                  FMemberName.clear(); // Clear the text field
                }
                setState(() {});
              },
            ),
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
        isActive: currentStep >= 4,
      ),
      Step(
        title: Text("Family Plans"),
        content: Column(
          children: [
            Form(
                key: _PlanformKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: FamilyPlanName,
                      decoration: InputDecoration(labelText: 'Plan Name'),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Plan Name is required';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: FamilyPlanPlaceOfEmp,
                      decoration:
                          InputDecoration(labelText: 'Place Of Emplementaion'),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Place of Emplementation is required';
                        }
                        return null;
                      },
                    ),
                    Row(
                      children: [
                        Text("Start Date"),
                        IconButton(
                          onPressed: () => _showDatePicker((selectedDate) {
                            setState(() {
                              PlanStartDate = selectedDate;
                            });
                          }),
                          icon: Icon(Icons.date_range),
                        ),
                        Text(DateFormat('dd-MM-yyyy').format(PlanStartDate)),
                      ],
                    ),
                    Row(
                      children: [
                        Text("End Date"),
                        IconButton(
                          onPressed: () => _showDatePicker((selectedDate) {
                            setState(() {
                              PlanEndDate = selectedDate;
                            });
                          }),
                          icon: Icon(Icons.date_range),
                        ),
                        Text(DateFormat('dd-MM-yyyy').format(PlanEndDate)),
                      ],
                    )
                  ],
                )),
            ElevatedButton(
              child: Text("Add Plan"),
              onPressed: () {
                if (_PlanformKey.currentState!.validate()) {
                  CreateAndUpdateFamilyPlanDto plan =
                      CreateAndUpdateFamilyPlanDto(
                    startDate: PlanStartDate,
                    endDate: PlanEndDate,
                    eventName: FamilyPlanName.text,
                    placeOfImplementation: FamilyPlanPlaceOfEmp.text,
                    familyId: 0,
                  );
                  context.read<FamilyPlanListProvider>().addPlan(plan);
                  _PlanformKey.currentState!.save();
                  Fluttertoast.showToast(
                    msg: "Plan Added",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  FamilyPlanName.clear();
                  FamilyPlanPlaceOfEmp.clear();
                  setState(() {
                    PlanStartDate = DateTime.now();
                    PlanEndDate = DateTime.now();
                  });
                } else {
                  Fluttertoast.showToast(
                    msg: " Not Saved",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }
              },
            ),
            Consumer<FamilyPlanListProvider>(
              builder: (context, provider, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: provider.plans
                      .map((plan) => Text("Plan: ${plan.eventName}"))
                      .toList(),
                );
              },
            ),
          ],
        ),
        isActive: currentStep >= 5,
      ),
      Step(
        title: Text("View Final Family Information"),
        content: SizedBox(
          height: 2,
        ),
        isActive: currentStep >= 6,
      )
    ];
  }
}
