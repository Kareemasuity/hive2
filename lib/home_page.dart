// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/art.dart';
import 'package:hive/committees_data.dart';
import 'package:hive/culture.dart';
import 'package:hive/data.dart';
import 'package:hive/families.dart';
import 'package:hive/families_form.dart';
import 'package:hive/other_activities.dart';
import 'package:hive/rovers.dart';
import 'package:hive/science.dart';
import 'package:hive/sports.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Committee App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi Saif,',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Welcome Back 👋',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'The Committees',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                CommitteesWidget(),
                SizedBox(height: 16),
                Text(
                  'Families',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Families(),
                        ),
                      );
                    },
                    child: Text("Check Families Committee")),
                SizedBox(height: 16),
                Text(
                  'Latest News',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                LatestNewsList(),
                SizedBox(height: 16),
                Text(
                  'Current Event',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                CurrentEventSlider(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

Future<List<Committee>> fetchCommittees() async {
  final storage = FlutterSecureStorage();
  String? token = await storage.read(key: 'access_token');

  if (token == null || token.isEmpty) {
    throw Exception('User is not authenticated');
  }

  final headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  final response = await http.get(
    Uri.parse('$url/api/Committee/GetAllCommittees'),
    headers: headers,
  );

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse
        .map((committee) => Committee.fromJson(committee))
        .toList();
  } else {
    throw Exception('Failed to load committees');
  }
}

class CommitteesWidget extends StatefulWidget {
  @override
  _CommitteesWidgetState createState() => _CommitteesWidgetState();
}

class _CommitteesWidgetState extends State<CommitteesWidget> {
  late Future<List<Committee>> futureCommittees;

  @override
  void initState() {
    super.initState();
    futureCommittees = fetchCommittees();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Committee>>(
      future: futureCommittees,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        } else {
          List<Committee> committees = snapshot.data!;
          return Container(
            height: 80, // Adjust the height as needed
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: committees.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          routeWidgets[
                              committees[index].englishName.toLowerCase()] ??
                          Container(),
                    ));
                  },
                  child: Container(
                    width: 80, // Adjust the width as needed
                    margin: EdgeInsets.only(right: 16),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(
                            'images/Trip-bro.png', // Replace with the correct path
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(committees[index].englishName,
                            style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}

final Map<String, Widget> routeWidgets = {
  'sports': SportsPage(),
  'culture': CulturePage(),
  'science': SciencePage(),
  'families': Families(),
  'art': ArtsPage(),
  'rovers': RoversPage(),
  'otherActivities': OtherActivities(),
};

class LatestNewsList extends StatefulWidget {
  @override
  _LatestNewsListState createState() => _LatestNewsListState();
}

class _LatestNewsListState extends State<LatestNewsList> {
  List<Map<String, String>> news = [];

  @override
  void initState() {
    super.initState();
    fetchLatestNews();
  }

  Future<void> fetchLatestNews() async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'access_token');

    if (token == null || token.isEmpty) {
      throw Exception('User is not authenticated');
    }

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.get(
      Uri.parse('$url/api/News/GetAllNews'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      print('fetched');
      final List<dynamic> newsData = json.decode(response.body);
      setState(() {
        news = newsData
            .map((item) => {
                  'title': item['title'] as String,
                  'time': item['time'] as String,
                  'image': item['image'] as String,
                })
            .toList();
      });
    } else {
      throw Exception('Failed to load news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150, // Adjust the height as needed
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: news.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      NewsDetailPage(title: news[index]['title']!),
                ),
              );
            },
            child: Container(
              width: 300, // Adjust the width as needed
              margin: EdgeInsets.only(right: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Image.network(
                    news[index]['image']!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          news[index]['title']!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          news[index]['time']!,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CurrentEventSlider extends StatefulWidget {
  @override
  _CurrentEventSliderState createState() => _CurrentEventSliderState();
}

class _CurrentEventSliderState extends State<CurrentEventSlider> {
  int _currentIndex = 0;
  List<Map<String, String>> events = [];

  @override
  void initState() {
    super.initState();
    fetchCurrentEvents();
  }

  Future<void> fetchCurrentEvents() async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'access_token');

    if (token == null || token.isEmpty) {
      throw Exception('User is not authenticated');
    }

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.get(
      Uri.parse('$url/api/CurrentEvent/GetAllCurrentEvent'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      print('fetched');
      final List<dynamic> eventsData = json.decode(response.body);
      setState(() {
        events = eventsData
            .map((item) => {
                  'title': item['title'] as String,
                  'deadline': item['deadline'] as String,
                  'date': item['date'] as String,
                  'image': item['image'] as String,
                })
            .toList();
      });
    } else {
      throw Exception('Failed to load events');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 200,
            autoPlay: true,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: events.map((event) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EventDetailPage(title: event['title']!),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Image.network(
                      event['image']!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(event['date']!),
                  Text(
                    event['title']!,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text('Deadline : ${event['deadline']}'),
                ],
              ),
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: events.map((event) {
            int index = events.indexOf(event);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? Color.fromRGBO(0, 0, 0, 0.9)
                    : Color.fromRGBO(0, 0, 0, 0.4),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class CommitteeDetailPage extends StatelessWidget {
  final String title;

  CommitteeDetailPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text('Details for $title committee'),
      ),
    );
  }
}

class NewsDetailPage extends StatelessWidget {
  final String title;

  NewsDetailPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text('Details for news: $title'),
      ),
    );
  }
}

class EventDetailPage extends StatelessWidget {
  final String title;

  EventDetailPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text('Details for event: $title'),
      ),
    );
  }
}
