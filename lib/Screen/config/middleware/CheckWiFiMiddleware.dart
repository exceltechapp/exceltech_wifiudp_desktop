import 'dart:async';
import 'dart:convert';

//import 'package:exceltech_config/view/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../screen/config.dart';

class CheckWiFiMiddleware extends StatefulWidget {
  const CheckWiFiMiddleware({super.key});

  @override
  State<CheckWiFiMiddleware> createState() => _CheckWiFiMiddlewareState();
}

class _CheckWiFiMiddlewareState extends State<CheckWiFiMiddleware> {
  // define timer for checking wifi every 60 second
  Timer? timer;
  // define Function for checking wifi connect with Exceltech-MSD
  void CheckWiFi() async {
    var url = Uri.http('192.168.4.1', 'getChipID');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200 && this.mounted) {
      var body = jsonDecode(response.body);
      if(body["Type"] == "WIFI"){
        timer?.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => config()),
        );
      }else{
        timer?.cancel();

      }
    } else if (response.statusCode != 200 && this.mounted) {}
    timer = Timer.periodic(Duration(seconds: 30), (Timer t) => CheckWiFi());
  }

  @override
  void initState() {
    CheckWiFi();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  strokeWidth: 6,
                  color: Color.fromRGBO(0, 165, 146, 1),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 10),
                child: Text("PLASE CONNECT WiFi WITH \"Exceltech-MSD\"",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
              )
            ],
          ),
        ),
      ),
    );
  }
}
