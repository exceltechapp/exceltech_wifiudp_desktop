import 'dart:convert';
import 'dart:ui';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import '../Database/LogModel.dart';
import '../UDP/UDP.dart';
import '../model/ExcelfileModel.dart';
import 'FileSave.dart';

class ExcelFile {
  var condition = [
    "Healthy", //0
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
  final List<String> itemsModel = ['µLEDX-T', 'µeLEDX-T'];
  // define selected msd device and dub device
  var DeviceSelected;
  var DeviceSelectedName;
  // create int of object
  ExcelFile(this.DeviceSelected, this.DeviceSelectedName);
  // define list excel file elemant list
  // func for generate excel file
  void GenerateExcelfile(List<dynamic> newObjectDataList) async {
    print(newObjectDataList);
    ExcelFileModel RawModel = newObjectDataList.last;
//Creating a workbook.
    final Workbook workbook = Workbook(0);
    //Adding a Sheet with name to workbook.
    final Worksheet sheet1 = workbook.worksheets.addWithName('Report');
    sheet1.showGridlines = false;
    sheet1.protect("passwordExcelTech");

    sheet1.getRangeByName('B2').text = 'MSD-Device:- ${jsonDecode(DeviceSelected)["DeviceName"]}';
    sheet1.getRangeByName('B2').cellStyle.bold = true;
    sheet1.getRangeByName('B2').cellStyle.fontSize = 12;

    sheet1.getRangeByName('B3').text = 'Model:- ${itemsModel[RawModel.y["MODEL"]]}';
    sheet1.getRangeByName('B3').cellStyle.bold = true;
    sheet1.getRangeByName('B3').cellStyle.fontSize = 12;

    sheet1.getRangeByName('B4').text = 'Device-ID:- ${DeviceSelectedName}';
    sheet1.getRangeByName('B4').cellStyle.bold = true;
    sheet1.getRangeByName('B4').cellStyle.fontSize = 12;

    sheet1.getRangeByName('B5').text = 'Device-Name:- ${RawModel.y["IDN"]}';
    sheet1.getRangeByName('B5').cellStyle.bold = true;
    sheet1.getRangeByName('B5').cellStyle.fontSize = 12;

    sheet1.getRangeByName('A7').setText('No');
    sheet1.getRangeByName('A7').columnWidth = 5;

    sheet1.getRangeByName('B7').setText('Date');
    sheet1.getRangeByName('B7').autoFit();

    sheet1.getRangeByName('C7').setText('Time');
    sheet1.getRangeByName('C7').autoFit();

    sheet1.getRangeByName('D7').setText('Status');
    sheet1.getRangeByName('D7').columnWidth = 12;

    sheet1.getRangeByName('E7').setText('TH');
    sheet1.getRangeByName('E7').columnWidth = 6;

    sheet1.getRangeByName('F7').setText('IR');
    sheet1.getRangeByName('F7').columnWidth = 6;

    sheet1.getRangeByName('G7').setText('IY');
    sheet1.getRangeByName('G7').columnWidth = 6;

    sheet1.getRangeByName('H7').setText('IB');
    sheet1.getRangeByName('H7').columnWidth = 6;

    sheet1.getRangeByName('I7').setText('VRY');
    sheet1.getRangeByName('I7').columnWidth = 6;

    sheet1.getRangeByName('J7').setText('VYB');
    sheet1.getRangeByName('J7').columnWidth = 6;

    sheet1.getRangeByName('K7').setText('VBR');
    sheet1.getRangeByName('K7').columnWidth = 6;

    sheet1.getRangeByName('L7').setText('kW');
    sheet1.getRangeByName('L7').columnWidth = 6;

    sheet1.getRangeByName('M7').setText('kWh');
    sheet1.getRangeByName('M7').columnWidth = 8;

    sheet1.getRangeByName('N7').setText('PF');
    sheet1.getRangeByName('N7').columnWidth = 6;

    sheet1.getRangeByName('O7').setText('IE');
    sheet1.getRangeByName('O7').columnWidth = 6;

    sheet1.getRangeByName('P7').setText('OL-P');
    sheet1.getRangeByName('P7').columnWidth = 6;
    var length = newObjectDataList.length;
    newObjectDataList.forEach((element) {
      ExcelFileModel newModel = element;
      print(newModel.x);
      var index = newObjectDataList.indexOf(element);
      if (true) {
        sheet1.getRangeByName('A${index + 8}').setText("${index + 1}");
        sheet1.getRangeByName('A${index + 8}').autoFit();

        sheet1.getRangeByName('B${index + 8}').setText(DateTime(
                newModel.x.year,
                newModel.x.month,
                newModel.x.day,
                newModel.x.hour,
                newModel.x.minute,
                newModel.x.second)
            .toIso8601String().split("T").first);
        sheet1.getRangeByName('B${index + 8}').autoFit();

        sheet1.getRangeByName('C${index + 8}').setText(DateTime(
            newModel.x.year,
            newModel.x.month,
            newModel.x.day,
            newModel.x.hour,
            newModel.x.minute,
            newModel.x.second)
            .toIso8601String().split("T").last.split(".").first);
        sheet1.getRangeByName('C${index + 8}').autoFit();

        sheet1
            .getRangeByName('D${index + 8}')
            .setText("${newModel.y["ERROR"] != 255 ? condition[newModel.y["STATUS"]] ?? "-":"DISCONNECT"}");
        //sheet1.getRangeByName('D${index + 8}').autoFit();
        sheet1
            .getRangeByName('D${index + 8}').cellStyle.backColorRgb = newModel.y["ERROR"] != 255 ? newModel.y["STATUS"] == 0 ? Color.fromARGB(255, 67, 233, 123) : Color.fromARGB(255, 255, 105, 124) : Color.fromARGB(255, 255, 255, 255);

        sheet1
            .getRangeByName('E${index + 8}')
            .setText("${newModel.y["TH"] ?? '-'}%");
        //sheet1.getRangeByName('E${index + 8}').autoFit();


        sheet1
            .getRangeByName('F${index + 8}')
            .setText("${newModel.y["IR"] ?? '-'}");
        //sheet1.getRangeByName('E${index + 2}').autoFit();

        sheet1
            .getRangeByName('G${index + 8}')
            .setText("${newModel.y["IY"] ?? '-'}");
        //sheet1.getRangeByName('F${index + 2}').autoFit();

        sheet1
            .getRangeByName('H${index + 8}')
            .setText("${newModel.y["IB"] ?? '-'}");
        //sheet1.getRangeByName('G${index + 2}').autoFit();

        sheet1
            .getRangeByName('I${index + 8}')
            .setText("${newModel.y["VRY"] ?? '-'}");
        //sheet1.getRangeByName('H${index + 2}').autoFit();

        sheet1
            .getRangeByName('J${index + 8}')
            .setText("${newModel.y["VYB"] ?? '-'}");
        //sheet1.getRangeByName('I${index + 2}').autoFit();

        sheet1
            .getRangeByName('K${index + 8}')
            .setText("${newModel.y["VBR"] ?? '-'}");
        //sheet1.getRangeByName('J${index + 2}').autoFit();

        sheet1
            .getRangeByName('L${index + 8}')
            .setText("${newModel.y["KW"] ?? '-'}");
        //sheet1.getRangeByName('K${index + 2}').autoFit();

        sheet1
            .getRangeByName('M${index + 8}')
            .setText("${newModel.y["KWH"] ?? '-'}");
        //sheet1.getRangeByName('L${index + 2}').autoFit();

        sheet1
            .getRangeByName('N${index + 8}')
            .setText("${newModel.y["PF"] ?? '-'}");
        //sheet1.getRangeByName('M${index + 2}').autoFit();
        sheet1
            .getRangeByName('O${index + 8}')
            .setText("${newModel.y["IE"] ?? '-'}");
        //sheet1.getRangeByName('N${index + 2}').autoFit();
        sheet1
            .getRangeByName('P${index + 8}')
            .setText("${newModel.y["OLSV"] ?? '-'}");
        //sheet1.getRangeByName('O${index + 2}').autoFit();
      }
    });

    ///Create a table with the data in a range
    final ExcelTable table = sheet1.tableCollection
        .create('Table1', sheet1.getRangeByName('A7:P${length+6}'));

    ///Formatting table with a built-in style
    table.builtInTableStyle = ExcelTableBuiltInStyle.tableStyleMedium15;
    table.showTotalRow = true;
    table.showFirstColumn = true;
    table.showBandedColumns = true;
    table.showBandedRows = true;

    final List<int> bytes = workbook.saveSync();
    workbook.dispose();

    //Launch file.
    await FileSaveHelper.saveAndLaunchFile(bytes, 'DeviceReport.xlsx');
    newObjectDataList.clear();
  }
  // define buff var for last min
  var LastMinCheck;
  // func called for getting log from hive database
  void getLog(dynamic startTime, dynamic endTime) async {
    List<dynamic> newObjectDataList = [];

    try {
      List<LogEntry> logs = await UDPHandler.getLogsByTimeRange(
        DateTime.parse(startTime.toString()),
        DateTime.parse(endTime.toString()),
      );

      if (DeviceSelected == null || DeviceSelectedName == null) {
        return;
      }

      var key = jsonDecode(DeviceSelected!)["DeviceMac"];

      logs.forEach((log) {
        if (log.data is String) {
          try {
            Map<String, dynamic> newdata = jsonDecode(log.data);
            if (newdata["ID"] == DeviceSelectedName &&
                newdata["MAC"] == key) {
              ExcelFileModel newModel =
              ExcelFileModel(DateTime.parse(log.time), newdata);
              if(LastMinCheck != DateTime.parse(log.time).minute) {
                newObjectDataList.add(newModel);
                LastMinCheck = DateTime.parse(log.time).minute;
              }
            }
          } catch (e) {
            print(e);
            // Handle JSON decoding error
          }
        }
      });

      GenerateExcelfile(newObjectDataList); // Call the generator after populating the list
    } catch (error) {
      print(error);
      // Handle error
    }
  }

}
