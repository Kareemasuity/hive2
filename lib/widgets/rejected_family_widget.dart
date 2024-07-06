import 'dart:convert';
import 'dart:io';
import 'package:hive/data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hive/families_form.dart';
import 'package:hive/family_data.dart';
import 'package:hive/provider/familySupervisors_list_provider.dart';
import 'package:hive/provider/familyplan_list_provider.dart';
import 'package:hive/provider/member_list_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/GetRejectedFamily_data.dart';
import 'package:hive/family_data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EnrolledRejectedFamiliesWidget extends StatefulWidget {
  final int familyId;

  const EnrolledRejectedFamiliesWidget({Key? key, required this.familyId})
      : super(key: key);

  @override
  _EnrolledRejectedFamilyState createState() => _EnrolledRejectedFamilyState();
}

class _EnrolledRejectedFamilyState
    extends State<EnrolledRejectedFamiliesWidget> {
  late Future<RejectedFamily> _futureRejectedFamilyDetails;

  DateTime PlanStartDate = DateTime.now();
  DateTime PlanEndDate = DateTime.now();

  late GlobalKey<FormState> _globalKey;
  late GlobalKey<FormState> _PlanformKey;
  late GlobalKey<FormState> _leaderFormKey;
  late GlobalKey<FormState> _viceleaderFormKey;
  late GlobalKey<FormState> _orgStructureFormKey;

  late List<TextEditingController> memberControllers = [];

  gender? _leaderGender;
  gender? _viceleaderGender;
  var familyDTo;
  late MemberListProvider memberListProvider;
  late FamilyPlanListProvider familyPlanListProvider;
  late FamilySupervisorListProvider familySupervisorListProvider;
  int currentStep = 0;
  int counter = 0;
  bool get isFirstStep => currentStep == 0;
  bool get isLastStep => currentStep == steps().length - 1;
  late File _imageFile;
  late File deanApprovalFile;
  late File headApprovalFile;
  late File viceHeadApprovalFile;
  // Controllers for editing fields
  final TextEditingController familyNameController = TextEditingController();
  final TextEditingController familyMissionController = TextEditingController();
  final TextEditingController familyVisionController = TextEditingController();
  final leaderName = TextEditingController();
  final leaderID = TextEditingController();
  final leaderPhone = TextEditingController();
  final leaderAddress = TextEditingController();
  final FamilyPlanName = TextEditingController();
  final FamilyPlanPlaceOfEmp = TextEditingController();
  final VleaderName = TextEditingController();
  final VleaderID = TextEditingController();
  final VleaderPhone = TextEditingController();
  final VleaderAddress = TextEditingController();
  final DeputyFamilyCoordinatorCont = TextEditingController();
  final FamilyCoordinatorCont = TextEditingController();
  final SecSportsCommitteeName = TextEditingController();
  final SecSocialCommitteeName = TextEditingController();
  final SecCulturalCommitteeName = TextEditingController();
  final SecTechnicalCommitteeName = TextEditingController();
  final SecScientificCommitteeName = TextEditingController();
  final SecFamiliesCommitteeName = TextEditingController();
  final SecExplorersCommitteeName = TextEditingController();
  var FMemberName = TextEditingController();
  bool _dataInitialized = false;

  @override
  void initState() {
    super.initState();
    _futureRejectedFamilyDetails = fetchRejectedFamily(widget.familyId);
    _globalKey = GlobalKey<FormState>();
    _PlanformKey = GlobalKey<FormState>();
    _leaderFormKey = GlobalKey<FormState>();
    _orgStructureFormKey = GlobalKey<FormState>();
    _viceleaderFormKey = GlobalKey<FormState>();
    familyDTo;
    familyPlanListProvider = FamilyPlanListProvider();
    memberListProvider = MemberListProvider();
    familySupervisorListProvider = FamilySupervisorListProvider();
  }

  @override
  void dispose() {
    familyNameController.dispose();
    familyMissionController.dispose();
    familyVisionController.dispose();
    leaderName.dispose();
    leaderID.dispose();
    leaderPhone.dispose();
    leaderAddress.dispose();
    VleaderName.dispose();
    VleaderID.dispose();
    VleaderPhone.dispose();
    VleaderAddress.dispose();
    FamilyCoordinatorCont.dispose();
    DeputyFamilyCoordinatorCont.dispose();
    SecSportsCommitteeName.dispose();
    SecSocialCommitteeName.dispose();
    SecCulturalCommitteeName.dispose();
    SecTechnicalCommitteeName.dispose();
    SecScientificCommitteeName.dispose();
    SecFamiliesCommitteeName.dispose();
    SecExplorersCommitteeName.dispose();
    super.dispose();
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

  void setDeanApprovalFile(File file) {
    deanApprovalFile = file;
  }

  void setHeadApprovalFile(File file) {
    headApprovalFile = file;
  }

  void setViceHeadApprovalFile(File file) {
    viceHeadApprovalFile = file;
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

// Function to save RejectedFamily data to SharedPreferences
  Future<void> saveRejectedFamilyToPreferences(
      RejectedFamily rejectedFamily) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save familyDto
    if (rejectedFamily.familyDto != null) {
      prefs.setString(
          'familyDto', jsonEncode(rejectedFamily.familyDto!.toJson()));
      print("---------------------------------------saving familyDto");
    }

    // Save familyPlanDtos
    if (rejectedFamily.familyPlanDtos != null) {
      prefs.setString(
          'familyPlanDtos',
          jsonEncode(rejectedFamily.familyPlanDtos!
              .map((plan) => plan.toJson())
              .toList()));
      print("---------------------------------------saving familyPlanDtos");
    }

    // Save familyMembersDtos
    if (rejectedFamily.familyMembersDtos != null) {
      prefs.setString(
          'familyMembersDtos',
          jsonEncode(rejectedFamily.familyMembersDtos!
              .map((member) => member.toJson())
              .toList()));
      print("---------------------------------------saving familyMembersDto");
    }

    if (rejectedFamily.familySupervisorsDtos != null &&
        rejectedFamily.familySupervisorsDtos!.isNotEmpty) {
      List<String> supervisorsJsonList = rejectedFamily.familySupervisorsDtos!
          .map((supervisor) => jsonEncode(supervisor.toJson()))
          .toList();
      prefs.setStringList('familySupervisorsDtos', supervisorsJsonList);
      print(
          "---------------------------------------saving familySuperVisorsDto");
    }

    print('Family data saved to SharedPreferences');
  }

  Future<RejectedFamily> getRejectedFamilyFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Fetch the JSON strings
    String? familyDtoJson = prefs.getString('familyDto');
    String? familyPlanDtosJson = prefs.getString('familyPlanDtos');
    String? familyMembersDtosJson = prefs.getString('familyMembersDtos');
    List<String>? familySupervisorsDtosJsonList =
        prefs.getStringList('familySupervisorsDtos');

    // Initialize empty lists
    FamilyDto? familyDto;
    List<FamilyPlanDtos> familyPlanDtos = [];
    List<FamilyMembersDtos> familyMembersDtos = [];
    List<FamilySupervisorsDtos> familySupervisorsDtos = [];

    try {
      // Decode familyDto
      if (familyDtoJson != null && familyDtoJson.isNotEmpty) {
        familyDto = FamilyDto.fromJson(jsonDecode(familyDtoJson));
        print('Retrieved familyDto: $familyDto');
      }

      // Decode familyPlanDtos
      if (familyPlanDtosJson != null && familyPlanDtosJson.isNotEmpty) {
        List<dynamic> planList = jsonDecode(familyPlanDtosJson);
        familyPlanDtos =
            planList.map((e) => FamilyPlanDtos.fromJson(e)).toList();
        print('Retrieved familyPlanDtos: $familyPlanDtos');
      }

      // Decode familyMembersDtos
      if (familyMembersDtosJson != null && familyMembersDtosJson.isNotEmpty) {
        List<dynamic> memberList = jsonDecode(familyMembersDtosJson);
        familyMembersDtos =
            memberList.map((e) => FamilyMembersDtos.fromJson(e)).toList();
        print('Retrieved familyMembersDtos: $familyMembersDtos');
      }

      // Decode familySupervisorsDtos
      if (familySupervisorsDtosJsonList != null &&
          familySupervisorsDtosJsonList.isNotEmpty) {
        for (String supervisorJson in familySupervisorsDtosJsonList) {
          familySupervisorsDtos
              .add(FamilySupervisorsDtos.fromJson(jsonDecode(supervisorJson)));
        }
        print('Retrieved familySupervisorsDtos: $familySupervisorsDtos');
      }

      return RejectedFamily(
        familyDto: familyDto,
        familyPlanDtos: familyPlanDtos,
        familyMembersDtos: familyMembersDtos,
        familySupervisorsDtos: familySupervisorsDtos,
      );
    } catch (e) {
      print('Error fetching rejected family from preferences: $e');
      throw Exception('Failed to load rejected family details');
    }
  }

  Future<void> initializeControllersFromPreferences() async {
    RejectedFamily rejectedFamily = await getRejectedFamilyFromPreferences();

    setState(() {
      if (rejectedFamily.familyDto != null) {
        familyNameController.text = rejectedFamily.familyDto!.name ?? '';
        familyMissionController.text =
            rejectedFamily.familyDto!.familyMission ?? '';
        familyVisionController.text =
            rejectedFamily.familyDto!.familyVision ?? '';
      }
      if (rejectedFamily.familyPlanDtos != null &&
          rejectedFamily.familyPlanDtos!.isNotEmpty) {
        for (int i = 0; i < rejectedFamily.familyPlanDtos!.length; i++) {
          FamilyPlanDtos plan = rejectedFamily.familyPlanDtos![i];
          FamilyPlanName.text = plan.eventName ?? '';
          FamilyPlanPlaceOfEmp.text = plan.placeOfImplementation ?? '';

          if (plan.startDate != null && plan.endDate != null) {
            // Convert strings to DateTime objects
            PlanStartDate = DateTime.parse(plan.startDate!);
            PlanEndDate = DateTime.parse(plan.endDate!);
          }
        }
      }
      if (rejectedFamily.familyMembersDtos != null) {
        for (var member in rejectedFamily.familyMembersDtos!) {
          // Check the role and assign the appropriate controller
          switch (member.familyEnrollmentDto?.role) {
            case Role.FAMILY_COORDINATOR:
              FamilyCoordinatorCont.text = member.userName ?? '';
              break;
            case Role.DEPUTY_FAMILY_COORDINATOR:
              DeputyFamilyCoordinatorCont.text = member.userName ?? '';
              break;
            case Role.SPORTS_COMMITTEE_SECRETARY:
              SecSportsCommitteeName.text = member.userName ?? '';
              break;
            case Role.SOCIAL_COMMITTEE_SECRETARY:
              SecSocialCommitteeName.text = member.userName ?? '';
              break;
            case Role.CULTURAL_COMMITTEE_SECRETARY:
              SecCulturalCommitteeName.text = member.userName ?? '';
              break;
            case Role.TECHNICAL_COMMITTEE_SECRETARY:
              SecTechnicalCommitteeName.text = member.userName ?? '';
              break;
            case Role.SCIENTIFIC_COMMITTEE_SECRETARY:
              SecScientificCommitteeName.text = member.userName ?? '';
              break;
            case Role.EXPLORERS_COMMITTEE_SECRETARY:
              SecExplorersCommitteeName.text = member.userName ?? '';
              break;
            default:
              // Handle other roles or default case as needed
              break;
          }
        }
        List<FamilyMembersDtos>? familyMembers =
            rejectedFamily.familyMembersDtos;
        memberControllers = initializeMemberControllers(familyMembers);
      }

      if (rejectedFamily.familySupervisorsDtos != null &&
          rejectedFamily.familySupervisorsDtos!.isNotEmpty) {
        // Assuming you have at least two supervisors in familySupervisorsDtos
        if (rejectedFamily.familySupervisorsDtos!.length > 0) {
          leaderName.text = rejectedFamily
                  .familySupervisorsDtos![0].familySupervisorsDto?.name ??
              '';
          leaderID.text = rejectedFamily
                  .familySupervisorsDtos![0].familySupervisorsDto?.nationalId ??
              '';
          leaderPhone.text = rejectedFamily.familySupervisorsDtos![0]
                  .familySupervisorsDto?.phoneNumber ??
              '';
          leaderAddress.text = rejectedFamily
                  .familySupervisorsDtos![0].familySupervisorsDto?.address ??
              '';

          _leaderGender = rejectedFamily
                  .familySupervisorsDtos![0].familySupervisorsDto?.Gender ??
              gender.Male;
        }

        if (rejectedFamily.familySupervisorsDtos!.length > 1) {
          VleaderName.text = rejectedFamily
                  .familySupervisorsDtos![1].familySupervisorsDto?.name ??
              '';
          VleaderID.text = rejectedFamily
                  .familySupervisorsDtos![1].familySupervisorsDto?.nationalId ??
              '';
          VleaderPhone.text = rejectedFamily.familySupervisorsDtos![1]
                  .familySupervisorsDto?.phoneNumber ??
              '';
          VleaderAddress.text = rejectedFamily
                  .familySupervisorsDtos![1].familySupervisorsDto?.address ??
              '';

          _viceleaderGender = rejectedFamily
                  .familySupervisorsDtos![1].familySupervisorsDto?.Gender ??
              gender.Male;
        }
      }
    });
  }

  List<TextEditingController> initializeMemberControllers(
      List<FamilyMembersDtos>? familyMembersDtos) {
    List<TextEditingController> controllers = [];

    if (familyMembersDtos != null) {
      for (var member in familyMembersDtos) {
        if (member != null &&
            member.familyEnrollmentDto != null &&
            member.familyEnrollmentDto!.role == Role.Member) {
          TextEditingController controller =
              TextEditingController(text: member.userName ?? '');
          controllers.add(controller);
        }
      }
    }

    return controllers;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RejectedFamily>(
      future: _futureRejectedFamilyDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No data found'));
        } else {
          if (!_dataInitialized) {
            RejectedFamily rejectedFamily = snapshot.data!;
            saveRejectedFamilyToPreferences(rejectedFamily).then((_) {
              initializeControllersFromPreferences().then((_) {
                setState(() {
                  _dataInitialized = true;
                });
              });
            });
          }

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
                onStepContinue: isLastStep
                    ? null
                    : () {
                        setState(() {
                          currentStep += 1;
                        });
                      },
                onStepCancel: currentStep == 0
                    ? null
                    : () => setState(() {
                          currentStep -= 1;
                        }),
                onStepTapped: (step) => setState(() => currentStep = step),
              ),
            ),
          );
        }
      },
    );
  }

  List<Step> steps() {
    return [
      Step(
          title: Text("Family"),
          content: Column(
            children: [
              TextFormField(
                controller: familyNameController,
                decoration: InputDecoration(labelText: 'Family Name'),
                keyboardType: TextInputType.name,
              ),
              TextFormField(
                controller: familyMissionController,
                decoration: InputDecoration(labelText: 'Mission'),
                keyboardType: TextInputType.multiline,
              ),
              TextFormField(
                controller: familyVisionController,
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
              TextButton(
                  onPressed: () {
                    setState(() {
                      familyDTo = CreateAndUpdateFamilyDto(
                          familyMission: familyMissionController.text,
                          familyVision: familyVisionController.text,
                          name: familyNameController.text,
                          imagePath: _imageFile,
                          deanApproval: deanApprovalFile,
                          headApproval: headApprovalFile,
                          viceHeadApproval: viceHeadApprovalFile,
                          familyRulesId: widget.familyId,
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
                                Gender: _leaderGender!,
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
                                Gender: _viceleaderGender!,
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
                  controller: FamilyCoordinatorCont,
                  decoration:
                      InputDecoration(labelText: 'Family Rapporteur Name'),
                  keyboardType: TextInputType.name,
                ),
                TextFormField(
                  controller: DeputyFamilyCoordinatorCont,
                  onSaved: (newValue) {
                    FamilyEnrollmentEndPointDto member2 =
                        FamilyEnrollmentEndPointDto(
                            familyId: 1,
                            role: Role.DEPUTY_FAMILY_COORDINATOR,
                            userName: DeputyFamilyCoordinatorCont.text);
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
                            role: Role.SOCIAL_COMMITTEE_SECRETARY,
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
                  controller: SecExplorersCommitteeName,
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
                              role: Role.FAMILY_COORDINATOR,
                              userName: FamilyCoordinatorCont.text);
                      context.read<MemberListProvider>().addMember(member1);
                      FamilyEnrollmentEndPointDto member2 =
                          FamilyEnrollmentEndPointDto(
                              familyId: 1,
                              role: Role.DEPUTY_FAMILY_COORDINATOR,
                              userName: DeputyFamilyCoordinatorCont.text);
                      context.read<MemberListProvider>().addMember(member2);
                      FamilyEnrollmentEndPointDto member3 =
                          FamilyEnrollmentEndPointDto(
                              familyId: 1,
                              role: Role.SPORTS_COMMITTEE_SECRETARY,
                              userName: SecSportsCommitteeName.text);
                      context.read<MemberListProvider>().addMember(member3);
                      FamilyEnrollmentEndPointDto member4 =
                          FamilyEnrollmentEndPointDto(
                              familyId: 1,
                              role: Role.SOCIAL_COMMITTEE_SECRETARY,
                              userName: SecSocialCommitteeName.text);
                      context.read<MemberListProvider>().addMember(member4);
                      FamilyEnrollmentEndPointDto member5 =
                          FamilyEnrollmentEndPointDto(
                              familyId: 1,
                              role: Role.CULTURAL_COMMITTEE_SECRETARY,
                              userName: SecCulturalCommitteeName.text);
                      context.read<MemberListProvider>().addMember(member5);
                      FamilyEnrollmentEndPointDto member6 =
                          FamilyEnrollmentEndPointDto(
                              role: Role.TECHNICAL_COMMITTEE_SECRETARY,
                              familyId: 1,
                              userName: SecTechnicalCommitteeName.text);
                      context.read<MemberListProvider>().addMember(member6);
                      FamilyEnrollmentEndPointDto member7 =
                          FamilyEnrollmentEndPointDto(
                              role: Role.SCIENTIFIC_COMMITTEE_SECRETARY,
                              familyId: 1,
                              userName: SecScientificCommitteeName.text);
                      context.read<MemberListProvider>().addMember(member7);
                      FamilyEnrollmentEndPointDto member8 =
                          FamilyEnrollmentEndPointDto(
                              role: Role.FAMILY_COMMITTEE_SECRETARY,
                              familyId: 1,
                              userName: SecFamiliesCommitteeName.text);
                      context.read<MemberListProvider>().addMember(member8);
                      FamilyEnrollmentEndPointDto member9 =
                          FamilyEnrollmentEndPointDto(
                              role: Role.EXPLORERS_COMMITTEE_SECRETARY,
                              familyId: 1,
                              userName: SecExplorersCommitteeName.text);
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
        title: Text("Members"),
        content: Column(
          children: [
            // Display TextFormField list if there are existing members
            if (memberControllers.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                itemCount: memberControllers.length,
                itemBuilder: (context, index) {
                  return TextFormField(
                    controller: memberControllers[index],
                    decoration: InputDecoration(
                      labelText: 'Member Name ${index + 1}',
                    ),
                    keyboardType: TextInputType.name,
                  );
                },
              ),
            // Display a single TextFormField if no members exist
            if (memberControllers.isEmpty)
              TextFormField(
                controller: TextEditingController(),
                decoration: InputDecoration(
                  labelText: 'Member Name 1',
                ),
                keyboardType: TextInputType.name,
              ),
            // Button to add more members
            ElevatedButton(
              onPressed: () {
                setState(() {
                  memberControllers.add(TextEditingController());
                });
              },
              child: Text("Add Member"),
            ),
            // Button to save members
            ElevatedButton(
              onPressed: () {
                if (_globalKey.currentState!.validate()) {
                  _globalKey.currentState!.save();
                  _showMemberAddedToast("Member");
                  // Clearing the text field after saving
                  // Assuming FMemberName is a TextEditingController
                  FMemberName.clear();
                }
                setState(() {});
              },
              child: Text("Save Members"),
            ),
            //Consumer to display a list of members from provider
            Consumer<MemberListProvider>(
              builder: (context, provider, child) {
                if (provider.list != null && provider.list!.isNotEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: provider.list!
                        .map((member) =>
                            Text("Member: ${member.userName ?? 'Unknown'}"))
                        .toList(),
                  );
                } else {
                  return Text("No members available");
                }
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
                        InputDecoration(labelText: 'Place Of Implementation'),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Place of Implementation is required';
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
                  ),
                ],
              ),
            ),
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
                    familyId: widget.familyId,
                  );
                  context.read<FamilyPlanListProvider>().addPlan(plan);
                  _PlanformKey.currentState!.reset();
                  setState(() {
                    PlanStartDate = DateTime.now();
                    PlanEndDate = DateTime.now();
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Plan not saved. Please check the form.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
            Consumer<FamilyPlanListProvider>(
              builder: (context, provider, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: provider.plans
                      .map((plan) => ListTile(
                            title: Text(plan.eventName ?? ''),
                            subtitle: Text(plan.placeOfImplementation ?? ''),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                provider
                                    .removePlan(provider.plans.indexOf(plan));
                              },
                            ),
                          ))
                      .toList(),
                );
              },
            ),
          ],
        ),
        isActive: currentStep >= 5,
      ),
      Step(
        title: Text("Final Submission"),
        content: Row(
          children: [
            ElevatedButton(onPressed: _submitForm, child: Text("Submit")),
            SizedBox(
              width: 5,
            ),
            ElevatedButton(
              onPressed: () async {
                _deleteFamily(widget.familyId);
              },
              child: Text("Delete"),
            )
          ],
        ),
        isActive: currentStep >= 6,
      )
    ];
  }

  Future<void> _deleteFamily(int familyId) async {
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
        '$url/api/FamilyEndPoint/DeleteFamily/$familyId'; // Replace with your actual API endpoint

    final response = await http.delete(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode == 200) {
      print('Family deleted successfully');
    } else if (response.statusCode == 404) {
      throw Exception('Family not found');
    } else {
      throw Exception('Failed to delete family');
    }
  }
}
