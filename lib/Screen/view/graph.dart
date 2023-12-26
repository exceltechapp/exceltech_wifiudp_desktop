import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../Database/LogModel.dart';
import '../../Function/showLogDateChart.dart';
import '../../model/chartModel.dart';
import '../../UDP/UDP.dart';
import '../../model/DeviceId.dart';

class graphView extends StatefulWidget {
  const graphView({super.key});
  @override
  State<graphView> createState() => _graphViewState();
}

class _graphViewState extends State<graphView> {
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

  // define for Current
  List<ChartData>? chartDataCurrent = [];
  // define for Voltage
  List<ChartDataVoltage>? chartDataVoltage = [];
  // define for TH
  List<ChartDataTH>? chartDataTH = [];
  // define for KW
  List<ChartDataKW>? chartDataKW = [];
  // define other parameter of chart
  TrackballBehavior? _trackballBehaviorVoltage,
      _trackballBehaviorCurrent,
      _trackballBehaviorKW,
      _trackballBehaviorTH;
  late ZoomPanBehavior _zoomPanVoltage, _zoomPanCurrent, _zoomPanTH, _zoomPanKW;
  late CrosshairLineType _lineTypeVoltage,
      _lineTypeCurrent,
      _lineTypeTH,
      _lineTypeKW;
  // func for init char req data
  void initChartdata() {
    _lineTypeCurrent = CrosshairLineType.both;
    _trackballBehaviorCurrent = TrackballBehavior(
        enable: true,
        lineColor: const Color.fromRGBO(0, 0, 0, 0.03),
        lineWidth: 15,
        activationMode: ActivationMode.singleTap,
        markerSettings: const TrackballMarkerSettings(
            borderWidth: 4,
            height: 10,
            width: 10,
            markerVisibility: TrackballVisibilityMode.visible));
    _zoomPanCurrent = ZoomPanBehavior(
      enableDoubleTapZooming: true,
      enablePanning: true,
      enablePinching: true,
      enableSelectionZooming: true,
    );
    _lineTypeVoltage = CrosshairLineType.both;
    _trackballBehaviorVoltage = TrackballBehavior(
        enable: true,
        lineColor: const Color.fromRGBO(0, 0, 0, 0.03),
        lineWidth: 15,
        activationMode: ActivationMode.singleTap,
        markerSettings: const TrackballMarkerSettings(
            borderWidth: 4,
            height: 10,
            width: 10,
            markerVisibility: TrackballVisibilityMode.visible));
    _zoomPanVoltage = ZoomPanBehavior(
      enableDoubleTapZooming: true,
      enablePanning: true,
      enablePinching: true,
      enableSelectionZooming: true,
    );
    _lineTypeTH = CrosshairLineType.both;
    _trackballBehaviorTH = TrackballBehavior(
        enable: true,
        lineColor: const Color.fromRGBO(0, 0, 0, 0.03),
        lineWidth: 15,
        activationMode: ActivationMode.singleTap,
        markerSettings: const TrackballMarkerSettings(
            borderWidth: 4,
            height: 10,
            width: 10,
            markerVisibility: TrackballVisibilityMode.visible));
    _zoomPanTH = ZoomPanBehavior(
      enableDoubleTapZooming: true,
      enablePanning: true,
      enablePinching: true,
      enableSelectionZooming: true,
    );
    _lineTypeKW = CrosshairLineType.both;
    _trackballBehaviorKW = TrackballBehavior(
        enable: true,
        lineColor: const Color.fromRGBO(0, 0, 0, 0.03),
        lineWidth: 15,
        activationMode: ActivationMode.singleTap,
        markerSettings: const TrackballMarkerSettings(
            borderWidth: 4,
            height: 10,
            width: 10,
            markerVisibility: TrackballVisibilityMode.visible));
    _zoomPanKW = ZoomPanBehavior(
      enableDoubleTapZooming: true,
      enablePanning: true,
      enablePinching: true,
      enableSelectionZooming: true,
    );
  }

  void clearListChartData() {
    chartDataCurrent!.clear();
    chartDataVoltage!.clear();
    chartDataTH!.clear();
    chartDataKW!.clear();
  }

  // define list for chart Current
  List<LineSeries<ChartData, DateTime>> _LineSeriesCurrent() {
    return <LineSeries<ChartData, DateTime>>[
      LineSeries<ChartData, DateTime>(
          animationDuration: 2500,
          dataSource: chartDataCurrent!,
          xValueMapper: (ChartData sales, _) => sales.x,
          yValueMapper: (ChartData sales, _) => sales.y1,
          width: 2,
          name: 'R',
          color: Colors.redAccent,
          markerSettings: const MarkerSettings(isVisible: false)),
      LineSeries<ChartData, DateTime>(
          animationDuration: 2500,
          dataSource: chartDataCurrent!,
          width: 2,
          name: 'Y',
          xValueMapper: (ChartData sales, _) => sales.x,
          yValueMapper: (ChartData sales, _) => sales.y2,
          color: Colors.yellowAccent,
          markerSettings: const MarkerSettings(isVisible: false)),
      LineSeries<ChartData, DateTime>(
          animationDuration: 2500,
          dataSource: chartDataCurrent!,
          width: 2,
          name: 'B',
          xValueMapper: (ChartData sales, _) => sales.x,
          yValueMapper: (ChartData sales, _) => sales.y3,
          color: Colors.blueAccent,
          markerSettings: const MarkerSettings(isVisible: false))
    ];
  }

  // define list for chart Voltage
  List<LineSeries<ChartDataVoltage, DateTime>> _LineSeriesVoltage() {
    return <LineSeries<ChartDataVoltage, DateTime>>[
      LineSeries<ChartDataVoltage, DateTime>(
          animationDuration: 2500,
          dataSource: chartDataVoltage!,
          xValueMapper: (ChartDataVoltage sales, _) => sales.x,
          yValueMapper: (ChartDataVoltage sales, _) => sales.y1,
          width: 2,
          name: 'RY',
          markerSettings: const MarkerSettings(isVisible: false)),
      LineSeries<ChartDataVoltage, DateTime>(
          animationDuration: 2500,
          dataSource: chartDataVoltage!,
          width: 2,
          name: 'YB',
          xValueMapper: (ChartDataVoltage sales, _) => sales.x,
          yValueMapper: (ChartDataVoltage sales, _) => sales.y2,
          markerSettings: const MarkerSettings(isVisible: false)),
      LineSeries<ChartDataVoltage, DateTime>(
          animationDuration: 2500,
          dataSource: chartDataVoltage!,
          width: 2,
          name: 'BR',
          xValueMapper: (ChartDataVoltage sales, _) => sales.x,
          yValueMapper: (ChartDataVoltage sales, _) => sales.y3,
          markerSettings: const MarkerSettings(isVisible: false))
    ];
  }

  // define list for char TH
  List<LineSeries<ChartDataTH, DateTime>> _LineSeriesTH() {
    return <LineSeries<ChartDataTH, DateTime>>[
      LineSeries<ChartDataTH, DateTime>(
          animationDuration: 2500,
          dataSource: chartDataTH!,
          xValueMapper: (ChartDataTH sales, _) => sales.x,
          yValueMapper: (ChartDataTH sales, _) => sales.y1,
          width: 2,
          name: 'TH',
          markerSettings: const MarkerSettings(isVisible: false)),
    ];
  }

  // define list for char TH
  List<LineSeries<ChartDataKW, DateTime>> _LineSeriesKW() {
    return <LineSeries<ChartDataKW, DateTime>>[
      LineSeries<ChartDataKW, DateTime>(
          animationDuration: 2500,
          dataSource: chartDataKW!,
          xValueMapper: (ChartDataKW sales, _) => sales.x,
          yValueMapper: (ChartDataKW sales, _) => sales.y1,
          width: 2,
          name: 'KW',
          markerSettings: const MarkerSettings(isVisible: false)),
    ];
  }

  // func getting log from local database
  void getLog(dynamic startTime, dynamic endTime) {
    //SSEHandler.clearLogs();
    if (selectDevice == null || selectDeviceId == null) {
      return;
    }
    UDPHandler.getLogsByTimeRangeAndInterval(
            DateTime.parse(startTime.toString()),
            DateTime.parse(endTime.toString()))
        .then(
      (List<LogEntry> logs) {
        if (selectDevice == null || selectDeviceId == null) {
          return;
        }
        var key = jsonDecode(selectDevice!)["DeviceMac"];

        chartDataKW!.clear();
        chartDataTH!.clear();
        chartDataVoltage!.clear();
        chartDataCurrent!.clear();

        logs.forEach((log) {
          if (log.data is String) {
            try {
              Map<String, dynamic> newdata = jsonDecode(log.data);
              print(log);
              if (newdata["ID"] ==
                      int.parse(selectDeviceId.toString().split("-").last) &&
                  newdata["MAC"] == key) {
                if (mounted) {
                  setState(() {
                    chartDataCurrent!.add(ChartData(
                      DateTime.parse(log.time),
                      newdata["IR"] ?? 0,
                      newdata["IY"] ?? 0,
                      newdata["IB"] ?? 0,
                    ));
                    chartDataVoltage!.add(ChartDataVoltage(
                      DateTime.parse(log.time),
                      newdata["VRY"] ?? 0,
                      newdata["VYB"] ?? 0,
                      newdata["VBR"] ?? 0,
                    ));
                    chartDataTH!.add(ChartDataTH(
                      DateTime.parse(log.time),
                      newdata["TH"] ?? 0,
                    ));
                    chartDataKW!.add(ChartDataKW(
                      DateTime.parse(log.time),
                      newdata["KW"] ?? 0,
                    ));
                  });
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

  liveChart() {
    if (selectDevice == null || selectDeviceId == null) {
      return;
    }
    var key = jsonDecode(selectDevice!)["key"];
    var oldMin;
    UDPHandler.eventsStream.listen((event) {
      var newdata = jsonDecode(event);
      if (newdata["MAC"] == key &&
          newdata["IDN"] == jsonDecode(selectDevice)["DeviceName"]) {
        if (mounted) {
          setState(() {
            chartDataCurrent!.add(ChartData(
              DateTime.now(),
              newdata["IR"] ?? 0,
              newdata["IY"] ?? 0,
              newdata["IB"] ?? 0,
            ));
            chartDataVoltage!.add(ChartDataVoltage(
              DateTime.now(),
              newdata["VRY"] ?? 0,
              newdata["VYB"] ?? 0,
              newdata["VBR"] ?? 0,
            ));
            chartDataTH!.add(ChartDataTH(
              DateTime.now(),
              newdata["TH"] ?? 0,
            ));
            chartDataKW!.add(ChartDataKW(
              DateTime.now(),
              newdata["KW"] ?? 0,
            ));
          });
        }
      }
    });
    return Expanded(
      child: TabBarView(
        children: [
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(3))),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: SfCartesianChart(
                    legend: Legend(
                        isVisible: true,
                        overflowMode: LegendItemOverflowMode.wrap),

                    /// To enable the cross hair for cartesian chart.
                    crosshairBehavior: CrosshairBehavior(
                        enable: true,
                        hideDelay: 1000,
                        activationMode: ActivationMode.singleTap,
                        shouldAlwaysShow: false,
                        lineType: _lineTypeCurrent),
                    primaryXAxis: DateTimeAxis(
                        dateFormat: DateFormat("HH:mm"),
                        interactiveTooltip: InteractiveTooltip(
                            enable:
                                (_lineTypeCurrent == CrosshairLineType.both ||
                                        _lineTypeCurrent ==
                                            CrosshairLineType.horizontal)
                                    ? true
                                    : false),
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                        intervalType: DateTimeIntervalType.minutes,
                        autoScrollingDelta: 3,
                        autoScrollingDeltaType: DateTimeIntervalType.minutes,
                        majorGridLines: const MajorGridLines(width: 0)),
                    primaryYAxis: NumericAxis(
                        interactiveTooltip: InteractiveTooltip(
                            enable:
                                (_lineTypeCurrent == CrosshairLineType.both ||
                                        _lineTypeCurrent ==
                                            CrosshairLineType.horizontal)
                                    ? true
                                    : false),
                        labelFormat: '{value}',
                        interval: 5,
                        //axisLine: const AxisLine(width: 0),
                        majorTickLines:
                            const MajorTickLines(color: Colors.transparent)),
                    series: _LineSeriesCurrent(),
                    //trackballBehavior: _trackballBehavior,
                    tooltipBehavior: TooltipBehavior(enable: true),
                    zoomPanBehavior: _zoomPanCurrent,
                  ),
                ),
                Stack(children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 80,
                      child: InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 7) * 0.9,
                              padding: const EdgeInsets.fromLTRB(24, 15, 0, 10),
                              child: Tooltip(
                                message: 'Zoom In',
                                child: IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    _zoomPanCurrent.zoomIn();
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 7) * 0.9,
                              padding: const EdgeInsets.fromLTRB(20, 15, 0, 10),
                              child: Tooltip(
                                message: 'Zoom Out',
                                child: IconButton(
                                  icon: Icon(
                                    Icons.remove,
                                  ),
                                  onPressed: () {
                                    _zoomPanCurrent.zoomOut();
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 7) * 0.9,
                              padding: const EdgeInsets.fromLTRB(20, 15, 0, 10),
                              child: Tooltip(
                                message: 'Pan Up',
                                child: IconButton(
                                  icon: Icon(
                                    Icons.keyboard_arrow_up,
                                  ),
                                  onPressed: () {
                                    _zoomPanCurrent.panToDirection('top');
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 7) * 0.9,
                              padding: const EdgeInsets.fromLTRB(20, 15, 0, 10),
                              child: Tooltip(
                                message: 'Pan Down',
                                child: IconButton(
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                  ),
                                  onPressed: () {
                                    _zoomPanCurrent.panToDirection('bottom');
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 7) * 0.9,
                              padding: const EdgeInsets.fromLTRB(20, 15, 0, 10),
                              child: Tooltip(
                                message: 'Pan Left',
                                child: IconButton(
                                  icon: Icon(
                                    Icons.keyboard_arrow_left,
                                  ),
                                  onPressed: () {
                                    _zoomPanCurrent.panToDirection('left');
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 7) * 0.9,
                              padding: const EdgeInsets.fromLTRB(20, 15, 0, 10),
                              child: Tooltip(
                                message: 'Pan Right',
                                child: IconButton(
                                  icon: Icon(
                                    Icons.keyboard_arrow_right,
                                  ),
                                  onPressed: () {
                                    _zoomPanCurrent.panToDirection('right');
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 7) * 0.9,
                              padding: const EdgeInsets.fromLTRB(20, 15, 0, 10),
                              child: Tooltip(
                                message: 'Reset',
                                child: IconButton(
                                  icon: Icon(
                                    Icons.refresh,
                                  ),
                                  onPressed: () {
                                    _zoomPanCurrent.reset();
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ])
              ],
            ),
          ),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(3))),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: SfCartesianChart(
                    legend: Legend(
                        isVisible: true,
                        overflowMode: LegendItemOverflowMode.wrap),

                    /// To enable the cross hair for cartesian chart.
                    crosshairBehavior: CrosshairBehavior(
                        enable: true,
                        hideDelay: 1000,
                        activationMode: ActivationMode.singleTap,
                        shouldAlwaysShow: false,
                        lineType: _lineTypeVoltage),
                    primaryXAxis: DateTimeAxis(
                        dateFormat: DateFormat("HH:mm"),
                        interactiveTooltip: InteractiveTooltip(
                            enable:
                                (_lineTypeVoltage == CrosshairLineType.both ||
                                        _lineTypeVoltage ==
                                            CrosshairLineType.horizontal)
                                    ? true
                                    : false),
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                        intervalType: DateTimeIntervalType.minutes,
                        autoScrollingDelta: 3,
                        autoScrollingDeltaType: DateTimeIntervalType.minutes,
                        majorGridLines: const MajorGridLines(width: 0)),
                    primaryYAxis: NumericAxis(
                        interactiveTooltip: InteractiveTooltip(
                            enable:
                                (_lineTypeVoltage == CrosshairLineType.both ||
                                        _lineTypeVoltage ==
                                            CrosshairLineType.horizontal)
                                    ? true
                                    : false),
                        labelFormat: '{value}',
                        interval: 5,
                        //axisLine: const AxisLine(width: 0),
                        majorTickLines:
                            const MajorTickLines(color: Colors.transparent)),
                    series: _LineSeriesVoltage(),
                    //trackballBehavior: _trackballBehavior,
                    tooltipBehavior: TooltipBehavior(enable: true),
                    zoomPanBehavior: _zoomPanVoltage,
                  ),
                ),
                Stack(children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 80,
                      child: InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 7) * 0.9,
                              padding: const EdgeInsets.fromLTRB(24, 15, 0, 10),
                              child: Tooltip(
                                message: 'Zoom In',
                                child: IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    _zoomPanVoltage.zoomIn();
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 7) * 0.9,
                              padding: const EdgeInsets.fromLTRB(20, 15, 0, 10),
                              child: Tooltip(
                                message: 'Zoom Out',
                                child: IconButton(
                                  icon: Icon(
                                    Icons.remove,
                                  ),
                                  onPressed: () {
                                    _zoomPanVoltage.zoomOut();
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 7) * 0.9,
                              padding: const EdgeInsets.fromLTRB(20, 15, 0, 10),
                              child: Tooltip(
                                message: 'Pan Up',
                                child: IconButton(
                                  icon: Icon(
                                    Icons.keyboard_arrow_up,
                                  ),
                                  onPressed: () {
                                    _zoomPanVoltage.panToDirection('top');
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 7) * 0.9,
                              padding: const EdgeInsets.fromLTRB(20, 15, 0, 10),
                              child: Tooltip(
                                message: 'Pan Down',
                                child: IconButton(
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                  ),
                                  onPressed: () {
                                    _zoomPanVoltage.panToDirection('bottom');
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 7) * 0.9,
                              padding: const EdgeInsets.fromLTRB(20, 15, 0, 10),
                              child: Tooltip(
                                message: 'Pan Left',
                                child: IconButton(
                                  icon: Icon(
                                    Icons.keyboard_arrow_left,
                                  ),
                                  onPressed: () {
                                    _zoomPanVoltage.panToDirection('left');
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 7) * 0.9,
                              padding: const EdgeInsets.fromLTRB(20, 15, 0, 10),
                              child: Tooltip(
                                message: 'Pan Right',
                                child: IconButton(
                                  icon: Icon(
                                    Icons.keyboard_arrow_right,
                                  ),
                                  onPressed: () {
                                    _zoomPanVoltage.panToDirection('right');
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 7) * 0.9,
                              padding: const EdgeInsets.fromLTRB(20, 15, 0, 10),
                              child: Tooltip(
                                message: 'Reset',
                                child: IconButton(
                                  icon: Icon(
                                    Icons.refresh,
                                  ),
                                  onPressed: () {
                                    _zoomPanVoltage.reset();
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ])
              ],
            ),
          ),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(3))),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: SfCartesianChart(
                    legend: Legend(
                        isVisible: true,
                        overflowMode: LegendItemOverflowMode.wrap),

                    /// To enable the cross hair for cartesian chart.
                    crosshairBehavior: CrosshairBehavior(
                        enable: true,
                        hideDelay: 1000,
                        activationMode: ActivationMode.singleTap,
                        shouldAlwaysShow: false,
                        lineType: _lineTypeTH),
                    primaryXAxis: DateTimeAxis(
                        dateFormat: DateFormat("HH:mm"),
                        interactiveTooltip: InteractiveTooltip(
                            enable: (_lineTypeTH == CrosshairLineType.both ||
                                    _lineTypeTH == CrosshairLineType.horizontal)
                                ? true
                                : false),
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                        intervalType: DateTimeIntervalType.minutes,
                        autoScrollingDelta: 3,
                        autoScrollingDeltaType: DateTimeIntervalType.minutes,
                        majorGridLines: const MajorGridLines(width: 0)),
                    primaryYAxis: NumericAxis(
                        interactiveTooltip: InteractiveTooltip(
                            enable: (_lineTypeTH == CrosshairLineType.both ||
                                    _lineTypeTH == CrosshairLineType.horizontal)
                                ? true
                                : false),
                        labelFormat: '{value}',
                        interval: 5,
                        //axisLine: const AxisLine(width: 0),
                        majorTickLines:
                            const MajorTickLines(color: Colors.transparent)),
                    series: _LineSeriesTH(),
                    //trackballBehavior: _trackballBehavior,
                    tooltipBehavior: TooltipBehavior(enable: true),
                    zoomPanBehavior: _zoomPanTH,
                  ),
                ),
                Stack(children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 80,
                      child: InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 7) * 0.9,
                              padding: const EdgeInsets.fromLTRB(24, 15, 0, 10),
                              child: Tooltip(
                                message: 'Zoom In',
                                child: IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    _zoomPanTH.zoomIn();
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 7) * 0.9,
                              padding: const EdgeInsets.fromLTRB(20, 15, 0, 10),
                              child: Tooltip(
                                message: 'Zoom Out',
                                child: IconButton(
                                  icon: Icon(
                                    Icons.remove,
                                  ),
                                  onPressed: () {
                                    _zoomPanTH.zoomOut();
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 7) * 0.9,
                              padding: const EdgeInsets.fromLTRB(20, 15, 0, 10),
                              child: Tooltip(
                                message: 'Pan Up',
                                child: IconButton(
                                  icon: Icon(
                                    Icons.keyboard_arrow_up,
                                  ),
                                  onPressed: () {
                                    _zoomPanTH.panToDirection('top');
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 7) * 0.9,
                              padding: const EdgeInsets.fromLTRB(20, 15, 0, 10),
                              child: Tooltip(
                                message: 'Pan Down',
                                child: IconButton(
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                  ),
                                  onPressed: () {
                                    _zoomPanTH.panToDirection('bottom');
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 7) * 0.9,
                              padding: const EdgeInsets.fromLTRB(20, 15, 0, 10),
                              child: Tooltip(
                                message: 'Pan Left',
                                child: IconButton(
                                  icon: Icon(
                                    Icons.keyboard_arrow_left,
                                  ),
                                  onPressed: () {
                                    _zoomPanTH.panToDirection('left');
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 7) * 0.9,
                              padding: const EdgeInsets.fromLTRB(20, 15, 0, 10),
                              child: Tooltip(
                                message: 'Pan Right',
                                child: IconButton(
                                  icon: Icon(
                                    Icons.keyboard_arrow_right,
                                  ),
                                  onPressed: () {
                                    _zoomPanTH.panToDirection('right');
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 7) * 0.9,
                              padding: const EdgeInsets.fromLTRB(20, 15, 0, 10),
                              child: Tooltip(
                                message: 'Reset',
                                child: IconButton(
                                  icon: Icon(
                                    Icons.refresh,
                                  ),
                                  onPressed: () {
                                    _zoomPanTH.reset();
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ])
              ],
            ),
          ),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(3))),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: SfCartesianChart(
                    legend: Legend(
                        isVisible: true,
                        overflowMode: LegendItemOverflowMode.wrap),

                    /// To enable the cross hair for cartesian chart.
                    crosshairBehavior: CrosshairBehavior(
                        enable: true,
                        hideDelay: 1000,
                        activationMode: ActivationMode.singleTap,
                        shouldAlwaysShow: false,
                        lineType: _lineTypeKW),
                    primaryXAxis: DateTimeAxis(
                        dateFormat: DateFormat("HH:mm"),
                        interactiveTooltip: InteractiveTooltip(
                            enable: (_lineTypeKW == CrosshairLineType.both ||
                                    _lineTypeKW == CrosshairLineType.horizontal)
                                ? true
                                : false),
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                        intervalType: DateTimeIntervalType.minutes,
                        autoScrollingDelta: 3,
                        autoScrollingDeltaType: DateTimeIntervalType.minutes,
                        majorGridLines: const MajorGridLines(width: 0)),
                    primaryYAxis: NumericAxis(
                        interactiveTooltip: InteractiveTooltip(
                            enable: (_lineTypeKW == CrosshairLineType.both ||
                                    _lineTypeKW == CrosshairLineType.horizontal)
                                ? true
                                : false),
                        labelFormat: '{value}',
                        interval: 5,
                        //axisLine: const AxisLine(width: 0),
                        majorTickLines:
                            const MajorTickLines(color: Colors.transparent)),
                    series: _LineSeriesKW(),
                    //trackballBehavior: _trackballBehavior,
                    tooltipBehavior: TooltipBehavior(enable: true),
                    zoomPanBehavior: _zoomPanKW,
                  ),
                ),
                Stack(children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 80,
                      child: InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 7) * 0.9,
                              padding: const EdgeInsets.fromLTRB(24, 15, 0, 10),
                              child: Tooltip(
                                message: 'Zoom In',
                                child: IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    _zoomPanKW.zoomIn();
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 7) * 0.9,
                              padding: const EdgeInsets.fromLTRB(20, 15, 0, 10),
                              child: Tooltip(
                                message: 'Zoom Out',
                                child: IconButton(
                                  icon: Icon(
                                    Icons.remove,
                                  ),
                                  onPressed: () {
                                    _zoomPanKW.zoomOut();
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 7) * 0.9,
                              padding: const EdgeInsets.fromLTRB(20, 15, 0, 10),
                              child: Tooltip(
                                message: 'Pan Up',
                                child: IconButton(
                                  icon: Icon(
                                    Icons.keyboard_arrow_up,
                                  ),
                                  onPressed: () {
                                    _zoomPanKW.panToDirection('top');
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 7) * 0.9,
                              padding: const EdgeInsets.fromLTRB(20, 15, 0, 10),
                              child: Tooltip(
                                message: 'Pan Down',
                                child: IconButton(
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                  ),
                                  onPressed: () {
                                    _zoomPanKW.panToDirection('bottom');
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 7) * 0.9,
                              padding: const EdgeInsets.fromLTRB(20, 15, 0, 10),
                              child: Tooltip(
                                message: 'Pan Left',
                                child: IconButton(
                                  icon: Icon(
                                    Icons.keyboard_arrow_left,
                                  ),
                                  onPressed: () {
                                    _zoomPanKW.panToDirection('left');
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 7) * 0.9,
                              padding: const EdgeInsets.fromLTRB(20, 15, 0, 10),
                              child: Tooltip(
                                message: 'Pan Right',
                                child: IconButton(
                                  icon: Icon(
                                    Icons.keyboard_arrow_right,
                                  ),
                                  onPressed: () {
                                    _zoomPanKW.panToDirection('right');
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width:
                                  (MediaQuery.of(context).size.width / 7) * 0.9,
                              padding: const EdgeInsets.fromLTRB(20, 15, 0, 10),
                              child: Tooltip(
                                message: 'Reset',
                                child: IconButton(
                                  icon: Icon(
                                    Icons.refresh,
                                  ),
                                  onPressed: () {
                                    _zoomPanKW.reset();
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ])
              ],
            ),
          ),
        ],
      ),
    );
  }

  // run once on page run
  @override
  void initState() {
    getDevice();
    initChartdata();
    super.initState();
  }

  // run once when page exit or end
  @override
  void dispose() {
    clearListChartData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: DeviceList.isEmpty
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
                                      //startTime = dateTimeList?[0].toIso8601String();
                                      //endTime = dateTimeList?[1].toIso8601String();
                                    }
                                    print(
                                        "Start dateTime: ${dateTimeList?[0].toIso8601String()}");
                                    print(
                                        "End dateTime: ${dateTimeList?[1].toIso8601String()}");
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder:
                                                (context) => chartLog(
                                              DeviceSelected:
                                              selectDevice,
                                              DeviceSelectedName:
                                              selectDeviceId.toString().split("-").last,
                                              startTime:
                                              dateTimeList?[0]
                                                  .toIso8601String(),
                                              endTime: dateTimeList?[
                                              1]
                                                  .toIso8601String(),
                                            )));
                                  },
                                  icon: Icon(Icons.date_range)))
                          : Card()
                    ],
                  ),
                  selectDevice != null && selectDeviceId != null
                      ? TabBar(
                          labelColor: Colors.black,
                          tabs: [
                            Tab(icon: Text("CURRENT(A)")),
                            Tab(icon: Text("VOLTAGE(V)")),
                            Tab(icon: Text("TH")),
                            Tab(icon: Text("KW")),
                          ],
                        )
                      : Card(),
                  selectDevice != null && selectDeviceId != null
                      ? liveChart()
                      : Card(),
                ],
              ));
  }
}
