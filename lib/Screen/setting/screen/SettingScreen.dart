import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  Future<String> getLocalIpAddress() async {
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        if (addr.type == InternetAddressType.IPv4) {
          return addr.address;
        }
      }
    }
    return 'Unknown';
  }

  Future<void> ServerFunction() async {
    print(InternetAddress.loopbackIPv4);
    var server = await HttpServer.bind('0.0.0.0', 80);
    print('Server running on ${server.address}:${server.port}');

    await for (HttpRequest request in server) {
      handleRequest(request);
    }
  }
  void handleRequest(HttpRequest request) async {
    if (request.method == 'GET') {
      // Handle GET request
      request.response.write('Hello From Server!');
    } else if (request.method == 'POST') {
      // Handle POST request
      var content = await utf8.decoder.bind(request).join();
      print('Received POST data: $content');
      request.response.write('Data received successfully.');
    } else {
      request.response.write('Unsupported request method');
    }

    await request.response.close();
  }
  @override
  Widget build(BuildContext context) {
    ServerFunction();
    return Scaffold(
      body: Container(),
    );
  }
}
