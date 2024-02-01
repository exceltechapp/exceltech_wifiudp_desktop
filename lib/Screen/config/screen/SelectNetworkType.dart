import 'package:flutter/material.dart';

import '../middleware/CheckWiFiMiddleware.dart';
import 'DeviceConfigWIthWiFi.dart';

class SelectDeviceNetworkType extends StatefulWidget {
  const SelectDeviceNetworkType({super.key});

  @override
  State<SelectDeviceNetworkType> createState() =>
      _SelectDeviceNetworkTypeState();
}

class _SelectDeviceNetworkTypeState extends State<SelectDeviceNetworkType> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CheckWiFiMiddleware()));
                },
                child: SizedBox(
                  width: 150,
                  height: 180,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.wifi,
                          size: 40,
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "WIFI",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DeviceConfigWithWiFi(WiFiObject: {}, eth: true,)),
                  );
                },
                child: SizedBox(
                  width: 150,
                  height: 180,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.settings_ethernet,
                          size: 40,
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Ethernet",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
