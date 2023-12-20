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
  // define set for getting current device
  Set<dynamic> DeviceList = {};
  // Controller to handle bottom nav bar and also handles initial page
  final _controller = NotchBottomBarController(index: 0);
  var SwitchViewIndex = 0;
  bool WaitTimeCountDeviceListBool = false;
  // select device name
  var selectDevice;

  void getDevice() {
    UDPHandler.eventsStream.listen((event) {
      var decodeEvent = jsonDecode(event);
      DeviceId newDeviceModel =
          DeviceId(decodeEvent["DEN"], decodeEvent["MAC"],decodeEvent["SIZE"]);
      if (this.mounted) {
        setState(() {
          DeviceList.add(jsonEncode(newDeviceModel.mapModel()));
        });
      }
    });
  }

  WaitTimeCountDeviceList() {
    Timer mytimer = Timer.periodic(Duration(minutes: 1, seconds: 10), (timer) {
      if (this.mounted) {
        setState(() {
          WaitTimeCountDeviceListBool = true;
        });
      }
    });
    if (WaitTimeCountDeviceListBool == false) {
      bool calledOnce = true;
      if (calledOnce == true) {
        getDevice();
        if (this.mounted) {
          setState(() {
            calledOnce = false;
          });
        }
      }
      return CircularProgressIndicator();
    } else {
      mytimer.cancel();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: IconButton(
              icon: Icon(Icons.restart_alt),
              onPressed: () {
                if (this.mounted) {
                  setState(() {
                    WaitTimeCountDeviceListBool = false;
                  });
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text("Device's Not Found"),
          )
        ],
      );
    }
  }

  SwitchView(var index) {
    if (index == 0) {
      return tableView(
        MapModel: selectDevice,
      );
    }
    if (index == 1) {
      return Align(
        alignment: Alignment.center,
        child: graphView(),
      );
    }
    if (index == 2) {
      return Align(
        alignment: Alignment.center,
        child: logView(),
      );
    }
  }

  @override
  void initState() {
    UDPHandler.startUDPConnection(context);
    getDevice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DeviceList.isEmpty
          ? Center(
              child: WaitTimeCountDeviceList(),
            )
          : Row(
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
                                icon: Icon(FontAwesomeIcons.gauge)),
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
                                icon: Icon(FontAwesomeIcons.chartLine)),
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
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 200,
                        child: DropdownButtonFormField2<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                            // Add Horizontal padding using menuItemStyleData.padding so it matches
                            // the menu padding when button's width is not specified.
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            // Add more decoration..
                          ),
                          hint: const Text(
                            'Select MSD Device',
                            style: TextStyle(fontSize: 14),
                          ),
                          items:
                              DeviceList.map((item) => DropdownMenuItem<String>(
                                    value: item.toString(),
                                    child: Text(
                                      jsonDecode(item)["DeviceName"],
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  )).toList(),
                          validator: (value) {
                            if (value == null) {
                              return 'Please select MSD Device.';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            //Do something when selected item is changed.
                            setState(() {
                              selectDevice = value;
                            });
                          },
                          onSaved: (value) {
                            // selectedValue = value.toString();
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.only(right: 8),
                          ),
                          iconStyleData: const IconStyleData(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black45,
                            ),
                            iconSize: 24,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      ),
                    ),
                    SwitchView(SwitchViewIndex)
                  ],
                ))
              ],
            ),
    );
  }
}
