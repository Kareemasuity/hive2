import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

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
  String _email = '';
  String _password = '';
  // ignore: unused_field
  String _confirmPassword = '';

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Here you can add your sign up logic
      print('Email: $_email, Password: $_password');
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
            image: AssetImage('assets/background_pattern.png'),
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
                        value!.length < 6 ? 'Password too short' : null,
                    onSaved: (value) => _password = value!,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.blue.shade50,
                    ),
                    obscureText: true,
                    validator: (value) =>
                        value != _password ? 'Passwords do not match' : null,
                    onSaved: (value) => _confirmPassword = value!,
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
