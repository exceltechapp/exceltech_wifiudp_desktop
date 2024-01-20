import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MessageFail extends StatefulWidget {
  const MessageFail({Key? key});

  @override
  State<MessageFail> createState() => _MessageFailState();
}

class _MessageFailState extends State<MessageFail> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.error,
              color: Colors.redAccent,
              size: 100.0,
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                'Device Configuration Fail!',
                style: TextStyle(fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
