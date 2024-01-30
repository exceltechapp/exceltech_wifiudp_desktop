import 'dart:async';
import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import 'showLogDateChart.dart';
import '../../../UDP/UDP.dart';
import '../../../model/DeviceId.dart';
import '../../../model/DeviceJson.dart';
import '../../../model/chartModel.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
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
  /*Define List for chart of ChartData*/
  List<ChartData>? chartDataCurrent = [];
  // define for Voltage
  List<ChartDataVoltage>? chartDataVoltage = [];
  // define for TH
  List<ChartDataTH>? chartDataTH = [];
  // define for KW
  List<ChartDataKW>? chartDataKW = [];
  /*Define Other paremeter for chart*/
  TrackballBehavior? _trackballBehaviorVoltage,
      _trackballBehaviorCurrent,
      _trackballBehaviorKW,
      _trackballBehaviorTH;
  late ZoomPanBehavior _zoomPanVoltage, _zoomPanCurrent, _zoomPanTH, _zoomPanKW;
  late CrosshairLineType _lineTypeVoltage,
      _lineTypeCurrent,
      _lineTypeTH,
      _lineTypeKW;
  /*Define function for getting InitChartData*/
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

  /*Define function for Clear ChartData*/
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

  LiveChart() {
    var data = UDPHandler.eventsStreamJsonDecode;
    data.asBroadcastStream().listen((event) {
      if (event["ID"] != LastData &&
          event["MAC"] == jsonDecode(selectDevice)["DeviceMac"]) {
        TimerDeviceOfflineSate?.cancel();
        LastData = event["ID"];
        print(event);
        if ((event["IR"].runtimeType != bool && event["IR"] != 0) &&
            (event["IY"].runtimeType != bool && event["IY"] != 0) &&
            (event["IB"].runtimeType != bool && event["IB"] != 0)) {
          chartDataCurrent!.add(ChartData(
            DateTime.now(),
            event["IR"],
            event["IY"],
            event["IB"],
          ));
        }
        if ((event["VRY"].runtimeType != bool && event["VRY"] != 0) &&
            (event["VYB"].runtimeType != bool && event["VYB"] != 0) &&
            (event["VRB"].runtimeType != bool && event["VRB"] != 0)) {
          chartDataVoltage!.add(ChartDataVoltage(
            DateTime.now(),
            event["VRY"],
            event["VYB"],
            event["VBR"],
          ));
        }
        if (event["TH"] != 0 && event["TH"] != null) {
          chartDataTH!.add(ChartDataTH(
            DateTime.now(),
            event["TH"] ?? 0,
          ));
        }
        if (event["KW"] != 0 && event["KW"] != null) {
          chartDataKW!.add(ChartDataKW(
            DateTime.now(),
            event["KW"],
          ));
        }
      } else {
        print("ELSE FUNCTION CALLED");
        if (!TimerDeviceOfflineSate!.isActive) {
          TimerDeviceOfflineSate = Timer(Duration(minutes: 2), () {
            InitDataList();
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
  var LockVar1 = 1;

  var startTime;
  var endTime;
  // define vairable for device
  var selectDevice;
  // define variable for device id
  var selectDeviceId;

  // bool used for switch b/w screen when MSD device not found
  bool WaitTimeCountDeviceListBool = false;
  // var used as stroing last datato it
  var LastData;

  // define function for init oe clear DeviceDataList that is used for table row
  void InitDataList() {
    print("Data Init Called");
    if (this.mounted) {
      setState(() {
        DeviceDataList.clear();
        DeviceDataList = List<DeviceJson>.from(List<DeviceJson>.generate(
            32, (index) => DeviceJson(ID: index + 1)));
      });
    }
  }

  // define var for stop  loop
  bool buildLock = false;

  // define function get from preferences
  GetPreferences(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Try reading data from the 'items' key. If it doesn't exist, returns null.
    final List<String>? items = prefs.getStringList(key);
    return items;
  }

  // define function save to preferences
  void SavePreferences(String key, List<String> payload) async {
    if (true) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String>? items = prefs.getStringList(key);
      var size = items?.length;
      if (payload.isNotEmpty && size! <= payload.length) {
        await prefs.setStringList(key, payload);
        buildLock = true;
      }
    }
  }

  // define function for getting device list
  void getDevice() {
    if (this.mounted) {
      setState(() {
        DeviceDataList = List<DeviceJson>.from(List<DeviceJson>.generate(
            32, (index) => DeviceJson(ID: index + 1)));
      });
    }
    UDPHandler.eventsStream.listen((event) {
      var decodeEvent = jsonDecode(event);
      DeviceId newDeviceModel =
          DeviceId(decodeEvent["DEN"], decodeEvent["MAC"], decodeEvent["SIZE"]);
      if (this.mounted) {
        setState(() {
          if (!DeviceList.contains(jsonEncode(newDeviceModel.mapModel()))) {
            DeviceList.add(jsonEncode(newDeviceModel.mapModel()));
            SPDeviceList.add(jsonEncode(newDeviceModel.mapModel()));
          }
          if (DeviceList.isNotEmpty && SPDeviceList.isNotEmpty) {
            print("Deviec Update");
            if (LockVar1 == 1) {
              print(DeviceList.first);
              selectDevice = DeviceList.first;
              LockVar1 = 0;
            }
            GetPreferences("DeviceNameList").then((x) {
              x as List<String>;
              Set<String> UniList = {};
              x.forEach((element) {
                Map MapData = jsonDecode(element);
                MapData.remove("Size");
                UniList.add(jsonEncode(MapData));
              });
              if (this.mounted) {
                setState(() {
                  SPDeviceList.addAll(UniList);
                });
              }
            });
            SavePreferences("DeviceNameList", SPDeviceList.toList());
          }
        });
      }
    });
    print(selectDevice);
  }

  // define function for MSD Device not wait timer
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
    initChartdata();
    GetPreferences("DeviceNameList").then((x) {
      x as List<String>;
      Set UniList = {};
      x.forEach((element) {
        Map MapData = jsonDecode(element);
        MapData.remove("Size");
        UniList.add(jsonEncode(MapData));
      });
      if (this.mounted) {
        setState(() {
          DeviceList.addAll(UniList);
        });
      }
      //print(x);
    });
    getDevice();
    TimerDeviceOfflineSate = Timer(Duration(minutes: 2), () {
      InitDataList();
    });
    super.initState();
  }

  @override
  void dispose() {
    TimerDeviceOfflineSate?.cancel();
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
                            //value: DeviceList.isNotEmpty ? DeviceList.first.toString() : null,
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
                                clearListChartData();
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
                                        clearListChartData();
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
                                    if (dateTimeList?[0] != null &&
                                        dateTimeList?[1] != null) {
                                      print(
                                          "${dateTimeList?[0]} ${dateTimeList?[1]}");
                                      FlutterToastr.show(
                                          "Please Wait", context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => chartLog(
                                                    selectDevice: selectDevice,
                                                    selectDeviceId:
                                                        selectDeviceId,
                                                    startTime: dateTimeList?[0]
                                                        .toIso8601String(),
                                                    endTime: dateTimeList?[1]
                                                        .toIso8601String(),
                                                  )));
                                    }
                                  },
                                  icon: Icon(Icons.date_range)))
                          : Card(),
                    ],
                  ),
                  selectDeviceId != null
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
                  selectDeviceId == null
                      ? Expanded(
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            selectDevice == null || selectDeviceId == null
                                ? CircularProgressIndicator()
                                : Container(),
                            DeviceList.isNotEmpty && selectDevice == null
                                ? Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Text("SELECT MSD DEVICE"),
                                  )
                                : Container(),
                            selectDevice != null && selectDeviceId == null
                                ? Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Text("SELECT ID"),
                                  )
                                : Container()
                          ],
                        ))
                      : LiveChart(),
                ],
              ));
  }
}
