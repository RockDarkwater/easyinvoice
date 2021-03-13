import 'dart:convert';

import 'package:easyinvoice/models/import_batch.dart';
import 'package:easyinvoice/models/job.dart';
import 'package:easyinvoice/models/station_charge.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class ImportController extends GetxController {
  Future<ImportBatch> import() async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    List<Sheet> sheets = [];
    Map<String, List<List<String>>> txtDocs = Map();
    List<String> rows;
    Excel book;
    String testVal;

    result.files.forEach((element) async {
      if (element.name.contains('.csv') || element.name.contains('.txt')) {
        //import text files
        rows = LineSplitter().convert(String.fromCharCodes(element.bytes));
        txtDocs['${element.name}'] = List.generate(rows.length, (index) {
          return rows[index].split(',');
        });
      } else if (element.name.contains('.xls')) {
        //import excel files
        print('not csv');
        book = Excel.decodeBytes(element.bytes);
        if (book.sheets.keys.contains('Billing_Export'))
          testVal = 'Billing_Export';
        if (book.sheets.keys.contains('Work Ticket')) testVal = 'Work Ticket';
        testVal ?? book.sheets.keys.first.toString();
        sheets.add(book.sheets['$testVal']);
      } else {
        print('${element.name} is not text or excel');
      }

      // sheets.add(book.sheets[testVal]);
    });

    return ImportBatch(spreadsheets: sheets, txtDocs: txtDocs);
  }

  Future<List<Job>> buildAmisJobs(List<List<String>> data) {}

  Future<List<Job>> buildAccugasJobs(Sheet data) {}

  Future<Job> buildWorkTicketJob(Sheet data) async {
    //set normal
    String customer = data.cell(CellIndex.indexByString('B2')).toString();
    String techName = data.cell(CellIndex.indexByString('B4')).toString();
    String poNumber = data.cell(CellIndex.indexByString('K3')).toString();
    String requisitioner = data.cell(CellIndex.indexByString('K2')).toString();
    String location = data.cell(CellIndex.indexByString('K4')).toString();
    var jobDate = data.cell(CellIndex.indexByString('B3'));

    List<StationCharge> stationCharges = [];
    List<dynamic> header = data.rows[10];
    List<dynamic> activeRow;
    Map<dynamic, double> chargeMap = Map();

    int i = 11;
    int j = 3;
    while (data.rows[i][1].toString() != "Instance of Formula") {
      activeRow = data.rows[i];
      while (header[j].toString() != 'null') {
        print('header: ${header[j].toString()} = ${data.rows[i].toString()}');
        if (activeRow[j].toString() != '0' &&
            activeRow[j].toString() != '' &&
            !activeRow[j].toString().contains('Instance of')) {
          chargeMap[header[j]] = activeRow[j];
        }
        j++;
      }
      stationCharges.add(StationCharge(
        leaseNumber: activeRow[0].toString(),
        leaseName: activeRow[1].toString(),
        notes: activeRow[2].toString(),
        chargeMap: chargeMap,
      ));
      i++;
      j = 3;
      chargeMap.clear();
    }
    return Job(
      customer: customer,
      techName: techName,
      poNumber: poNumber,
      requisitioner: requisitioner,
      location: location,
      jobDate: jobDate,
      stationCharges: stationCharges,
    );
    // while (!data.rows[i][1].isBlank) {
    //   activeRow = data.rows[i];

    //   stationCharges.add(StationCharge(
    //     leaseNumber: activeRow[0].toString(),
    //     leaseName: activeRow[1].toString(),
    //     notes: activeRow[2],
    //   ));
    // }
  }

  String getGasService(String value) {
    String serviceName;
    bool ext = false;
    bool liq = false;
    // check for non-standard charges
    if (value.contains('rvp')) serviceName = 'rvpCalc';
    if (value.contains('flash')) serviceName = 'flash';
    if (value.contains('api')) serviceName = 'apiGrav';
    if (value.contains('sulph')) serviceName = 'sulphur';
    if (value.contains('recom')) serviceName = 'recomb';

    // if standard sample, parse description
    if (serviceName == null) {
      if (value.contains('ext')) ext = true;
      if (value.contains('liq')) liq = true;

      if (ext && liq) serviceName = 'extLiquidSample';
      if (!ext && liq) serviceName = 'c6LiquidSample';
      if (ext && !liq) serviceName = 'extGasSample';
      if (!ext && !liq) serviceName = 'c6GasSample';
    }
    print('$value = $serviceName');
    return serviceName;
  }
}
