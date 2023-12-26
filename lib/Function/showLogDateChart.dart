import 'dart:convert';

import 'package:exceltech_wifiudp/UDP/UDP.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../Database/LogModel.dart';
import '../model/chartModel.dart';

class chartLog extends StatefulWidget {
  const chartLog(
      {super.key,
      this.DeviceSelected,
      this.DeviceSelectedName,
      this.startTime,
      this.endTime});

  final dynamic DeviceSelected;
  final dynamic DeviceSelectedName;
  final dynamic startTime;
  final dynamic endTime;

  @override
  State<chartLog> createState() => _chartLogState();
}

class _chartLogState extends State<chartLog> {
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
    if (widget.DeviceSelected == null || widget.DeviceSelectedName == null) {
      return;
    }
    UDPHandler.getLogsByTimeRangeAndInterval(
            DateTime.parse(startTime.toString()),
            DateTime.parse(endTime.toString()))
        .then(
      (List<LogEntry> logs) {
        if (widget.DeviceSelected == null ||
            widget.DeviceSelectedName == null) {
          return;
        }
        var key = jsonDecode(widget.DeviceSelected!)["DeviceMac"];

        chartDataKW!.clear();
        chartDataTH!.clear();
        chartDataVoltage!.clear();
        chartDataCurrent!.clear();

        logs.forEach((log) {
          if (log.data is String) {
            try {
              Map<String, dynamic> newdata = jsonDecode(log.data);
              print(log);
              if (newdata["ID"] == widget.DeviceSelectedName &&
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
    /*SSEHandler.getLogsByTimeRange(DateTime.parse("2023-07-10T12:36:11.172566"),DateTime.now()).then((List<LogEntry> logs){
      logs.forEach((log) {
        print("time:${log.time} and data:${log.data}");
      });
    });*/
  }

  @override
  void initState() {
    getLog(widget.startTime, widget.endTime);
    initChartdata();
    super.initState();
  }

  @override
  void dispose() {
    clearListChartData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:  Text("${DateTime.parse(widget.startTime).toString()} to ${DateTime.parse(widget.endTime).toString()}"),
      ),
      body: DefaultTabController(
          length: 4,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                TabBar(
                  labelColor: Colors.black,
                  tabs: [
                    Tab(icon: Text("CURRENT(A)")),
                    Tab(icon: Text("VOLTAGE(V)")),
                    Tab(icon: Text("TH")),
                    Tab(icon: Text("KW")),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(3))),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: SfCartesianChart(
                                legend: Legend(
                                    isVisible: true,
                                    overflowMode:
                                    LegendItemOverflowMode
                                        .wrap),

                                /// To enable the cross hair for cartesian chart.
                                crosshairBehavior:
                                CrosshairBehavior(
                                    enable: true,
                                    hideDelay: 1000,
                                    activationMode:
                                    ActivationMode
                                        .singleTap,
                                    shouldAlwaysShow: false,
                                    lineType:
                                    _lineTypeCurrent),
                                primaryXAxis: DateTimeAxis(
                                    dateFormat:
                                    DateFormat("HH:mm"),
                                    interactiveTooltip: InteractiveTooltip(
                                        enable: (_lineTypeCurrent ==
                                            CrosshairLineType
                                                .both ||
                                            _lineTypeCurrent ==
                                                CrosshairLineType
                                                    .horizontal)
                                            ? true
                                            : false),
                                    edgeLabelPlacement:
                                    EdgeLabelPlacement.shift,
                                    interval: 3,
                                    majorGridLines:
                                    const MajorGridLines(
                                        width: 0)),
                                primaryYAxis: NumericAxis(
                                    interactiveTooltip: InteractiveTooltip(
                                        enable: (_lineTypeCurrent ==
                                            CrosshairLineType
                                                .both ||
                                            _lineTypeCurrent ==
                                                CrosshairLineType
                                                    .horizontal)
                                            ? true
                                            : false),
                                    labelFormat: '{value}',
                                    interval: 5,
                                    //axisLine: const AxisLine(width: 0),
                                    majorTickLines:
                                    const MajorTickLines(
                                        color: Colors
                                            .transparent)),
                                series: _LineSeriesCurrent(),
                                //trackballBehavior: _trackballBehavior,
                                tooltipBehavior:
                                TooltipBehavior(enable: true),
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
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                      children: <Widget>[
                                        Container(
                                          width: (MediaQuery.of(
                                              context)
                                              .size
                                              .width /
                                              7) *
                                              0.9,
                                          padding:
                                          const EdgeInsets
                                              .fromLTRB(
                                              24, 15, 0, 10),
                                          child: Tooltip(
                                            message: 'Zoom In',
                                            child: IconButton(
                                              icon:
                                              Icon(Icons.add),
                                              onPressed: () {
                                                _zoomPanCurrent
                                                    .zoomIn();
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: (MediaQuery.of(
                                              context)
                                              .size
                                              .width /
                                              7) *
                                              0.9,
                                          padding:
                                          const EdgeInsets
                                              .fromLTRB(
                                              20, 15, 0, 10),
                                          child: Tooltip(
                                            message: 'Zoom Out',
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.remove,
                                              ),
                                              onPressed: () {
                                                _zoomPanCurrent
                                                    .zoomOut();
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: (MediaQuery.of(
                                              context)
                                              .size
                                              .width /
                                              7) *
                                              0.9,
                                          padding:
                                          const EdgeInsets
                                              .fromLTRB(
                                              20, 15, 0, 10),
                                          child: Tooltip(
                                            message: 'Pan Up',
                                            child: IconButton(
                                              icon: Icon(
                                                Icons
                                                    .keyboard_arrow_up,
                                              ),
                                              onPressed: () {
                                                _zoomPanCurrent
                                                    .panToDirection(
                                                    'top');
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: (MediaQuery.of(
                                              context)
                                              .size
                                              .width /
                                              7) *
                                              0.9,
                                          padding:
                                          const EdgeInsets
                                              .fromLTRB(
                                              20, 15, 0, 10),
                                          child: Tooltip(
                                            message: 'Pan Down',
                                            child: IconButton(
                                              icon: Icon(
                                                Icons
                                                    .keyboard_arrow_down,
                                              ),
                                              onPressed: () {
                                                _zoomPanCurrent
                                                    .panToDirection(
                                                    'bottom');
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: (MediaQuery.of(
                                              context)
                                              .size
                                              .width /
                                              7) *
                                              0.9,
                                          padding:
                                          const EdgeInsets
                                              .fromLTRB(
                                              20, 15, 0, 10),
                                          child: Tooltip(
                                            message: 'Pan Left',
                                            child: IconButton(
                                              icon: Icon(
                                                Icons
                                                    .keyboard_arrow_left,
                                              ),
                                              onPressed: () {
                                                _zoomPanCurrent
                                                    .panToDirection(
                                                    'left');
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: (MediaQuery.of(
                                              context)
                                              .size
                                              .width /
                                              7) *
                                              0.9,
                                          padding:
                                          const EdgeInsets
                                              .fromLTRB(
                                              20, 15, 0, 10),
                                          child: Tooltip(
                                            message: 'Pan Right',
                                            child: IconButton(
                                              icon: Icon(
                                                Icons
                                                    .keyboard_arrow_right,
                                              ),
                                              onPressed: () {
                                                _zoomPanCurrent
                                                    .panToDirection(
                                                    'right');
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: (MediaQuery.of(
                                              context)
                                              .size
                                              .width /
                                              7) *
                                              0.9,
                                          padding:
                                          const EdgeInsets
                                              .fromLTRB(
                                              20, 15, 0, 10),
                                          child: Tooltip(
                                            message: 'Reset',
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.refresh,
                                              ),
                                              onPressed: () {
                                                _zoomPanCurrent
                                                    .reset();
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
                            borderRadius: BorderRadius.all(
                                Radius.circular(3))),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: SfCartesianChart(
                                legend: Legend(
                                    isVisible: true,
                                    overflowMode:
                                    LegendItemOverflowMode
                                        .wrap),

                                /// To enable the cross hair for cartesian chart.
                                crosshairBehavior:
                                CrosshairBehavior(
                                    enable: true,
                                    hideDelay: 1000,
                                    activationMode:
                                    ActivationMode
                                        .singleTap,
                                    shouldAlwaysShow: false,
                                    lineType:
                                    _lineTypeVoltage),
                                primaryXAxis: DateTimeAxis(
                                    dateFormat:
                                    DateFormat("HH:mm"),
                                    interactiveTooltip: InteractiveTooltip(
                                        enable: (_lineTypeVoltage ==
                                            CrosshairLineType
                                                .both ||
                                            _lineTypeVoltage ==
                                                CrosshairLineType
                                                    .horizontal)
                                            ? true
                                            : false),
                                    edgeLabelPlacement:
                                    EdgeLabelPlacement.shift,
                                    interval: 3,
                                    majorGridLines:
                                    const MajorGridLines(
                                        width: 0)),
                                primaryYAxis: NumericAxis(
                                    interactiveTooltip: InteractiveTooltip(
                                        enable: (_lineTypeVoltage ==
                                            CrosshairLineType
                                                .both ||
                                            _lineTypeVoltage ==
                                                CrosshairLineType
                                                    .horizontal)
                                            ? true
                                            : false),
                                    labelFormat: '{value}',
                                    interval: 5,
                                    //axisLine: const AxisLine(width: 0),
                                    majorTickLines:
                                    const MajorTickLines(
                                        color: Colors
                                            .transparent)),
                                series: _LineSeriesVoltage(),
                                //trackballBehavior: _trackballBehavior,
                                tooltipBehavior:
                                TooltipBehavior(enable: true),
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
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                      children: <Widget>[
                                        Container(
                                          width: (MediaQuery.of(
                                              context)
                                              .size
                                              .width /
                                              7) *
                                              0.9,
                                          padding:
                                          const EdgeInsets
                                              .fromLTRB(
                                              24, 15, 0, 10),
                                          child: Tooltip(
                                            message: 'Zoom In',
                                            child: IconButton(
                                              icon:
                                              Icon(Icons.add),
                                              onPressed: () {
                                                _zoomPanVoltage
                                                    .zoomIn();
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: (MediaQuery.of(
                                              context)
                                              .size
                                              .width /
                                              7) *
                                              0.9,
                                          padding:
                                          const EdgeInsets
                                              .fromLTRB(
                                              20, 15, 0, 10),
                                          child: Tooltip(
                                            message: 'Zoom Out',
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.remove,
                                              ),
                                              onPressed: () {
                                                _zoomPanVoltage
                                                    .zoomOut();
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: (MediaQuery.of(
                                              context)
                                              .size
                                              .width /
                                              7) *
                                              0.9,
                                          padding:
                                          const EdgeInsets
                                              .fromLTRB(
                                              20, 15, 0, 10),
                                          child: Tooltip(
                                            message: 'Pan Up',
                                            child: IconButton(
                                              icon: Icon(
                                                Icons
                                                    .keyboard_arrow_up,
                                              ),
                                              onPressed: () {
                                                _zoomPanVoltage
                                                    .panToDirection(
                                                    'top');
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: (MediaQuery.of(
                                              context)
                                              .size
                                              .width /
                                              7) *
                                              0.9,
                                          padding:
                                          const EdgeInsets
                                              .fromLTRB(
                                              20, 15, 0, 10),
                                          child: Tooltip(
                                            message: 'Pan Down',
                                            child: IconButton(
                                              icon: Icon(
                                                Icons
                                                    .keyboard_arrow_down,
                                              ),
                                              onPressed: () {
                                                _zoomPanVoltage
                                                    .panToDirection(
                                                    'bottom');
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: (MediaQuery.of(
                                              context)
                                              .size
                                              .width /
                                              7) *
                                              0.9,
                                          padding:
                                          const EdgeInsets
                                              .fromLTRB(
                                              20, 15, 0, 10),
                                          child: Tooltip(
                                            message: 'Pan Left',
                                            child: IconButton(
                                              icon: Icon(
                                                Icons
                                                    .keyboard_arrow_left,
                                              ),
                                              onPressed: () {
                                                _zoomPanVoltage
                                                    .panToDirection(
                                                    'left');
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: (MediaQuery.of(
                                              context)
                                              .size
                                              .width /
                                              7) *
                                              0.9,
                                          padding:
                                          const EdgeInsets
                                              .fromLTRB(
                                              20, 15, 0, 10),
                                          child: Tooltip(
                                            message: 'Pan Right',
                                            child: IconButton(
                                              icon: Icon(
                                                Icons
                                                    .keyboard_arrow_right,
                                              ),
                                              onPressed: () {
                                                _zoomPanVoltage
                                                    .panToDirection(
                                                    'right');
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: (MediaQuery.of(
                                              context)
                                              .size
                                              .width /
                                              7) *
                                              0.9,
                                          padding:
                                          const EdgeInsets
                                              .fromLTRB(
                                              20, 15, 0, 10),
                                          child: Tooltip(
                                            message: 'Reset',
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.refresh,
                                              ),
                                              onPressed: () {
                                                _zoomPanVoltage
                                                    .reset();
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
                            borderRadius: BorderRadius.all(
                                Radius.circular(3))),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: SfCartesianChart(
                                legend: Legend(
                                    isVisible: true,
                                    overflowMode:
                                    LegendItemOverflowMode
                                        .wrap),

                                /// To enable the cross hair for cartesian chart.
                                crosshairBehavior:
                                CrosshairBehavior(
                                    enable: true,
                                    hideDelay: 1000,
                                    activationMode:
                                    ActivationMode
                                        .singleTap,
                                    shouldAlwaysShow: false,
                                    lineType: _lineTypeTH),
                                primaryXAxis: DateTimeAxis(
                                    dateFormat:
                                    DateFormat("HH:mm"),
                                    interactiveTooltip: InteractiveTooltip(
                                        enable: (_lineTypeTH ==
                                            CrosshairLineType
                                                .both ||
                                            _lineTypeTH ==
                                                CrosshairLineType
                                                    .horizontal)
                                            ? true
                                            : false),
                                    edgeLabelPlacement:
                                    EdgeLabelPlacement.shift,
                                    interval: 3,
                                    majorGridLines:
                                    const MajorGridLines(
                                        width: 0)),
                                primaryYAxis: NumericAxis(
                                    interactiveTooltip: InteractiveTooltip(
                                        enable: (_lineTypeTH ==
                                            CrosshairLineType
                                                .both ||
                                            _lineTypeTH ==
                                                CrosshairLineType
                                                    .horizontal)
                                            ? true
                                            : false),
                                    labelFormat: '{value}',
                                    interval: 5,
                                    //axisLine: const AxisLine(width: 0),
                                    majorTickLines:
                                    const MajorTickLines(
                                        color: Colors
                                            .transparent)),
                                series: _LineSeriesTH(),
                                //trackballBehavior: _trackballBehavior,
                                tooltipBehavior:
                                TooltipBehavior(enable: true),
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
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                      children: <Widget>[
                                        Container(
                                          width: (MediaQuery.of(
                                              context)
                                              .size
                                              .width /
                                              7) *
                                              0.9,
                                          padding:
                                          const EdgeInsets
                                              .fromLTRB(
                                              24, 15, 0, 10),
                                          child: Tooltip(
                                            message: 'Zoom In',
                                            child: IconButton(
                                              icon:
                                              Icon(Icons.add),
                                              onPressed: () {
                                                _zoomPanTH
                                                    .zoomIn();
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: (MediaQuery.of(
                                              context)
                                              .size
                                              .width /
                                              7) *
                                              0.9,
                                          padding:
                                          const EdgeInsets
                                              .fromLTRB(
                                              20, 15, 0, 10),
                                          child: Tooltip(
                                            message: 'Zoom Out',
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.remove,
                                              ),
                                              onPressed: () {
                                                _zoomPanTH
                                                    .zoomOut();
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: (MediaQuery.of(
                                              context)
                                              .size
                                              .width /
                                              7) *
                                              0.9,
                                          padding:
                                          const EdgeInsets
                                              .fromLTRB(
                                              20, 15, 0, 10),
                                          child: Tooltip(
                                            message: 'Pan Up',
                                            child: IconButton(
                                              icon: Icon(
                                                Icons
                                                    .keyboard_arrow_up,
                                              ),
                                              onPressed: () {
                                                _zoomPanTH
                                                    .panToDirection(
                                                    'top');
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: (MediaQuery.of(
                                              context)
                                              .size
                                              .width /
                                              7) *
                                              0.9,
                                          padding:
                                          const EdgeInsets
                                              .fromLTRB(
                                              20, 15, 0, 10),
                                          child: Tooltip(
                                            message: 'Pan Down',
                                            child: IconButton(
                                              icon: Icon(
                                                Icons
                                                    .keyboard_arrow_down,
                                              ),
                                              onPressed: () {
                                                _zoomPanTH
                                                    .panToDirection(
                                                    'bottom');
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: (MediaQuery.of(
                                              context)
                                              .size
                                              .width /
                                              7) *
                                              0.9,
                                          padding:
                                          const EdgeInsets
                                              .fromLTRB(
                                              20, 15, 0, 10),
                                          child: Tooltip(
                                            message: 'Pan Left',
                                            child: IconButton(
                                              icon: Icon(
                                                Icons
                                                    .keyboard_arrow_left,
                                              ),
                                              onPressed: () {
                                                _zoomPanTH
                                                    .panToDirection(
                                                    'left');
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: (MediaQuery.of(
                                              context)
                                              .size
                                              .width /
                                              7) *
                                              0.9,
                                          padding:
                                          const EdgeInsets
                                              .fromLTRB(
                                              20, 15, 0, 10),
                                          child: Tooltip(
                                            message: 'Pan Right',
                                            child: IconButton(
                                              icon: Icon(
                                                Icons
                                                    .keyboard_arrow_right,
                                              ),
                                              onPressed: () {
                                                _zoomPanTH
                                                    .panToDirection(
                                                    'right');
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: (MediaQuery.of(
                                              context)
                                              .size
                                              .width /
                                              7) *
                                              0.9,
                                          padding:
                                          const EdgeInsets
                                              .fromLTRB(
                                              20, 15, 0, 10),
                                          child: Tooltip(
                                            message: 'Reset',
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.refresh,
                                              ),
                                              onPressed: () {
                                                _zoomPanTH
                                                    .reset();
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
                            borderRadius: BorderRadius.all(
                                Radius.circular(3))),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: SfCartesianChart(
                                legend: Legend(
                                    isVisible: true,
                                    overflowMode:
                                    LegendItemOverflowMode
                                        .wrap),

                                /// To enable the cross hair for cartesian chart.
                                crosshairBehavior:
                                CrosshairBehavior(
                                    enable: true,
                                    hideDelay: 1000,
                                    activationMode:
                                    ActivationMode
                                        .singleTap,
                                    shouldAlwaysShow: false,
                                    lineType: _lineTypeKW),
                                primaryXAxis: DateTimeAxis(
                                    dateFormat:
                                    DateFormat("HH:mm"),
                                    interactiveTooltip: InteractiveTooltip(
                                        enable: (_lineTypeKW ==
                                            CrosshairLineType
                                                .both ||
                                            _lineTypeKW ==
                                                CrosshairLineType
                                                    .horizontal)
                                            ? true
                                            : false),
                                    edgeLabelPlacement:
                                    EdgeLabelPlacement.shift,
                                    interval: 3,
                                    majorGridLines:
                                    const MajorGridLines(
                                        width: 0)),
                                primaryYAxis: NumericAxis(
                                    interactiveTooltip: InteractiveTooltip(
                                        enable: (_lineTypeKW ==
                                            CrosshairLineType
                                                .both ||
                                            _lineTypeKW ==
                                                CrosshairLineType
                                                    .horizontal)
                                            ? true
                                            : false),
                                    labelFormat: '{value}',
                                    interval: 5,
                                    //axisLine: const AxisLine(width: 0),
                                    majorTickLines:
                                    const MajorTickLines(
                                        color: Colors
                                            .transparent)),
                                series: _LineSeriesKW(),
                                //trackballBehavior: _trackballBehavior,
                                tooltipBehavior:
                                TooltipBehavior(enable: true),
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
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                      children: <Widget>[
                                        Container(
                                          width: (MediaQuery.of(
                                              context)
                                              .size
                                              .width /
                                              7) *
                                              0.9,
                                          padding:
                                          const EdgeInsets
                                              .fromLTRB(
                                              24, 15, 0, 10),
                                          child: Tooltip(
                                            message: 'Zoom In',
                                            child: IconButton(
                                              icon:
                                              Icon(Icons.add),
                                              onPressed: () {
                                                _zoomPanKW
                                                    .zoomIn();
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: (MediaQuery.of(
                                              context)
                                              .size
                                              .width /
                                              7) *
                                              0.9,
                                          padding:
                                          const EdgeInsets
                                              .fromLTRB(
                                              20, 15, 0, 10),
                                          child: Tooltip(
                                            message: 'Zoom Out',
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.remove,
                                              ),
                                              onPressed: () {
                                                _zoomPanKW
                                                    .zoomOut();
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: (MediaQuery.of(
                                              context)
                                              .size
                                              .width /
                                              7) *
                                              0.9,
                                          padding:
                                          const EdgeInsets
                                              .fromLTRB(
                                              20, 15, 0, 10),
                                          child: Tooltip(
                                            message: 'Pan Up',
                                            child: IconButton(
                                              icon: Icon(
                                                Icons
                                                    .keyboard_arrow_up,
                                              ),
                                              onPressed: () {
                                                _zoomPanKW
                                                    .panToDirection(
                                                    'top');
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: (MediaQuery.of(
                                              context)
                                              .size
                                              .width /
                                              7) *
                                              0.9,
                                          padding:
                                          const EdgeInsets
                                              .fromLTRB(
                                              20, 15, 0, 10),
                                          child: Tooltip(
                                            message: 'Pan Down',
                                            child: IconButton(
                                              icon: Icon(
                                                Icons
                                                    .keyboard_arrow_down,
                                              ),
                                              onPressed: () {
                                                _zoomPanKW
                                                    .panToDirection(
                                                    'bottom');
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: (MediaQuery.of(
                                              context)
                                              .size
                                              .width /
                                              7) *
                                              0.9,
                                          padding:
                                          const EdgeInsets
                                              .fromLTRB(
                                              20, 15, 0, 10),
                                          child: Tooltip(
                                            message: 'Pan Left',
                                            child: IconButton(
                                              icon: Icon(
                                                Icons
                                                    .keyboard_arrow_left,
                                              ),
                                              onPressed: () {
                                                _zoomPanKW
                                                    .panToDirection(
                                                    'left');
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: (MediaQuery.of(
                                              context)
                                              .size
                                              .width /
                                              7) *
                                              0.9,
                                          padding:
                                          const EdgeInsets
                                              .fromLTRB(
                                              20, 15, 0, 10),
                                          child: Tooltip(
                                            message: 'Pan Right',
                                            child: IconButton(
                                              icon: Icon(
                                                Icons
                                                    .keyboard_arrow_right,
                                              ),
                                              onPressed: () {
                                                _zoomPanKW
                                                    .panToDirection(
                                                    'right');
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: (MediaQuery.of(
                                              context)
                                              .size
                                              .width /
                                              7) *
                                              0.9,
                                          padding:
                                          const EdgeInsets
                                              .fromLTRB(
                                              20, 15, 0, 10),
                                          child: Tooltip(
                                            message: 'Reset',
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.refresh,
                                              ),
                                              onPressed: () {
                                                _zoomPanKW
                                                    .reset();
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
                )
              ],
            ),
          )),
    );
  }
}
