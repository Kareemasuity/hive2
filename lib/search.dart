import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddressSearchField extends StatefulWidget {
  final TextEditingController controller;

  AddressSearchField({required this.controller});

  @override
  _AddressSearchFieldState createState() => _AddressSearchFieldState();
}

class _AddressSearchFieldState extends State<AddressSearchField> {
  List<String> addresses = [];
  List<String> filteredList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchAddresses();
  }

  // Fetch addresses from the API
  Future<void> fetchAddresses() async {
    setState(() {
      isLoading = true;
    });
    final response = await http
        .get(Uri.parse('https://10.0.2.2:7147/api/Address/GetAddresses'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        addresses = data.map((address) => address.toString()).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load addresses');
    }
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredList = [];
      });
    } else {
      setState(() {
        filteredList = addresses
            .where((element) =>
                element.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: widget.controller,
          onChanged: filterSearchResults,
          decoration: InputDecoration(
            labelText: 'Address',
            hintText: 'Enter address',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
          ),
        ),
        isLoading
            ? Center(child: CircularProgressIndicator())
            : filteredList.isEmpty && widget.controller.text.isEmpty
                ? Container()
                : Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            widget.controller.text = filteredList[index];
                            setState(() {
                              filteredList = [];
                            });
                          },
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text("${filteredList[index]}"),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ],
    );
  }
}
