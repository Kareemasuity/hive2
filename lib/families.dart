import 'package:flutter/material.dart';
import 'package:hive/families_form.dart';

class Families extends StatefulWidget {
  const Families({super.key});

  @override
  State<Families> createState() => _FamiliesState();
}

class _FamiliesState extends State<Families> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Latest Families Activities",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  SizedBox(
                      width: 200,
                      child: Image(
                        image: AssetImage('images/families_img.jpeg'),
                        fit: BoxFit.fill,
                      )),
                  Text("mmmmmmmmmmm")
                ],
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FamiliesForm(),
                      ),
                    );
                  },
                  child: Text("Start your family"))
            ],
          ),
        ));
  }
}
