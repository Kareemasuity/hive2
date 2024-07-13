import 'package:flutter/material.dart';

class NotEnrolledStudent extends StatelessWidget {
  const NotEnrolledStudent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Families committee'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
              child: Text(
                "You are not enrolled in any family yet",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(66, 57, 49, 81),
                blurRadius: 10,
                offset: Offset(0, 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
