import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final String imagePath;

  const ImageCard({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Image.asset("images/image1.jpg"),
    );
  }
}
