import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageList extends StatefulWidget {
  const ManageList({super.key});

  @override
  State<ManageList> createState() => _ManageListState();
}

class _ManageListState extends State<ManageList> {
  // define set for getting current device
  Set<dynamic> DeviceList = {};
  // define function save to preferences
  GetPreferences(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Try reading data from the 'items' key. If it doesn't exist, returns null.
    final List<String>? items = prefs.getStringList(key);
    return items;
  }

  // define function save to preferences
  void SavePreferences(String key, List<String> payload) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, payload);
  }

  @override
  Widget build(BuildContext context) {
    print("Runing");
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Manage Device's List"),
      ),
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Align(
          alignment: Alignment.center,
          child: Text("data"),
        ),
      ),
    );
  }
}
