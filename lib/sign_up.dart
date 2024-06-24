import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/services.dart';
// ignore: unused_import
import 'package:flutter/animation.dart';
// import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  late String _email,
      _password,
      _phoneNumber,
      _firstName,
      _lastName,
      _birthDate,
      _nationalId,
      _addressDetails,
      _collegeDepartment;
  late int _gender = 0, _unEntityId, _cityId, _level, _disabilityType;
  bool _hasDisability = false;
  File? _imageFile;

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

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        var request = http.MultipartRequest(
            'POST',
            Uri.parse(
                'https://10.0.2.2:7147/api/Authorization/StudentRegister'));

        request.fields['email'] = _email;
        request.fields['password'] = _password;
        request.fields['phoneNumber'] = _phoneNumber;
        request.fields['firstName'] = _firstName;
        request.fields['lastName'] = _lastName;
        request.fields['birthDate'] = _birthDate;
        request.fields['nationalId'] = _nationalId;
        request.fields['gender'] = _gender.toString();
        request.fields['addressDetails'] = _addressDetails;
        request.fields['unEntityId'] = _unEntityId.toString();
        request.fields['cityId'] = _cityId.toString();
        request.fields['level'] = _level.toString();
        request.fields['collegeDepartment'] = _collegeDepartment;
        request.fields['hasDisability'] = _hasDisability.toString();
        request.fields['disabilityType'] = _disabilityType.toString();

        if (_imageFile != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'image',
              _imageFile!.path,
              contentType:
                  MediaType('image', 'jpeg'), // Adjust based on the image type
            ),
          );
        }

        final response = await request.send();
        final responseString = await response.stream.bytesToString();
        final responseData = jsonDecode(responseString);

        if (response.statusCode == 200) {
          print('success');
          final message = responseData['message'] ?? 'Registration successful';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
          Navigator.pop(context);
        } else {
          final message = responseData['message'] ??
              'Registration failed. Please try again.';
          final errors = responseData['errors'] ?? {};

          String errorMessage = message;
          if (errors.isNotEmpty) {
            errorMessage += '\n' +
                errors.entries.map((e) => '${e.key}: ${e.value}').join('\n');
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      } catch (e) {
        print('Error during registration: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error during registration. Please try again later.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/sports.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlutterLogo(size: 100),
                  SizedBox(height: 40),
                  // AnimatedTextKit(
                  //   animatedTexts: [
                  //     TypewriterAnimatedText(
                  //       'Create Account',
                  //       textStyle: TextStyle(
                  //         fontSize: 32.0,
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.white,
                  //       ),
                  //       speed: Duration(milliseconds: 200),
                  //     ),
                  //   ],
                  //   totalRepeatCount: 1,
                  // ),
                  SizedBox(height: 40),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.blue.shade50,
                    ),
                    validator: (value) =>
                        !value!.contains('@') ? 'Invalid email' : null,
                    onSaved: (value) => _email = value!,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.blue.shade50,
                    ),
                    obscureText: true,
                    validator: (value) => value!.length < 6
                        ? 'Password must be at least 6 characters'
                        : null,
                    onSaved: (value) => _password = value!,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.blue.shade50,
                    ),
                    validator: (value) => value!.isEmpty
                        ? 'Please enter your phone number'
                        : null,
                    onSaved: (value) => _phoneNumber = value!,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.blue.shade50,
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your first name' : null,
                    onSaved: (value) => _firstName = value!,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.blue.shade50,
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your last name' : null,
                    onSaved: (value) => _lastName = value!,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Birth Date',
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.blue.shade50,
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your birth date' : null,
                    onSaved: (value) => _birthDate = value!,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'National ID',
                      prefixIcon: Icon(Icons.perm_identity),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.blue.shade50,
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your national ID' : null,
                    onSaved: (value) => _nationalId = value!,
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.blue.shade50,
                    ),
                    value: _gender,
                    items: [
                      DropdownMenuItem(value: 0, child: Text('Male')),
                      DropdownMenuItem(value: 1, child: Text('Female')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Address Details',
                      prefixIcon: Icon(Icons.location_on),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.blue.shade50,
                    ),
                    validator: (value) => value!.isEmpty
                        ? 'Please enter your address details'
                        : null,
                    onSaved: (value) => _addressDetails = value!,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'UnEntity ID',
                      prefixIcon: Icon(Icons.school),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.blue.shade50,
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your UnEntity ID' : null,
                    onSaved: (value) => _unEntityId = int.parse(value!),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'City ID',
                      prefixIcon: Icon(Icons.location_city),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.blue.shade50,
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your city ID' : null,
                    onSaved: (value) => _cityId = int.parse(value!),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Level',
                      prefixIcon: Icon(Icons.grade),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.blue.shade50,
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your level' : null,
                    onSaved: (value) => _level = int.parse(value!),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'College Department',
                      prefixIcon: Icon(Icons.book),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.blue.shade50,
                    ),
                    validator: (value) => value!.isEmpty
                        ? 'Please enter your college department'
                        : null,
                    onSaved: (value) => _collegeDepartment = value!,
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<bool>(
                    decoration: InputDecoration(
                      labelText: 'Has Disability',
                      prefixIcon: Icon(Icons.accessible),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.blue.shade50,
                    ),
                    value: _hasDisability,
                    items: [
                      DropdownMenuItem(value: true, child: Text('Yes')),
                      DropdownMenuItem(value: false, child: Text('No')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _hasDisability = value!;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Disability Type',
                      prefixIcon: Icon(Icons.accessible_forward),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.blue.shade50,
                    ),
                    validator: (value) => value!.isEmpty
                        ? 'Please enter your disability type'
                        : null,
                    onSaved: (value) => _disabilityType = int.parse(value!),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Pick Image'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
