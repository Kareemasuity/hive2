import 'package:flutter/material.dart';
import 'package:hive/image_slider.dart';
// ignore: unused_import
import 'package:hive/notifactions.dart';
import 'package:hive/profile.dart';
import 'package:hive/settings.dart';
import 'package:hive/trips_page.dart';

// ignore: must_be_immutable
class CustomBottomMenu extends StatefulWidget {
  List<Widget> screens = [
    ImageSliders(),
    Settings(),
    tripsPage(),
    AccountScreen(),
  ];
  List<String> screenNames = ['Home', 'Settings', 'notifcatons', 'Profile'];

  @override
  _CustomBottomMenuState createState() => _CustomBottomMenuState();
}

class _CustomBottomMenuState extends State<CustomBottomMenu> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        // Set the background color of the BottomNavigationBar
        canvasColor: Colors.blue,
        // Set the active color of the BottomNavigationBar
        primaryColor: Color.fromARGB(255, 19, 56, 120),
        // Set the inactive color of the BottomNavigationBar
        textTheme: Theme.of(context).textTheme.copyWith(
              caption: TextStyle(color: Color.fromARGB(255, 220, 204, 204)),
            ),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black45,
        unselectedItemColor: Colors.white,
        currentIndex: selectedIndex,
        items: widget.screenNames.asMap().entries.map((entry) {
          int index = entry.key;
          String screenName = entry.value;
          return BottomNavigationBarItem(
            icon: _getIconForScreen(
                index), // Dynamically choose icon based on screen index
            label: screenName,
          );
        }).toList(),
        onTap: (val) {
          setState(() {
            selectedIndex = val;
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => widget.screens[val]),
          );
        },
      ),
    );
  }

  Icon _getIconForScreen(int index) {
    switch (index) {
      case 0:
        return Icon(Icons.home);
      case 1:
        return Icon(Icons.settings);
      case 2:
        return Icon(Icons.notifications);
      case 3:
        return Icon(Icons.person_2_rounded); // Profile icon
      default:
        return Icon(Icons.error); // Handle unexpected cases gracefully
    }
  }
}
