import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'dart:io';
import 'package:mini_server/mini_server.dart';
import 'Database/LogModel.dart';
import 'Screen/splash.dart';
import 'UDP/UDP.dart';

ValueNotifier<int> value = ValueNotifier(0);

Future printIps() async {
  for (var interface in await NetworkInterface.list()) {
    print('== Interface: ${interface.name} ==');
    for (var addr in interface.addresses) {
      print(
          '${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name}');
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = "C:\\Exceltech-UDP";
  //final appDocumentDir = await path_provider.getApplicationSupportDirectory();
  print(appDocumentDir);
  Hive.init(appDocumentDir);
  printIps();
  Hive.registerAdapter(LogEntryAdapter());
  runApp(MyApp());
}

// Base color
const Color baseColor = Color.fromRGBO(0, 165, 146, 1.0); // r=0, g=165, b=146

// Primary swatch and accent color for light theme
const Color primarySwatchLight =
    Color.fromRGBO(0, 160, 141, 1.0); // r=0, g=160, b=141
const Color accentColorLight =
    Color.fromRGBO(44, 177, 119, 1.0); // r=44, g=177, b=119

// Primary swatch and accent color for dark theme
const Color primarySwatchDark =
    Color.fromRGBO(160, 155, 160, 1.0); // r=160, g=155, b=160
const Color accentColorDark =
    Color.fromRGBO(119, 170, 156, 1.0); // r=119, g=170, b=156

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exceltech-WiFi Client',
      themeMode: ThemeMode.light,
      theme: ThemeData(
        primarySwatch: MaterialColor(primarySwatchLight.value, {
          50: primarySwatchLight,
          100: primarySwatchLight,
          200: primarySwatchLight,
          300: primarySwatchLight,
          400: primarySwatchLight,
          500: primarySwatchLight,
          600: primarySwatchLight,
          700: primarySwatchLight,
          800: primarySwatchLight,
          900: primarySwatchLight,
        }),
        hintColor: accentColorLight,
        brightness: Brightness.light,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return splashScreen();
  }
}
