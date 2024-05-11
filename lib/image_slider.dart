import 'package:flutter/material.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:hive/Nav_bar.dart';
// ignore: unused_import
import 'package:hive/categories_sub_categories_screen/categories_sub_categories_screen.dart';
import 'package:hive/sports.dart';
import 'package:hive/trips_page.dart';

class ImageSliders extends StatefulWidget {
  const ImageSliders({Key? key}) : super(key: key);

  @override
  _ImageSlidersState createState() => _ImageSlidersState();
}

class _ImageSlidersState extends State<ImageSliders> {
  final List<Map<String, String>> categories = [
    {"name": "Sports"},
    {"name": "Culture"},
    {"name": "science"},
    {"name": "families"},
    {"name": "Art"},
    {"name": "Rovers"},
    {"name": "other actvites"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 250,
            width: double.infinity,
            child: AnotherCarousel(
              images: const [
                AssetImage("images/image1.jpg"),
                AssetImage("images/image2.jpg"),
              ],
              dotSize: 4,
              indicatorBgPadding: 2.0,
            ),
          ),
          Container(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Handle category tap
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:
                              Color.fromARGB(255, 38, 14, 146).withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        categories[index]["name"]!,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => tripsPage(),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    child: Container(
                      width:
                          double.infinity, // Makes the card expand horizontally
                      height: 120, // Adjust the height as needed
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 27, 191, 194),
                            const Color.fromARGB(255, 238, 233, 233)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            bottom: 10,
                            left: 10,
                            child: Text(
                              'Trips',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          // Add your Curology product image here
                          Image.asset('images/Trip-bro.png'),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SportsPage(),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    child: Container(
                      width:
                          double.infinity, // Makes the card expand horizontally
                      height: 120, // Adjust the height as needed
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 89, 94, 229),
                            const Color.fromARGB(255, 238, 233, 233)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            bottom: 10,
                            left: 10,
                            child: Text(
                              'competitions',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          // Add your Curology product image here
                          Image.asset('images/Achievement.png'),
                        ],
                      ),
                    ),
                  ),
                ),
                // ... Your second card remains here
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomMenu(),
    );
  }
}
