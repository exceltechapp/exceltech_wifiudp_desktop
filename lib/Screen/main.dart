
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:exceltech_wifiudp/Screen/chart/screen/chart.dart';
import 'package:exceltech_wifiudp/Screen/config/middleware/MiddlewareConfig.dart';
import 'package:exceltech_wifiudp/Screen/setting/screen/SettingScreen.dart';
import 'package:exceltech_wifiudp/Screen/view/graph.dart';
import 'package:exceltech_wifiudp/Screen/view/log.dart';
import 'package:exceltech_wifiudp/Screen/view/table.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../SEVER/SEVER.dart';
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

  static Widget SwitchView(var index) {
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
    if (index == 3) {
      //selectDeviceID = null;
      return Align(
        alignment: Alignment.center,
        child: ChartScreen(),
      );
    }
    if (index == 4) {
      //selectDeviceID = null;
      return Align(
        alignment: Alignment.center,
        child: MiddlewareConfig(),
      );
    }
    if (index == 5) {
      //selectDeviceID = null;
      return Align(
        alignment: Alignment.center,
        child: SettingView(),
      );
    }
    return Container();
  }

  @override
  void initState() {
    UDPHandler.startUDPConnection(context);
    SERVERHandler.getLocalIpAddressAsync().then((value){
      value.forEach((element) {
        print(element);
      });
    });
    super.initState();
  }

  //final Uri _url = Uri.parse('https://www.exceltechindia.com/');

  /*Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }*/

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
                          child: InkWell(
                            onTap: (){
                              //_launchUrl();
                            },
                            child: Image.asset("assets/icon.png"),
                          ),
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
                        /*Card(
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
                        ),*/
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
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          color: SwitchViewIndex == 3
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                          elevation: 0,
                          child: Padding(
                            padding: EdgeInsets.all(1),
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    SwitchViewIndex = 3;
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
                          color: SwitchViewIndex == 4
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                          elevation: 0,
                          child: Padding(
                            padding: EdgeInsets.all(1),
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    SwitchViewIndex = 4;
                                  });
                                },
                                icon: Icon(FontAwesomeIcons.add)),
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
                          color: SwitchViewIndex == 5
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                          elevation: 0,
                          child: Padding(
                            padding: EdgeInsets.all(1),
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    SwitchViewIndex = 5;
                                  });
                                },
                                icon: Icon(FontAwesomeIcons.gear)),
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
