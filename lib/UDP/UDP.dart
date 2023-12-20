import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../AES/AES.dart';
import '../Database/LogModel.dart';

class UDPHandler {
  static RawDatagramSocket? _udpSocket;
  static StreamSubscription<String>? _sseSubscription;
  static StreamController<String> _eventsStreamController =
      StreamController.broadcast();

  static Stream<String> get eventsStream => _eventsStreamController.stream;
  static void startUDPConnection(BuildContext context) {
    AES decoder = AES();
    if (_udpSocket == null) {
      RawDatagramSocket.bind(InternetAddress.anyIPv4, 12121)
          .then((RawDatagramSocket socket) {
        _udpSocket = socket;
        _udpSocket!.listen((RawSocketEvent event) {
          if (event == RawSocketEvent.read) {
            Datagram? datagram = _udpSocket?.receive();
            if (datagram != null) {
              // Check if datagram is not null
              String eventData = utf8.decode(datagram.data);
              var payload = utf8.decode(base64.decode(eventData));
              var XORDecode = decoder.xorEncode(payload,
                  "eyJhbGciOiJIUzUxMiJ9.eyJkYXRhIjoiTUlJRXZnSUJBREFOQmdrcWhraUc5dzBCQVFFRkFBU0NCS2d3Z2dTa0FnRUFBb0lCQVFDcVBZSCtEbU81QStXcyB0QWFRVERuYzNoR0p6YnhKdWxmZnM1Z3RUWWFBa0xjL0sxYkZmM1lnSVdNSHBNYWtLOHM1WEYvaDBDbDZROWUyIHNOVWYyWmV6TGoxL2pzbHQvWUtjR1NsS0RFVHVDN2ZOQnkybk5HTGEwakhobTFvRW8yWEtIVkNpSXkrenRaTVEgTlJlMmhOVDBVZ3RQOVplQkZQcVNSMFZLblU0c2xwNEVXdldKenFVRHZuQklyeFJOUUQvZ0dXOEhlVHZxQ1NuYiBqVjNtOUN2UmFFQ0QyMUE0c0NxM1VrcnBHYXlBZ3Z2MEpMVFdlNi9naFpOc3ZDbUVrYm1rZG1MbHFMdG1rMDd4IDIvWU91TFdJZVhmMCtBMkdKRVhFWEhCRnRCNkNxTEN5SFB6Nzk0ZHhkVXhkY3pqQWhyeGlpVXZ5ZHZ4KzUxYWEgSXRYOXd4Ny9BZ01CQUFFQ2dnRUFQU0NReUpTS0lpalFFMDhnL0RjaW43ZnRQRG52WGRuWEs2L2srSDlaeUZndSBORFJ2bDhMSXU0akJja0VzUWs2blRoVnBLRUFDWkxCdmlGMithUTFNZHo0blB1SWFXYkFwY2J0bkkvdDcxSzNJIGRZb2FUbXQxQTNWdUM4QW9kbm5sVnNsbjVwQVQxTWRoNHZQdGE5QU9WeHdPaTh0M2R4WDlVd0RjVklwZlE0ckwgYnNLTzlXOEFQdURaSnFWa2cwVGx0MFF5R3dJMVZOOG5YYWZ4OWpheWxFTmpLZlF0YWdsaFh3ZnJaRHNOT0ZqdSBIZTczakRSemFMOWlLalo0T3lUVW5JUStxS1BVVnd3c3VXT3JXbUJsZnp2aVdLQ3lBWTlnMTNQNFpONk1BMHR0IHM0YmFWeDJlRjlEdDRQVGd5LzMyM1dQNGN1MlVqNnBSY3hRWFp6Z21ZUUtCZ1FEWmVpaTJWSFVNWUpPK3NibW4gL2ZRK3gzaTdEdWJQczRPQzBkdmdUcmw1Q0g1YVVFUnVTWGFzSDhxb0ZNb3pNMG1BR3kzR2FVUXNKRUhCWDhoMiBoQnk4eEJnTFV5dlozc3lHclR0eFlTQU5vWGRUYzNvTGJNMlV1a0NZdUhWQkZnL1d6N2s4cUo1S3BvM09tOFJKIElhUkc1NHFqRVFOa3lwZm1BMmJvRmMyVTh3S0JnUURJWlZFMkJ0cTdLd0psOXpydEVHYnQ4cDVBVVBLc3RtaHogZ2MyRXdFeTBma09BMXdvcFJueFhIbi8rbWU0U0xWa1hzQmVOT1ArbEw0R2Z1c25QbmdPVy9oK2xSK0FzQ21kUCArWm8rZHorZ0I3ZC9MNXRsVlNndzhZT0tXTHYyS2hHQ0Nkb1hvNkoxM25RRzVXRWNteHk4KzZOdWlldWM5TVMrIG85Qy9BUktBeFFLQmdRRE56WmVuYStkVWJqU0N1bWRKL2I1Y2hxSE95enhMZzhMSlV0Vnp3S3d1U0laaDZ5SEggQ0loZ1BMbW9NL3hoVllDUjFhYU00K01hcnJqM1NUQklUNTl1VjFlMXArQ1FqaElZeE9qQzA3bmtqRStDem4zSiBRQTZRVjIxMzJOOUZWNTVubHkzaHBHUWZtdHdKa0VqQk9DL2cxWTdSMy9ESk9odGpGUWNXVEVPL1Z3S0JnRUFwIEtFcExBWWRCcXYvb20wWkJwU0wwTmpUVGRnOVVTN2NIelR4K3NWQnN5TUljbDVWRml4UDlvTzlzYTJ3SWR1ajkgcVZ5KzdpTCtSZHRWVzc0TWtvdXFpNGxJclA2TXlpMHg5bStma0pCMVNBd0J1eGhEbnAybEJmK3FqMnV1Wm5LaiBJdC9FdFlSVm1BS0pPSUdITERsWnZDYnRJN0hhTUkvMU5TV2llMEVkQW9HQkFJNnljNEdVYS9QMlduZVNUSXgrIGZ0cmtEZmFiZFNCcE9ZR0RZaHJqb04zMW1jeE1FNTlGQnpUeWt6NXFtK1AzdUxYaDJraktOSXQwWHBMaURCWHEgdmxEUXBZNmUrQnFqWVZYdzdkR3ZjVEE3RkhCZno4SkVZREc1aWNTaWRHa0MvdURLWkZ5dHBYRURsMTFBdldhTiBLUUY5WHpmb2t3R05tUEdxL3NERDJpMUgifQ.39IOVhikFmCmWgUfOnUr1OdcmqLExBqCp2NIhsTRiKwCUGg3YQVW6vdls_BhoPQGMvwEzetoB7JBmSWr5PMKcA");
              final now = jsonDecode(XORDecode)["RTC"];
              final logEntry =
                  LogEntry(DateTime.parse(now).toIso8601String(), XORDecode);
              _logToHive(logEntry);
              _eventsStreamController.add(XORDecode);
            }
          }
        });
      });
    }
  }

  static void closeUDPConnection() {
    _sseSubscription?.cancel();
    _sseSubscription = null;
  }

  static void _logToHive(LogEntry logEntry) async {
    await Hive.openBox<LogEntry>('log_entries'); // Open the box
    final logBox = Hive.box<LogEntry>('log_entries');
    logBox.add(logEntry).whenComplete(() {
      print('Log entry added successfully: $logEntry');
    });
  }

  static Future<List<LogEntry>> getLogsFromHive() async {
    await Hive.openBox<LogEntry>('log_entries'); // Open the box
    final logBox = Hive.box<LogEntry>('log_entries');
    return logBox.values.toList();
  }

  static void clearLogs() async {
    await Hive.openBox<LogEntry>('log_entries'); // Open the box
    final logBox = Hive.box<LogEntry>('log_entries');
    await logBox.clear();
    print('Logs cleared successfully.');
  }

  static Future<List<LogEntry>> getLogsByTimeRange(
      DateTime startTime, DateTime endTime) async {
    await Hive.openBox<LogEntry>('log_entries'); // Open the box
    final logBox = Hive.box<LogEntry>('log_entries');
    final allLogs = logBox.values.toList();
    final filteredLogs = allLogs.where((log) {
      final logTime = DateTime.parse(log.time);
      return logTime.isAfter(startTime) && logTime.isBefore(endTime);
    }).toList();
    return filteredLogs;
  }

  static Future<List<LogEntry>> getLogsByTimeRangeAndInterval(
      DateTime startTime, DateTime endTime) async {
    await Hive.openBox<LogEntry>('log_entries'); // Open the box
    final logBox = Hive.box<LogEntry>('log_entries');
    final allLogs = logBox.values.toList();
    // Sort the log entries by their time
    allLogs.sort((a, b) =>
        DateTime.parse(a.time).day.compareTo(DateTime.parse(b.time).day));
    final logsByTime = <String, LogEntry>{};
    var oldMin;
    for (final log in allLogs) {
      final logTime = DateTime.parse(log.time);
      if (logTime.isAfter(startTime) && logTime.isBefore(endTime)) {
        final truncatedLogTime = DateTime.parse(log.time);
        final key = "$truncatedLogTime"; // Convert DateTime to a string key
        if (oldMin != DateTime.parse(log.time).minute) {
          oldMin = DateTime.parse(log.time).minute;
          logsByTime[key] = log;
        }
      }
    }
    oldMin = null;
    final filteredLogs = logsByTime.values.toList();
    return filteredLogs;
  }
}
