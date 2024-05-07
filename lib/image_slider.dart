import 'package:flutter/material.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:hive/Nav_bar.dart';

class ImageSliders extends StatefulWidget {
  const ImageSliders({super.key});

  @override
  _ImageSlidersState createState() => _ImageSlidersState();
}

class _ImageSlidersState extends State<ImageSliders> {
  final List<Map<String, dynamic>> categories = [
    {'name': 'Category 1', 'icon': Icons.home},
    {'name': 'Category 2', 'icon': Icons.star},
    {'name': 'Category 3', 'icon': Icons.person},
    {'name': 'Category 1', 'icon': Icons.home},
    {'name': 'Category 1', 'icon': Icons.home},
    {'name': 'Category 1', 'icon': Icons.home},
    {'name': 'Category 1', 'icon': Icons.home},
    {'name': 'Category 1', 'icon': Icons.home},
    // Add more categories with their respective icons
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
              'Welcome to Hive!',
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
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        categories[index]['icon'],
                        size: 30,
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
                Card(
                  child: Container(
                    height: 100, // First card with fixed height
                    color: const Color.fromARGB(255, 60, 127, 181),
                    child: Center(
                      child: Text('Trips'),
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    height: 90, // Second card with larger height
                    color: Color.fromARGB(136, 38, 156, 211),
                    child: Center(
                      child: Text('comp'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomMenu(),
    );
  }
}
