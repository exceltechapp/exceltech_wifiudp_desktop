import 'dart:async';
import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

import '../../UDP/UDP.dart';
import '../../model/DeviceId.dart';

class logView extends StatefulWidget {
  const logView({super.key});

  @override
  State<logView> createState() => _logViewState();
}

class _logViewState extends State<logView> {
  // define vairable for device
  var selectDevice;
  // define variable for device id
  var selectDeviceId;
  // define set for wait timecount devicelistbool
  bool WaitTimeCountDeviceListBool = false;
  // define set for getting current device
  Set<dynamic> DeviceList = {};
  // define list for getting DeviceDataList
  List<dynamic> DeviceDataList = [];
  // define function for getdevice
  void getDevice() {
    UDPHandler.eventsStream.listen((event) {
      var decodeEvent = jsonDecode(event);
      DeviceId newDeviceModel =
      DeviceId(decodeEvent["DEN"], decodeEvent["MAC"], decodeEvent["SIZE"]);
      if (this.mounted) {
        setState(() {
          DeviceList.add(jsonEncode(newDeviceModel.mapModel()));
        });
      }
    });
  }
  // define function for init timeout
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
  // run once on page run
  @override
  void initState() {
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
            : Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                      items: DeviceList.map(
                              (item) => DropdownMenuItem<String>(
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
                selectDevice != null
                    ? Padding(
                  padding: EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 200,
                      child: DropdownButtonFormField2<String>(
                        isExpanded: true,
                        decoration: InputDecoration(
                          // Add Horizontal padding using menuItemStyleData.padding so it matches
                          // the menu padding when button's width is not specified.
                          contentPadding:
                          const EdgeInsets.symmetric(
                              vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          // Add more decoration..
                        ),
                        hint: const Text(
                          'Select MSD Device ID',
                          style: TextStyle(fontSize: 14),
                        ),
                        items: List.generate(
                            32, (index) => 'ID-${index+1}')
                            .map((device) => DropdownMenuItem(
                          value: device,
                          child: Text(device),
                        ))
                            .toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select MSD Device ID.';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          //Do something when selected item is changed.
                          setState(() {
                            //selectDevice = value;
                            selectDeviceId=value;
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
                          padding:
                          EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                  ),
                )
                    : Container(),
                selectDevice != null && selectDeviceId != null
                    ? Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 5, horizontal: 15),
                    child: IconButton(
                        onPressed: () async {
                          List<DateTime>? dateTimeList =
                          await showOmniDateTimeRangePicker(
                            context: context,
                            startInitialDate: DateTime.now(),
                            startFirstDate: DateTime(1600)
                                .subtract(
                                const Duration(days: 3652)),
                            startLastDate: DateTime.now().add(
                              const Duration(days: 3652),
                            ),
                            endInitialDate: DateTime.now(),
                            endFirstDate: DateTime(1600).subtract(
                                const Duration(days: 3652)),
                            endLastDate: DateTime.now().add(
                              const Duration(days: 3652),
                            ),
                            is24HourMode: true,
                            isShowSeconds: false,
                            minutesInterval: 1,
                            secondsInterval: 1,
                            isForce2Digits: true,
                            borderRadius: const BorderRadius.all(
                                Radius.circular(16)),
                            constraints: const BoxConstraints(
                              maxWidth: 350,
                              maxHeight: 750,
                            ),);
                          FlutterToastr.show("Please Wait", context);
                          if (mounted) {
                            //startTime = dateTimeList?[0].toIso8601String();
                            //endTime = dateTimeList?[1].toIso8601String();
                          }
                          print(
                              "Start dateTime: ${dateTimeList?[0].toIso8601String()}");
                          print(
                              "End dateTime: ${dateTimeList?[1].toIso8601String()}");
                        },
                        icon: Icon(Icons.date_range)))
                    : Card()
              ],
            )
          ],
        ));
  }
}
