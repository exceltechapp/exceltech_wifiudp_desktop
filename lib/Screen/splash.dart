import 'dart:async';
import 'package:flutter/material.dart';
import 'login.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  void goTO() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => loginScreen()));
  }

  @override
  void initState() {
    Timer(Duration(seconds: 3), () => goTO());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/brand-excel.png"),
      ),
    );
  }
}
