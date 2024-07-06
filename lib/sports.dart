// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

void main() {
  runApp(SportsPage());
}

class SportsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, home: SportsCommitteeScreen());
  }
}

class SportsCommitteeScreen extends StatelessWidget {
  final List<Map<String, String>> sports = [
    {'name': 'Football', 'image': 'https://via.placeholder.com/51x88'},
    {'name': 'Basketball', 'image': 'https://via.placeholder.com/51x88'},
    {'name': 'Handball', 'image': 'https://via.placeholder.com/51x88'},
    {'name': 'Volleyball', 'image': 'https://via.placeholder.com/51x88'},
    {'name': 'Fitness', 'image': 'https://via.placeholder.com/51x88'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.0),
        child: AppBar(
          title: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Text(
                'Sports Committee',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w700,
                  height: 0.03,
                ),
              ),
            ],
          ),
          backgroundColor: const Color.fromARGB(255, 1, 52, 130),
        ),
      ),
      body: ListView.builder(
        itemCount: sports.length,
        itemBuilder: (context, index) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(
                    20.0), // Adjust the radius to your preference
                topLeft: Radius.circular(5.0),
                bottomRight: Radius.circular(5.0),
                bottomLeft: Radius.circular(20.0),
              ),
              child: InkWell(
                onTap: () {},
                child: Container(
                  width: 333.07,
                  height: 113.55,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 27, vertical: 13),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(-0.68, -0.74),
                      end: Alignment(0.68, 0.74),
                      colors: [Color(0xFF9DA9DF), Color(0xFF27B5D4)],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(21),
                        bottomLeft: Radius.circular(21),
                        bottomRight: Radius.circular(5),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: double.infinity,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sports[index]['name']!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w700,
                                height: 0.02,
                              ),
                            ),
                            SizedBox(height: 27),
                            Text(
                              'Collective game',
                              style: TextStyle(
                                color: Colors.white
                                    .withOpacity(0.7200000286102295),
                                fontSize: 13,
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w500,
                                height: 0.07,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 106),
                      Container(
                        width: 51.07,
                        height: 87.55,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 51.07,
                              height: 87.55,
                              decoration: BoxDecoration(
                                  // image: DecorationImage(
                                  //   image: NetworkImage(sports[index]['image']!),
                                  //   fit: BoxFit.contain,
                                  // ),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
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
