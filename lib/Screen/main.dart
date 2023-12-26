import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:exceltech_wifiudp/Screen/view/graph.dart';
import 'package:exceltech_wifiudp/Screen/view/log.dart';
import 'package:exceltech_wifiudp/Screen/view/table.dart';
import 'package:exceltech_wifiudp/model/DeviceId.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../UDP/UDP.dart';

class mainScreen extends StatefulWidget {
  const mainScreen({super.key});

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  // Controller to handle bottom nav bar and also handles initial page
  final _controller = NotchBottomBarController(index: 0);
  var SwitchViewIndex = 0;
  // select device name
  var selectDevice;
  var selectDeviceID;

  SwitchView(var index) {
    if (index == 0) {
      return tableView();
    }
    if (index == 1) {
      //selectDeviceID = null;
      return Align(
        alignment: Alignment.center,
        child: graphView(),
      );
    }
    if (index == 2) {
      //selectDeviceID = null;
      return Align(
        alignment: Alignment.center,
        child: logView(),
      );
    }
  }

  @override
  void initState() {
    UDPHandler.startUDPConnection(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Drawer(
                  backgroundColor: Theme.of(context).primaryColor,
                  elevation: 40,
                  width: 63,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: SingleChildScrollView(
                    child: ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Image.asset("assets/icon.png"),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          color: SwitchViewIndex == 0
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                          elevation: 0,
                          child: Padding(
                            padding: EdgeInsets.all(1),
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    SwitchViewIndex = 0;
                                  });
                                },
                                icon: Icon(FontAwesomeIcons.table)),
                          ),
                        ),
                        Divider(
                          endIndent: 16,
                          indent: 16,
                          thickness: 1.3,
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          color: SwitchViewIndex == 1
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                          elevation: 0,
                          child: Padding(
                            padding: EdgeInsets.all(1),
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    SwitchViewIndex = 1;
                                  });
                                },
                                icon: Icon(FontAwesomeIcons.chartLine)),
                          ),
                        ),
                        Divider(
                          endIndent: 16,
                          indent: 16,
                          thickness: 1.3,
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          color: SwitchViewIndex == 2
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                          elevation: 0,
                          child: Padding(
                            padding: EdgeInsets.all(1),
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    SwitchViewIndex = 2;
                                  });
                                },
                                icon: Icon(FontAwesomeIcons.file)),
                          ),
                        ),
                        Divider(
                          endIndent: 16,
                          indent: 16,
                          thickness: 1.3,
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(child: SwitchView(SwitchViewIndex))
              ],
            ),
    );
  }
}
