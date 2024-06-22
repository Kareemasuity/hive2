import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stylish Sign Up',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SignUpScreen(),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();

  String _email = '';
  String _password = '';
  String _phoneNumber = '';
  String _firstName = '';
  String _lastName = '';
  String _birthDate = '';
  String _nationalId = '';
  int _gender = 0;
  String _addressDetails = '';
  String _imagePath = '';
  int _unEntityId = 0;
  String _addressId = '';
  int _level = 0;
  String _collegeDepartment = '';

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        final response = await http.post(
          Uri.parse('https://10.0.2.2:7147'),
          body: jsonEncode({
            'email': _email,
            'password': _password,
            'phoneNumber': _phoneNumber,
            'firstName': _firstName,
            'lastName': _lastName,
            'birthDate': _birthDate,
            'nationalId': _nationalId,
            'gender': _gender,
            'addressDetails': _addressDetails,
            'imagePath': _imagePath,
            'unEntityId': _unEntityId,
            'addressId': _addressId,
            'level': _level,
            'collegeDepartment': _collegeDepartment,
          }),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          // Registration successful, you can handle it as per your requirement
          print('Registration successful');
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration failed. Please try again.')),
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
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Create Account',
                        textStyle: TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        speed: Duration(milliseconds: 200),
                      ),
                    ],
                    totalRepeatCount: 1,
                  ),
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
                    validator: (value) =>
                        value!.length < 9 ? 'Password too short' : null,
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
                      prefixIcon: Icon(Icons.credit_card),
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
                    onChanged: (value) => setState(() => _gender = value!),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Address Details',
                      prefixIcon: Icon(Icons.home),
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
                      labelText: 'Image Path',
                      prefixIcon: Icon(Icons.image),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.blue.shade50,
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your image path' : null,
                    onSaved: (value) => _imagePath = value!,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'University Entity ID',
                      prefixIcon: Icon(Icons.school),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.blue.shade50,
                    ),
                    validator: (value) => int.tryParse(value!) == null
                        ? 'Please enter a valid number'
                        : null,
                    onSaved: (value) => _unEntityId = int.parse(value!),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: 'Address ID',
                      prefixIcon: Icon(Icons.location_city),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.blue.shade50,
                    ),
                    validator: (value) => int.tryParse(value!) == null
                        ? 'Please enter a valid number'
                        : null,
                    onSaved: (value) =>
                        _addressId = int.parse(value!) as String,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Level',
                      prefixIcon: Icon(Icons.bar_chart),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.blue.shade50,
                    ),
                    validator: (value) => int.tryParse(value!) == null
                        ? 'Please enter a valid number'
                        : null,
                    onSaved: (value) => _level = int.parse(value!),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'College Department',
                      prefixIcon: Icon(Icons.business),
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
                  SizedBox(height: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    child: Text('Sign Up'),
                    onPressed: _submit,
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
