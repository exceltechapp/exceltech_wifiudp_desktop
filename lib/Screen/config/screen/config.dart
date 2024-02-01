import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'DeviceConfigWIthWiFi.dart';

class config extends StatefulWidget {
  const config({super.key});

  @override
  State<config> createState() => _configState();
}

class _configState extends State<config> {
  var selectedindex;
  Timer? timer;
  var WiFi_list = [];
  var screen_control = true;
  void sendGetChipeID() async {
    var url = Uri.http('192.168.4.1', 'getChipID');
    print(url);
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200 && this.mounted) {
      setState(() {
        screen_control = true;
      });
      getWifiList();
    } else if (response.statusCode != 200 && this.mounted) {
      setState(() {
        screen_control = false;
      });
    }
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => getWifiList());
  }

  void getWifiList() async {
    var urlWifi = Uri.http('192.168.4.1', 'scanWIFI');
    var response = await http.get(urlWifi);
    if (response.statusCode == 200) {
      setState(() {
        WiFi_list = jsonDecode(response.body);
        if (WiFi_list.isNotEmpty) {

        }
        timer?.cancel();
        screen_control = true;
      });
      print(response.body);
    } else if (response.statusCode != 200 && this.mounted && response.statusCode != 202) {
      setState(() {
        screen_control = false;
      });
    }
  }

  @override
  void initState() {
    getWifiList();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => getWifiList());
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          backgroundColor: Color.fromRGBO(0, 165, 146, 1),
          centerTitle: true,
          title: Text("MSD Device Config"),
          actions: [
            IconButton(
                onPressed: () {
                  getWifiList();
                },
                icon: Icon(
                  FontAwesomeIcons.rotate,
                  size: 18,
                ))
          ],
        ),
        preferredSize: Size.square(50),
      ),
      body: screen_control
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: WiFi_list.isNotEmpty
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                              itemCount: WiFi_list.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: EdgeInsets.all(10),
                                  child: ListTile(
                                      shape: RoundedRectangleBorder(
                                        //<-- SEE HERE
                                        side: BorderSide(
                                            width: 2,
                                            color: selectedindex == index
                                                ? Color.fromRGBO(0, 165, 146, 1)
                                                : Colors.black54),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          selectedindex = index;
                                        });
                                      },
                                      selectedColor:
                                          Color.fromRGBO(0, 165, 146, 1),
                                      selected:
                                          selectedindex == index ? true : false,
                                      leading: const Icon(Icons.wifi),
                                      trailing: WiFi_list[index]["open"]
                                          ? Icon(FontAwesomeIcons.lockOpen)
                                          : Icon(FontAwesomeIcons.lock),
                                      title: Text(
                                          WiFi_list[index]["name"].toString(),
                                          overflow: TextOverflow.ellipsis)),
                                );
                              }),
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: ElevatedButton(
                              style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Color.fromRGBO(0, 165, 146, 1))),
                              child: Text("NEXT",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700)),
                              onPressed: () {
                                if(selectedindex != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DeviceConfigWithWiFi(
                                              WiFiObject:
                                              WiFi_list[selectedindex], eth: false,
                                            )),
                                  );
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 45,
                            height: 45,
                            child: CircularProgressIndicator(
                              strokeWidth: 5,
                              color: Color.fromRGBO(0, 165, 146, 1),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(30),
                            child: Text(
                              "Finding Near By WiFi",
                              style: TextStyle(fontSize: 20),
                            ),
                          )
                        ],
                      ),
                    ),
            )
          : Container(
              child: Center(
                child: Text("Please Reload"),
              ),
            ),
    );
  }
}
