import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:mini_server/mini_server.dart';

import '../Database/LogModel.dart';
import '../UDP/UDP.dart';

class SERVERHandler {
  static final MiniServer miniServer = MiniServer(
    host: '192.168.1.120',
    port: 8090,
  );
  static var payload = [];
  static var LastMinCheck;
  // Initialize the server automatically when the file is loaded
  static void initializeServer() {
    miniServer.get("/", (HttpRequest httpRequest) async {
      // Read the request body as a list of bytes
      var requestBodyBytes = await httpRequest.cast<Uint8List>().toList();
      // Decode the bytes as a UTF-8 string
      var requestBody = utf8.decode(requestBodyBytes[0]);
      // Parse the JSON body
      LastMinCheck = null;
      payload.clear();
      var jsonBody = json.decode(requestBody);
      if (jsonBody["DeviceMac"] != null &&
          jsonBody["startTime"] != null &&
          jsonBody["endTime"] != null) {
        List<LogEntry> _udp = await UDPHandler.getLogsByTimeRange(
            DateTime.parse(jsonBody["startTime"].toString()),
            DateTime.parse(jsonBody["endTime"].toString()));
        _udp.forEach((element) {
          if (element.data is String) {
            var RawData = jsonDecode(element.data);
            if (jsonBody["DeviceMac"] == RawData["MAC"]) {
              if (LastMinCheck != DateTime.parse(element.time).minute) {
                payload.add(element.data);
                print(element.data);
              }
            }
          }
        });
        return httpRequest.response.write(jsonEncode(payload));
      } else {
        return httpRequest.response.write("ERROR INVALID PAYLOAD");
      }
    });
  }
}
