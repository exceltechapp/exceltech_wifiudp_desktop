import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MessageComplete extends StatefulWidget {
  const MessageComplete({Key? key});

  @override
  State<MessageComplete> createState() => _MessageCompleteState();
}

class _MessageCompleteState extends State<MessageComplete> {
  void reset() async {
    var ReWifi = Uri.http('192.168.4.1', 'Restart');
    await http.get(ReWifi);
  }

  @override
  void initState() {
    reset();
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
              Icons.check_circle,
              color: Color.fromRGBO(0, 165, 146, 1),
              size: 100.0,
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                'Device Configuration Successful!',
                style: TextStyle(fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
