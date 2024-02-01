import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../widget/TextFormField.dart';
import '../model/setConfig.dart';
import 'complete.dart';
import 'fail.dart';

class DeviceConfigWithWiFi extends StatefulWidget {
  const DeviceConfigWithWiFi({super.key, required this.WiFiObject, required this.eth});
  final Map<String, dynamic> WiFiObject;
  final bool eth;
  @override
  State<DeviceConfigWithWiFi> createState() => _DeviceConfigWithWiFiState();
}

class _DeviceConfigWithWiFiState extends State<DeviceConfigWithWiFi> {
  var Device_Index = 0;
  var selectedindex;
  var showpassword = true;
  var setDatabase = false;

  final List<String> itemsModel = [
    'µLEDX-T' /*0*/,
    'µeLEDX-T' /*1*/,
    "µLEDX" /*2*/,
    "µHLEDX-T" /*3*/,
    "TRINITY" /*4*/,
    "ELMEASURE LG 5110+" /*5*/
  ];
  String? selectedValue;

  Timer? timer;

  Timer? timerSetConfig;

  var showDisplay = false;
  var WiFi_STATUS = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<TextEditingController> listTextController = [];
  List<TextEditingController> listDropDownList = [];

  TextEditingController device_nameController = new TextEditingController();
  TextEditingController wifi_passwordController = new TextEditingController();

  void setConfig() async {
    bool success = false;
    int maxRetries = 30; // Define the maximum number of retries
    int currentRetry = 0; // Initialize current retry count
    if (this.mounted) {
      setState(() {
        showDisplay = false;
      });
    }
    var modelArray = [];
    var modelNameArray = [];

    listTextController.forEach((element) {
      modelArray.add(element.value.text);
    });
    listDropDownList.forEach((element) {
      modelNameArray.add(itemsModel.indexOf(element.value.text));
    });
    timerSetConfig =
        Timer.periodic(Duration(seconds: 5), (Timer t) => setConfig());
    DateTime now = DateTime.now();
    var rtc = now.toIso8601String().split(".").first;
    SetConfigModel newSetConfigModel = SetConfigModel(
        device_nameController.value.text.trim(),
        modelNameArray,
        modelArray,
        rtc,
        modelArray.length,
        widget.WiFiObject["name"],
        wifi_passwordController.value.text.trim());
    var payload = jsonEncode(newSetConfigModel.toJsonDevice());
    print(payload);
    var urlWifi = Uri.http('192.168.4.1', 'setConfig');
    var response = await http.post(
      urlWifi,
      headers: {"Content-Type": "application/json"},
      body: payload,
    );

    if (response.statusCode == 200) {
      print("done");
      //var ReWifi = Uri.http('192.168.4.1', 'Restart');
      print(response.body);
      //await http.get(ReWifi);
      success = true; // Set success to true to exit the loop
    } else if (response.statusCode != 200 && this.mounted) {
      print(response.statusCode);
      print(response.body);
      // You can add a delay here before retrying if needed
      await Future.delayed(Duration(seconds: 5));
    }
    if (success == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MessageComplete()),
      );
    } else {
      Timer.periodic(Duration(minutes: 1, seconds: 30), (timer) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MessageFail()),
        );
      });
    }
    currentRetry++;
  }

  void restartApp() {
    exit(0);
  }

  Future<void> getLastData() async {
    var url = Uri.http('192.168.4.1', 'getLastConfig');
    print(url);
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200 && this.mounted) {
      print("printing body data");
      print(jsonDecode(response.body)["Model"].runtimeType);
      var newModel = jsonDecode(response.body);
      //List<dynamic> newArr = newModel[""];
      List<dynamic> modelArray = newModel["Model"];
      List<dynamic> modelNameArray = newModel["Model_Name"];
      setState(() {
        device_nameController.text = newModel["DeviceName"];
        Device_Index = newModel["Index"];
        if (widget.WiFiObject["name"] == newModel["SSID"]) {
          wifi_passwordController.text = newModel["PASS"];
        }
        listTextController = List.generate(
          Device_Index,
          (_) => TextEditingController(),
        );
        listDropDownList = List.generate(
          Device_Index,
          (_) => TextEditingController(),
        );
        modelNameArray.forEach((element) {
          listTextController[modelNameArray.indexOf(element)].text = element;
        });
        print(modelArray);
        /*modelArray.forEach((element) {
          listDropDownList[modelArray.indexOf(element)].text = itemsModel[element];
        });*/
        for (int i = 0; i <= Device_Index - 1; i++) {
          listDropDownList[i].text = itemsModel[modelArray[i]];
        }
        showDisplay = true;
      });
    } else if (response.statusCode != 200 && this.mounted) {
      setState(() {
        var error = jsonDecode(response.body);
        if (error["ERROR"] == "FILE_NOT_EXISTS") {
          timer?.cancel();
          showDisplay = true;
        } else {
          timer =
              Timer.periodic(Duration(seconds: 1), (Timer t) => getLastData());
        }
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    timerSetConfig?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    getLastData();
    //showDisplay = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          backgroundColor: Color.fromRGBO(0, 165, 146, 1),
          centerTitle: true,
          title: Text("MSD Device Config"),
        ),
        preferredSize: Size.square(50),
      ),
      body: SingleChildScrollView(
        child: showDisplay
            ? Form(
                key: _formKey,
                child: Column(
                  children: [
                   widget.eth == false ? Padding(
                      padding: EdgeInsets.all(10),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          //<-- SEE HERE
                          side: BorderSide(width: 0.7, color: Colors.black54),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Selected WiFi: ",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54),
                            )
                          ],
                        ),
                        title: Text(
                          widget.WiFiObject["name"],
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ) : Container(),
                    widget.eth == false ? widget.WiFiObject["open"] == false
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 5),
                            child: textFieldForm(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter WiFi Password';
                                }
                                if (value.length < 8) {
                                  return 'Please Enter Valid WiFi Password';
                                }
                                return null;
                              },
                              obscureText: showpassword,
                              labelText: "Password",
                              controller: wifi_passwordController,
                              icon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    showpassword = !showpassword;
                                  });
                                },
                                icon: showpassword
                                    ? const Icon(
                                        FontAwesomeIcons.eyeSlash,
                                        color: Color.fromRGBO(0, 165, 146, 1),
                                        size: 20,
                                      )
                                    // ignore: dead_code
                                    : const Icon(
                                        FontAwesomeIcons.eye,
                                        color: Color.fromRGBO(0, 165, 146, 1),
                                        size: 20,
                                      ),
                              ),
                            ),
                          )
                        : Container() : Container(),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                      child: textFieldForm(
                        validator: (value) {
                          if (value!.isEmpty) {
                            //Fluttertoast.showToast(msg: "Plase Enter Device Name",textColor: Colors.redAccent);
                            return 'Please Enter Device Name';
                          }
                          return null;
                        },
                        obscureText: false,
                        controller: device_nameController,
                        labelText: "Device Name",
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                      child: DropdownButtonFormField2<String>(
                        dropdownStyleData: const DropdownStyleData(
                          maxHeight: 200,
                        ),
                        isExpanded: true,
                        decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(0, 165, 146, 1))),
                          // Add Horizontal padding using menuItemStyleData.padding so it matches
                          // the menu padding when button's width is not specified.
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          // Add more decoration..
                        ),
                        hint: const Text(
                          'Select Number of Device',
                          style: TextStyle(fontSize: 14),
                        ),
                        items: List<DropdownMenuItem<String>>.generate(
                            33,
                            (index) => DropdownMenuItem<String>(
                                value: "${index}",
                                child: Text(
                                  "${index}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ))),
                        validator: (value) {
                          if (value == null) {
                            return 'Please Select Numbers of Device.';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            Device_Index = int.parse(value!);
                          });
                          if (Device_Index <= listTextController.length) {
                            for (int i = Device_Index-1;
                                i <= listTextController.length;
                                i++) {
                              setState(() {
                                listTextController
                                    .remove(listTextController.last);
                                listDropDownList
                                    .remove(listDropDownList.last);
                              });
                            }
                          }
                          for (int i = listTextController.length;
                              i <= Device_Index - 1;
                              i++) {
                            setState(() {
                              listTextController.add(TextEditingController());
                              listDropDownList.add(TextEditingController());
                            });
                          }
                          for (int i = 0; i <= Device_Index - 1; i++) {
                            listTextController[i].text = "MPD-${i + 1}";
                          }
                        },
                        onSaved: (value) {
                          setState(() {
                            Device_Index = int.parse(value!);
                          });
                        },
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.only(right: 8),
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black45,
                          ),
                          iconSize: 28,
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        ),
                        value: "${Device_Index.toString()}",
                      ),
                    ),
                    Device_Index != 0
                        ? ListView.builder(
                            itemCount: Device_Index,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Divider(
                                      thickness: 1.2,
                                      indent: 9,
                                      endIndent: 9,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 0),
                                      child: Container(
                                        decoration: new BoxDecoration(
                                          color:
                                              Color.fromRGBO(0, 165, 146, 0.5),
                                          borderRadius: new BorderRadius.only(
                                              topRight: Radius.circular(30.0),
                                              bottomRight:
                                                  Radius.circular(30.0)),
                                          border: new Border.all(
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.0)),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          child: Text('No ${index + 1}',
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black87)),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 0),
                                      child: textFieldForm(
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            // Fluttertoast.showToast(msg: "Plase Enter Device Name",textColor: Colors.redAccent);
                                            return 'Please Enter Name at ${index + 1}';
                                          }
                                          return null;
                                        },
                                        controller: listTextController[index],
                                        obscureText: false,
                                        labelText: "Name",
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 5),
                                      child: DropdownButtonFormField2<String>(
                                        isExpanded: true,
                                        decoration: InputDecoration(
                                          // Add Horizontal padding using menuItemStyleData.padding so it matches
                                          // the menu padding when button's width is not specified.
                                          focusedBorder:
                                              const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color.fromRGBO(
                                                          0, 165, 146, 1))),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 16),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          // Add more decoration..
                                        ),
                                        hint: Text(
                                          'Select Model',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        items: itemsModel
                                            .map((item) =>
                                                DropdownMenuItem<String>(
                                                  value: "${item}",
                                                  child: Text(
                                                    "${item}",
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Please Select Model.';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            setState(() {
                                              listDropDownList[index].text =
                                                  value!;
                                              print(value);
                                            });
                                          });
                                        },
                                        value: listDropDownList[index]
                                                .value
                                                .text
                                                .isNotEmpty
                                            ? listDropDownList[index].value.text
                                            : null,
                                        onSaved: (value) {},
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
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                        menuItemStyleData:
                                            const MenuItemStyleData(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            })
                        : Divider(
                            thickness: 1.2,
                            indent: 9,
                            endIndent: 9,
                          ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: ElevatedButton(
                          style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Color.fromRGBO(0, 165, 146, 1))),
                          child: Text("SET",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700)),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setConfig();
                            }
                          }),
                    )
                  ],
                ),
              )
            : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    color: Color.fromRGBO(0, 165, 146, 1),
                  ),
                ),
              ),
      ),
    );
  }
}
