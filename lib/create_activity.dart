import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateActivityPage extends StatefulWidget {
  @override
  _CreateActivityPageState createState() => _CreateActivityPageState();
}

class _CreateActivityPageState extends State<CreateActivityPage> {
  final String baseUrl =
      Platform.isAndroid ? 'https://10.0.2.2:7147' : 'https://localhost:7147';
  final _formKey = GlobalKey<FormState>();

  TextEditingController englishNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController arabicNameController = TextEditingController();
  TextEditingController committeeIdController = TextEditingController();

  bool isLoading = false;
  String errorMessage = '';
  String successMessage = '';

  Future<void> _createActivity() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
      successMessage = '';
    });

    final url = Uri.parse('$baseUrl/api/Activity/CreateActivity');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'englishName': englishNameController.text,
      'description': descriptionController.text,
      'arabicName': arabicNameController.text,
      'committeeId': int.tryParse(committeeIdController.text) ?? 0,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        setState(() {
          successMessage = 'Activity created successfully';
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to create activity: ${response.body}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to create activity: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Activity'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: englishNameController,
                decoration: InputDecoration(labelText: 'English Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter English name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: arabicNameController,
                decoration: InputDecoration(labelText: 'Arabic Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Arabic name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: committeeIdController,
                decoration: InputDecoration(labelText: 'Committee ID'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Committee ID';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() == true) {
                          _createActivity();
                        }
                      },
                      child: Text('Create Activity'),
                    ),
              SizedBox(height: 20),
              if (errorMessage.isNotEmpty) ...[
                Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ],
              if (successMessage.isNotEmpty) ...[
                Text(
                  successMessage,
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
