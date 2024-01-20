import 'dart:async';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'CheckWiFiMiddleware.dart';

class MiddlewareConfig extends StatefulWidget {
  const MiddlewareConfig({super.key});

  @override
  State<MiddlewareConfig> createState() => _MiddlewareConfigState();
}

class _MiddlewareConfigState extends State<MiddlewareConfig> {
  var MessageNetworkType;
  bool ShowError = false;
  bool ShowWhenBack = false;

  void GetNetworkFunction() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      if (this.mounted) {
        setState(() {
          MessageNetworkType = "mobile";
          ShowError = true;
        });
      }
      // I am connected to a mobile network.
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      if (this.mounted) {
        setState(() {
          MessageNetworkType = "wifi";
          ShowWhenBack = true;
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CheckWiFiMiddleware()));
        });
      }
    } else if (connectivityResult == ConnectivityResult.ethernet) {
      // I am connected to a ethernet network.
      if (this.mounted) {
        setState(() {
          MessageNetworkType = "ethernet";
          ShowError = true;
        });
      }
    } else if (connectivityResult == ConnectivityResult.vpn) {
      // I am connected to a vpn network.
      // Note for iOS and macOS:
      // There is no separate network interface type for [vpn].
      // It returns [other] on any device (also simulator)
      if (this.mounted) {
        setState(() {
          MessageNetworkType = "vpn";
          ShowError = true;
        });
      }
    } else if (connectivityResult == ConnectivityResult.bluetooth) {
      // I am connected to a bluetooth.
      if (this.mounted) {
        setState(() {
          MessageNetworkType = "bluetooth";
          ShowError = true;
        });
      }
    } else if (connectivityResult == ConnectivityResult.other) {
      if (this.mounted) {
        setState(() {
          MessageNetworkType = "other";
          ShowError = true;
        });
      }
      // I am connected to a network which is not in the above mentioned networks.
    } else if (connectivityResult == ConnectivityResult.none) {
      // I am not connected to any network.

      if (this.mounted) {
        setState(() {
          MessageNetworkType = "wifi";
          ShowWhenBack = true;
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CheckWiFiMiddleware()));
        });
      }
    }
    print(MessageNetworkType);
  }

  @override
  void initState() {
    Timer(Duration(seconds: 4), () => GetNetworkFunction());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ShowWhenBack != true
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ShowError == false
                  ? CircularProgressIndicator()
                  : Icon(
                      Icons.error,
                      color: Colors.redAccent,
                      size: 100.0,
                    ),
              ShowError == false
                  ? Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Checking Network Type",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "The network type is not supported for the configuration used on the device with WiFi",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
            ],
          )
        : Center(
            child: IconButton(
                onPressed: () {
                  if (this.mounted) {
                    setState(() {
                      ShowWhenBack = false;
                      Timer(Duration(seconds: 2), () => GetNetworkFunction());
                    });
                  }
                },
                icon: Icon(Icons.refresh)),
          );
  }
}
