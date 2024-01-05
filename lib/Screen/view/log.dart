import 'dart:async';
import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:exceltech_wifiudp/Screen/view/managelist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Database/LogModel.dart';
import '../../Function/excelfileexport.dart';
import '../../UDP/UDP.dart';
import '../../model/DeviceId.dart';
import '../../model/ExcelfileModel.dart';

class logView extends StatefulWidget {
  const logView({super.key});

  @override
  State<logView> createState() => _logViewState();
}

class _logViewState extends State<logView> {
  var condition = [
    "Healthy", //0
    "Single Phasing", //1
    "Unbalance", //2
    "Under current", //3
    "Overload", //4
    "Locked rotor", //5
    "Earth leakage", //6
    "Short circuit", //7
    "Phase reversal", //8
    "Low Voltage", //9
    "High Voltage", //10
    "Over Temperature", //11
    "Dry run", //12
    "", //13
    "", //14
    "", //15
    "Pre-overload", //16
    "High voltage Alarm & Pre-overload Alarm", //17
  ];
  var startTime;
  var endTime;
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
  // define list for log data elemant
  List<dynamic> newObjectDataList = [];
  // define function save to preferences
  GetPreferences(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Try reading data from the 'items' key. If it doesn't exist, returns null.
    final List<String>? items = prefs.getStringList(key);
    return items;
  }

  //define var for stop  loop
  bool buildLock = false;
  // define function save to preferences
  void SavePreferences(String key, List<String> payload) async {
    //
    if (buildLock == false) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      if (payload.isNotEmpty) {
        await prefs.setStringList(key, payload);
        buildLock = true;
      }
    }
  }

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

  // define buff var for last min
  var LastMinCheck;
  // func for getting log from hive
  void getLog(dynamic startTime, dynamic endTime) {
    UDPHandler.getLogsByTimeRange(DateTime.parse(startTime.toString()),
            DateTime.parse(endTime.toString()))
        .then(
      (List<LogEntry> logs) {
        if (selectDevice == null || selectDeviceId == null) {
          return;
        }
        var key = jsonDecode(selectDevice!)["DeviceMac"];
        logs.forEach((log) {
          if (log.data is String) {
            try {
              Map<String, dynamic> newdata = jsonDecode(log.data);
              print(newdata["ID"]);
              print(newdata["ID"] ==
                  int.parse(selectDeviceId.toString().split("-").last));
              if (newdata["ID"] ==
                      int.parse(selectDeviceId.toString().split("-").last) &&
                  newdata["MAC"] == key) {
                //var newModel = ExcelFileModel();
                ExcelFileModel newModel =
                    ExcelFileModel(DateTime.parse(log.time), newdata);
                if (LastMinCheck != DateTime.parse(log.time).minute) {
                  if (mounted) {
                    setState(() {
                      newObjectDataList.add(newModel);
                      LastMinCheck = DateTime.parse(log.time).minute;
                    });
                  }
                }
              }
            } catch (e) {
              print(e);
              // Handle JSON decoding error
            }
          }
        });
      },
    );
  }

  // func as widget to show table
  showTable() {
    return Expanded(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: DataTable2(
              columnSpacing: 0,
              horizontalMargin: 0,
              minWidth: 0,
              dataRowHeight: 30,
              headingRowColor: MaterialStatePropertyAll(Colors.grey.shade300),
              border: TableBorder.all(color: Colors.black26),
              fixedTopRows: 1,
              fixedLeftColumns: 1,
              fixedColumnsColor: Colors.grey.shade300,
              columns: [
                DataColumn2(
                    label: Align(
                      alignment: Alignment.center,
                      child: Text('No',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                    size: ColumnSize.S),
                DataColumn2(
                    label: Align(
                      alignment: Alignment.center,
                      child: Text('Date',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                    size: ColumnSize.L),
                DataColumn2(
                    label: Align(
                      alignment: Alignment.center,
                      child: Text('Time',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                    size: ColumnSize.L),
                DataColumn2(
                    label: Align(
                      alignment: Alignment.center,
                      child: Text('STATUS',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                    size: ColumnSize.L),
                DataColumn2(
                    label: Align(
                      alignment: Alignment.center,
                      child: Text('TH(%)',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                    size: ColumnSize.M),
                DataColumn2(
                    label: Align(
                      alignment: Alignment.center,
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: 'I',
                            style: GoogleFonts.robotoMono(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        WidgetSpan(
                          child: Transform.translate(
                            offset: const Offset(2, 7),
                            child: Text(
                              'R',
                              //superscript is usually smaller in size
                              //textScaleFactor: 0.7,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ])),
                    ),
                    size: ColumnSize.M),
                DataColumn2(
                    label: Align(
                      alignment: Alignment.center,
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: 'I',
                            style: GoogleFonts.robotoMono(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        WidgetSpan(
                          child: Transform.translate(
                            offset: const Offset(2, 7),
                            child: Text(
                              'Y',
                              //superscript is usually smaller in size
                              //textScaleFactor: 0.7,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ])),
                    ),
                    size: ColumnSize.M),
                DataColumn2(
                    label: Align(
                      alignment: Alignment.center,
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: 'I',
                            style: GoogleFonts.robotoMono(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        WidgetSpan(
                          child: Transform.translate(
                            offset: const Offset(2, 7),
                            child: Text(
                              'B',
                              //superscript is usually smaller in size
                              //textScaleFactor: 0.7,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ])),
                    ),
                    size: ColumnSize.M),
                DataColumn2(
                    label: Align(
                      alignment: Alignment.center,
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: 'V',
                            style: GoogleFonts.robotoMono(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic)),
                        WidgetSpan(
                          child: Transform.translate(
                            offset: const Offset(2, 7),
                            child: Text(
                              'RY',
                              //superscript is usually smaller in size
                              //textScaleFactor: 0.7,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ])),
                    ),
                    size: ColumnSize.M),
                DataColumn2(
                    label: Align(
                      alignment: Alignment.center,
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: 'V',
                            style: GoogleFonts.robotoMono(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic)),
                        WidgetSpan(
                          child: Transform.translate(
                            offset: const Offset(2, 7),
                            child: Text(
                              'YB',
                              //superscript is usually smaller in size
                              //textScaleFactor: 0.7,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ])),
                    ),
                    size: ColumnSize.M),
                DataColumn2(
                    label: Align(
                      alignment: Alignment.center,
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: 'V',
                            style: GoogleFonts.robotoMono(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic)),
                        WidgetSpan(
                          child: Transform.translate(
                            offset: const Offset(2, 7),
                            child: Text(
                              'BR',
                              //superscript is usually smaller in size
                              //textScaleFactor: 0.7,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ])),
                    ),
                    size: ColumnSize.M),
                DataColumn2(
                    label: Align(
                      alignment: Alignment.center,
                      child: Text('kW',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                    size: ColumnSize.M),
                DataColumn2(
                    label: Align(
                      alignment: Alignment.center,
                      child: Text('kWh',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                    size: ColumnSize.L),
                DataColumn2(
                    label: Align(
                      alignment: Alignment.center,
                      child: Text('PF',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                    size: ColumnSize.M),
                DataColumn2(
                    label: Align(
                      alignment: Alignment.center,
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: 'I',
                            style: GoogleFonts.robotoMono(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        WidgetSpan(
                          child: Transform.translate(
                            offset: const Offset(2, 7),
                            child: Text(
                              'E',
                              //superscript is usually smaller in size
                              //textScaleFactor: 0.7,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ])),
                    ),
                    size: ColumnSize.M),
                DataColumn2(
                    label: Align(
                      alignment: Alignment.center,
                      child: Text('OL-P',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                    size: ColumnSize.M),
              ],
              empty: Container(
                child: Align(
                  alignment: Alignment.center,
                  child: Text("SELECT DATE & TIME"),
                ),
              ),
              rows: newObjectDataList.toList().map((elemant) {
                int index = newObjectDataList.indexOf(elemant);
                ExcelFileModel newModel = elemant;
                var e = newModel.y;
                return DataRow(cells: [
                  DataCell(Align(
                    alignment: Alignment.center,
                    child: Text(
                      '${index + 1 ?? "-"}',
                      style: TextStyle(overflow: TextOverflow.ellipsis),
                    ),
                  )),
                  DataCell(Align(
                      alignment: Alignment.center,
                      child: Text(
                          "${newModel.x.toIso8601String().split("T").first ?? "-"}",
                          style: TextStyle(overflow: TextOverflow.ellipsis)))),
                  DataCell(Align(
                      alignment: Alignment.center,
                      child: Text(
                          "${newModel.x.toIso8601String().split("T").last.split("Z").first ?? "-"}",
                          style: TextStyle(overflow: TextOverflow.ellipsis)))),
                  DataCell(Container(
                    color: e["ERROR"] != 255 && e["ERROR"] != null
                        ? e["STATUS"] != 0 && e["ERROR"] != null
                            ? Colors.redAccent
                            : Colors.greenAccent.shade200
                        : Colors.transparent,
                    child: Align(
                        alignment: Alignment.center,
                        child: e["ERROR"] != 255 && e["ERROR"] != null
                            ? Text(
                                "${condition[e["STATUS"] >= condition.length ? 0 : e["STATUS"]] ?? "-"}",
                                style:
                                    TextStyle(overflow: TextOverflow.ellipsis))
                            : Text("-")),
                  )),
                  DataCell(Align(
                      alignment: Alignment.center,
                      child: e["ERROR"] != 255
                          ? Text('${e["TH"] ?? "-"}',
                              style: TextStyle(overflow: TextOverflow.ellipsis))
                          : Text("-"))),
                  DataCell(Align(
                      alignment: Alignment.center,
                      child: e["ERROR"] != 255
                          ? Text('${e["IR"] ?? "-"}',
                              style: TextStyle(overflow: TextOverflow.ellipsis))
                          : Text("-"))),
                  DataCell(Align(
                      alignment: Alignment.center,
                      child: e["ERROR"] != 255
                          ? Text('${e["IY"] ?? "-"}',
                              style: TextStyle(overflow: TextOverflow.ellipsis))
                          : Text("-"))),
                  DataCell(Align(
                      alignment: Alignment.center,
                      child: e["ERROR"] != 255
                          ? Text('${e["IB"] ?? "-"}',
                              style: TextStyle(overflow: TextOverflow.ellipsis))
                          : Text("-"))),
                  DataCell(Align(
                      alignment: Alignment.center,
                      child: e["ERROR"] != 255
                          ? Text('${e["VRY"] ?? "-"}',
                              style: TextStyle(overflow: TextOverflow.ellipsis))
                          : Text("-"))),
                  DataCell(Align(
                      alignment: Alignment.center,
                      child: e["ERROR"] != 255
                          ? Text('${e["VYB"] ?? "-"}',
                              style: TextStyle(overflow: TextOverflow.ellipsis))
                          : Text("-"))),
                  DataCell(Align(
                      alignment: Alignment.center,
                      child: e["ERROR"] != 255
                          ? Text('${e["VBR"] ?? "-"}',
                              style: TextStyle(overflow: TextOverflow.ellipsis))
                          : Text("-"))),
                  DataCell(Align(
                      alignment: Alignment.center,
                      child: e["ERROR"] != 255
                          ? Text('${e["KW"] ?? "-"}',
                              style: TextStyle(overflow: TextOverflow.ellipsis))
                          : Text("-"))),
                  DataCell(Align(
                      alignment: Alignment.center,
                      child: e["ERROR"] != 255
                          ? Text('${e["KWH"] ?? "-"}',
                              style: TextStyle(overflow: TextOverflow.ellipsis))
                          : Text("-"))),
                  DataCell(Align(
                      alignment: Alignment.center,
                      child: e["ERROR"] != 255
                          ? Text('${e["PF"] ?? "-"}',
                              style: TextStyle(overflow: TextOverflow.ellipsis))
                          : Text("-"))),
                  DataCell(Align(
                      alignment: Alignment.center,
                      child: e["ERROR"] != 255
                          ? Text('${e["IE"] ?? "-"}',
                              style: TextStyle(overflow: TextOverflow.ellipsis))
                          : Text("-"))),
                  DataCell(Container(
                    color: Colors.grey.shade300,
                    child: Align(
                        alignment: Alignment.center,
                        child: e["ERROR"] != 255
                            ? Text('${e["OLSV"] ?? "-"}',
                                style:
                                    TextStyle(overflow: TextOverflow.ellipsis))
                            : Text("-")),
                  )),
                ]);
              }).toList(),
            )));
  }

  // run once on page run
  @override
  void initState() {
    GetPreferences("DeviceNameList").then((x) {
      if(this.mounted){
        setState(() {
          DeviceList.addAll(x);
        });
      }
      print(x);
    });
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
                                //DeviceDataList.clear();
                                newObjectDataList.clear();
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
                                            32, (index) => 'ID-${index + 1}')
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
                                        newObjectDataList.clear();
                                        //DeviceDataList.clear();
                                        selectDeviceId = value;
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
                                          .subtract(const Duration(days: 3652)),
                                      startLastDate: DateTime.now().add(
                                        const Duration(days: 3652),
                                      ),
                                      endInitialDate: DateTime.now(),
                                      endFirstDate: DateTime(1600)
                                          .subtract(const Duration(days: 3652)),
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
                                      ),
                                    );
                                    FlutterToastr.show("Please Wait", context);
                                    if (mounted) {
                                      newObjectDataList.clear();
                                      startTime =
                                          dateTimeList?[0].toIso8601String();
                                      endTime =
                                          dateTimeList?[1].toIso8601String();
                                    }
                                    getLog(dateTimeList?[0].toIso8601String(),
                                        dateTimeList?[1].toIso8601String());
                                    print(
                                        "Start dateTime: ${dateTimeList?[0].toIso8601String()}");
                                    print(
                                        "End dateTime: ${dateTimeList?[1].toIso8601String()}");
                                  },
                                  icon: Icon(Icons.date_range)))
                          : Card(),
                      selectDevice != null &&
                              selectDeviceId != null &&
                              startTime != null &&
                              endTime != null
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              child: IconButton(
                                  onPressed: () {
                                    ExcelFile newfunc = ExcelFile(
                                        selectDevice,
                                        int.parse(selectDeviceId
                                            .toString()
                                            .split("-")
                                            .last));
                                    newfunc.getLog(startTime, endTime);
                                  },
                                  icon: Icon(Icons.file_download)))
                          : Card(),
                    ],
                  ),
                  selectDevice != null && selectDeviceId != null
                      ? showTable()
                      : Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              CircularProgressIndicator(),
                              DeviceList.isNotEmpty && selectDevice == null? Padding(padding: EdgeInsets.all(20),child: Text("SELECT MSD DEVICE"),):Container(),
                              selectDevice != null && selectDeviceId == null? Padding(padding: EdgeInsets.all(20),child: Text("SELECT ID"),) : Container()
                            ],
                          ))
                ],
              ));
  }
}
