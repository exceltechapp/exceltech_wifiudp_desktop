import 'dart:convert';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import '../Database/LogModel.dart';
import '../UDP/UDP.dart';
import '../model/ExcelfileModel.dart';
import 'FileSave.dart';

class ExcelFile {
  // define selected msd device and dub device
  var DeviceSelected;
  var DeviceSelectedName;
  // create int of object
  ExcelFile(this.DeviceSelected, this.DeviceSelectedName);
  // define list excel file elemant list
  // func for generate excel file
  void GenerateExcelfile(List<dynamic> newObjectDataList) async {
    print(newObjectDataList);
//Creating a workbook.
    final Workbook workbook = Workbook(0);
    //Adding a Sheet with name to workbook.
    final Worksheet sheet1 = workbook.worksheets.addWithName('Report');
    sheet1.showGridlines = false;
    sheet1.protect("passwordExcelTech");
    sheet1.getRangeByName('A1').setText('No');
    sheet1.getRangeByName('A1').columnWidth = 5;

    sheet1.getRangeByName('B1').setText('Date-Time');
    sheet1.getRangeByName('B1').autoFit();

    sheet1.getRangeByName('C1').setText('Status');
    sheet1.getRangeByName('C1').autoFit();

    sheet1.getRangeByName('D1').setText('TH');
    sheet1.getRangeByName('D1').columnWidth = 6;

    sheet1.getRangeByName('E1').setText('IR');
    sheet1.getRangeByName('E1').columnWidth = 6;

    sheet1.getRangeByName('F1').setText('IY');
    sheet1.getRangeByName('F1').columnWidth = 6;

    sheet1.getRangeByName('G1').setText('IB');
    sheet1.getRangeByName('G1').columnWidth = 6;

    sheet1.getRangeByName('H1').setText('VRY');
    sheet1.getRangeByName('H1').columnWidth = 6;

    sheet1.getRangeByName('I1').setText('VYB');
    sheet1.getRangeByName('I1').columnWidth = 6;

    sheet1.getRangeByName('J1').setText('VBR');
    sheet1.getRangeByName('J1').columnWidth = 6;

    sheet1.getRangeByName('K1').setText('kW');
    sheet1.getRangeByName('K1').columnWidth = 6;

    sheet1.getRangeByName('L1').setText('kWh');
    sheet1.getRangeByName('L1').columnWidth = 8;

    sheet1.getRangeByName('M1').setText('PF');
    sheet1.getRangeByName('M1').columnWidth = 6;

    sheet1.getRangeByName('N1').setText('IE');
    sheet1.getRangeByName('N1').columnWidth = 6;

    sheet1.getRangeByName('O1').setText('OL-P');
    sheet1.getRangeByName('O1').columnWidth = 6;
    var length = newObjectDataList.length;
    newObjectDataList.forEach((element) {
      ExcelFileModel newModel = element;
      print(newModel.x);
      var index = newObjectDataList.indexOf(element);
      if (true) {
        sheet1.getRangeByName('A${index + 2}').setText("${index + 1}");
        sheet1.getRangeByName('A${index + 2}').autoFit();

        sheet1.getRangeByName('B${index + 2}').setText(DateTime(
                newModel.x.year,
                newModel.x.month,
                newModel.x.day,
                newModel.x.hour,
                newModel.x.minute,
                newModel.x.second)
            .toString());
        sheet1.getRangeByName('B${index + 2}').autoFit();

        sheet1
            .getRangeByName('D${index + 2}')
            .setText("${newModel.y["TH"] ?? '-'}%");
        sheet1.getRangeByName('D${index + 2}').autoFit();

        sheet1
            .getRangeByName('E${index + 2}')
            .setText("${newModel.y["IR"] ?? '-'}");
        //sheet1.getRangeByName('E${index + 2}').autoFit();

        sheet1
            .getRangeByName('F${index + 2}')
            .setText("${newModel.y["IY"] ?? '-'}");
        //sheet1.getRangeByName('F${index + 2}').autoFit();

        sheet1
            .getRangeByName('G${index + 2}')
            .setText("${newModel.y["IB"] ?? '-'}");
        //sheet1.getRangeByName('G${index + 2}').autoFit();

        sheet1
            .getRangeByName('H${index + 2}')
            .setText("${newModel.y["VRY"] ?? '-'}");
        //sheet1.getRangeByName('H${index + 2}').autoFit();

        sheet1
            .getRangeByName('I${index + 2}')
            .setText("${newModel.y["VYB"] ?? '-'}");
        //sheet1.getRangeByName('I${index + 2}').autoFit();

        sheet1
            .getRangeByName('J${index + 2}')
            .setText("${newModel.y["VBR"] ?? '-'}");
        //sheet1.getRangeByName('J${index + 2}').autoFit();

        sheet1
            .getRangeByName('K${index + 2}')
            .setText("${newModel.y["KW"] ?? '-'}");
        //sheet1.getRangeByName('K${index + 2}').autoFit();

        sheet1
            .getRangeByName('L${index + 2}')
            .setText("${newModel.y["KWH"] ?? '-'}");
        //sheet1.getRangeByName('L${index + 2}').autoFit();

        sheet1
            .getRangeByName('M${index + 2}')
            .setText("${newModel.y["PF"] ?? '-'}");
        //sheet1.getRangeByName('M${index + 2}').autoFit();
        sheet1
            .getRangeByName('N${index + 2}')
            .setText("${newModel.y["IE"] ?? '-'}");
        //sheet1.getRangeByName('N${index + 2}').autoFit();
        sheet1
            .getRangeByName('O${index + 2}')
            .setText("${newModel.y["OLSV"] ?? '-'}");
        //sheet1.getRangeByName('O${index + 2}').autoFit();
      }
    });

    ///Create a table with the data in a range
    final ExcelTable table = sheet1.tableCollection
        .create('Table1', sheet1.getRangeByName('A1:O' + length.toString()));

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

  // func called for getting log from hive database
  void getLog(dynamic startTime, dynamic endTime) async {
    List<dynamic> newObjectDataList = [];

    try {
      List<LogEntry> logs = await UDPHandler.getLogsByTimeRangeAndInterval(
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
              newObjectDataList.add(newModel);
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
