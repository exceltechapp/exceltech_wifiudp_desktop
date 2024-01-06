import 'dart:async';
import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../UDP/UDP.dart';
import '../../model/DeviceId.dart';
import '../../model/DeviceJson.dart';

class tableView extends StatefulWidget {
  const tableView({super.key});
  @override
  State<tableView> createState() => _tableViewState();
}

class _tableViewState extends State<tableView> {
  var condition = [
    "CONNECTED", //0
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
  // define bool for getting device OFFLINE OR ONLINE
  bool device_offline_sate = false;
  Timer? TimerDeviceOfflineSate;
  // define set for getting current device
  Set<dynamic> DeviceList = {};
  // define List for Saving DeviceList
  Set<String> SPDeviceList = {};
  // define list for getting DeviceDataList
  List<dynamic> DeviceDataList = [];

  var LockVar = 1;
  var selectDevice;

  bool WaitTimeCountDeviceListBool = false;
  bool DataRev = false;
  int LOCKClear = 3;

  getElemantTable() {
    if (selectDevice != null) {
      var mac = jsonDecode(selectDevice)["DeviceMac"];
      TimerDeviceOfflineSate = Timer(Duration(minutes: 2), () {
        print("Timer called");
        if(DataRev == true){
          TimerDeviceOfflineSate?.cancel();
        }
        // Clear DeviceData after 3 minutes if no data received within that period
        if (this.mounted && DataRev == false && LOCKClear == 1) {
          setState(() {
            print("Function called for rest");
            // Reset the flag for the next cycle
            DataRev = false;
            LOCKClear = 0;
            DeviceDataList.clear();
            DeviceDataList = List<DeviceJson>.from(List<DeviceJson>.generate(
                32, (index) => DeviceJson(ID: index + 1)));
            TimerDeviceOfflineSate?.cancel();
          });
        }
      });
      UDPHandler.eventsStream.listen((event) {
        var liveMac = jsonDecode(event)["MAC"];
        if (liveMac == mac &&
            jsonDecode(selectDevice)["DeviceName"] ==
                jsonDecode(event)["DEN"]) {
          if (this.mounted) {
            setState(() {
              //TimerDeviceOfflineSate?.cancel();
              TimerDeviceOfflineSate?.cancel();
              DataRev = true;
              LOCKClear = 0;
              var id = jsonDecode(event)["ID"];
              DeviceJson newData = DeviceJson.fromJson(jsonDecode(event));
              DeviceDataList[id - 1] = newData;
            });
          }
        }else{
          if(this.mounted){
            setState(() {
              TimerDeviceOfflineSate?.cancel();
              DataRev = false;
              LOCKClear = 1;
            });
          }
        }
      });
      return DeviceDataList.toList().map((e1) {
        DeviceJson dataClass = e1;
        var e = dataClass.toJson();
        return DataRow(cells: [
          DataCell(Align(
            alignment: Alignment.center,
            child: Text(
              '${e["ID"] ?? "-"}',
              style: TextStyle(overflow: TextOverflow.ellipsis),
            ),
          )),
          DataCell(Align(
              alignment: Alignment.center,
              child: Text("${e["IDN"] ?? "-"}",
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
                        style: TextStyle(overflow: TextOverflow.ellipsis))
                    : Text("DISCONNECT")),
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
                        style: TextStyle(overflow: TextOverflow.ellipsis))
                    : Text("-")),
          )),
        ]);
      }).toList();
    } else {
      return List<DataRow>.generate(0, (index) {
        return DataRow(cells: [
          DataCell(Align(
            alignment: Alignment.center,
            child: Text(index.toString()),
          )),
          DataCell(Align(
              alignment: Alignment.center,
              child: Text(
                (10 - index % 10).toString(),
              ))),
          DataCell(Align(
              alignment: Alignment.center,
              child: Text(
                (10 - index % 10).toString(),
              ))),
          DataCell(Align(
              alignment: Alignment.center,
              child: Text(
                (10 - index % 10).toString(),
              ))),
          DataCell(Align(
              alignment: Alignment.center,
              child: Text(
                (10 - index % 10).toString(),
              ))),
          DataCell(Align(
              alignment: Alignment.center,
              child: Text(
                (10 - index % 10).toString(),
              ))),
          DataCell(Align(
              alignment: Alignment.center,
              child: Text(
                (10 - index % 10).toString(),
              ))),
          DataCell(Align(
              alignment: Alignment.center,
              child: Text(
                (10 - index % 10).toString(),
              ))),
          DataCell(Align(
              alignment: Alignment.center,
              child: Text(
                (10 - index % 10).toString(),
              ))),
          DataCell(Align(
              alignment: Alignment.center,
              child: Text(
                (10 - index % 10).toString(),
              ))),
          DataCell(Align(
              alignment: Alignment.center,
              child: Text(
                (10 - index % 10).toString(),
              ))),
          DataCell(Align(
              alignment: Alignment.center,
              child: Text(
                (10 - index % 10).toString(),
              ))),
          DataCell(Align(
              alignment: Alignment.center,
              child: Text(
                (10 - index % 10).toString(),
              ))),
          DataCell(Align(
              alignment: Alignment.center,
              child: Text(
                (10 - index % 10).toString(),
              ))),
        ]);
      });
    }
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

  // define function save to preferences
  GetPreferences(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Try reading data from the 'items' key. If it doesn't exist, returns null.
    final List<String>? items = prefs.getStringList(key);
    return items;
  }

  void getDevice() {
    UDPHandler.eventsStream.listen((event) {
      var decodeEvent = jsonDecode(event);
      DeviceId newDeviceModel =
          DeviceId(decodeEvent["DEN"], decodeEvent["MAC"], decodeEvent["SIZE"]);
      if (this.mounted) {
        setState(() {
          DeviceList.add(jsonEncode(newDeviceModel.mapModel()));
          SPDeviceList.add(jsonEncode(newDeviceModel.mapModel()));
          if (DeviceList.isNotEmpty) {
            //selectDevice = DeviceList.first;
          }
        });
      }
    });
    if (this.mounted) {
      setState(() {
        DeviceDataList = List<DeviceJson>.from(List<DeviceJson>.generate(
            32, (index) => DeviceJson(ID: index + 1)));
      });
    }
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

  @override
  void initState() {
    getDevice();
    super.initState();
  }

  @override
  void dispose() {
    TimerDeviceOfflineSate?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SavePreferences("DeviceNameList", SPDeviceList.toList());
    return DeviceList.isEmpty
        ? Center(
            child: WaitTimeCountDeviceList(),
          )
        : Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 200,
                  child: DropdownButtonFormField2<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      // Add more decoration..
                    ),
                    //value: jsonDecode(selectDevice) == null ? "" : jsonDecode(selectDevice).toString(),
                    hint: const Text(
                      'Select MSD Device',
                      style: TextStyle(fontSize: 14),
                    ),
                    items: DeviceList.map((item) => DropdownMenuItem<String>(
                              value: item.toString(),
                              child: Text(
                                jsonDecode(item)["DeviceName"],
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ))
                        .toSet()
                        .toList(), // Use toSet() to remove duplicates and then convert back to a list
                    validator: (value) {
                      if (value == null) {
                        return 'Please select MSD Device.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        DeviceDataList.clear();
                        DeviceDataList = List<DeviceJson>.from(
                            List<DeviceJson>.generate(
                                32, (index) => DeviceJson(ID: index + 1)));
                        selectDevice = value;
                        print(value);
                      });
                    },
                    onSaved: (value) {
                      selectDevice = value;
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
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: DataTable2(
                        columnSpacing: 0,
                        horizontalMargin: 0,
                        minWidth: 0,
                        dataRowHeight: 30,
                        headingRowColor:
                            MaterialStatePropertyAll(Colors.grey.shade300),
                        border: TableBorder.all(color: Colors.black26),
                        fixedTopRows: 1,
                        fixedLeftColumns: 1,
                        fixedColumnsColor: Colors.grey.shade300,
                        columns: [
                          DataColumn2(
                              label: Align(
                                alignment: Alignment.center,
                                child: Text('ID',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ),
                              size: ColumnSize.S),
                          DataColumn2(
                              label: Align(
                                alignment: Alignment.center,
                                child: Text('NAME',
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
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                DeviceList.isEmpty
                                    ? CircularProgressIndicator()
                                    : Container(),
                                DeviceList.isNotEmpty
                                    ? Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text("SELECT MSD DEVICE"),
                                      )
                                    : Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text("NO DATA"),
                                      )
                              ],
                            ),
                          ),
                        ),
                        rows: getElemantTable(),
                      )))
            ],
          );
  }
}
