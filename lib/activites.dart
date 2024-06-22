import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/data.dart';
import 'package:http/http.dart' as http;

class ActivityPage extends StatefulWidget {
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final String baseUrl =
      Platform.isAndroid ? 'https://10.0.2.2:7147' : 'https://localhost:7147';
  List<Activity> activities = [];
  bool isLoading = false;
  String errorMessage = '';

  void _fetchActivities() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response =
          await http.get(Uri.parse('$url/api/Activity/GetAllActivities'));

      if (response.statusCode == 200) {
        print('fetched');
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          activities = data.map((item) => Activity.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load activities');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activities'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _fetchActivities,
              child: Text('Fetch Activities'),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : errorMessage.isNotEmpty
                    ? Text(errorMessage)
                    : Expanded(
                        child: ListView.builder(
                          itemCount: activities.length,
                          itemBuilder: (context, index) {
                            final activity = activities[index];
                            return ListTile(
                              title: Text(activity.name),
                              subtitle: Text(activity.description),
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}

class Activity {
  final int id;
  final String name;
  final String description;

  Activity({required this.id, required this.name, required this.description});

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}
