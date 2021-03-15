import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyinvoice/controllers/firebase_controller.dart';
import 'package:easyinvoice/models/import_batch.dart';
import 'package:easyinvoice/models/item.dart';
import 'package:easyinvoice/models/job.dart';
import 'package:easyinvoice/models/service.dart';
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
    FireBaseController flutterfire = Get.find();
    String customer = data.cell(CellIndex.indexByString('B2')).value.toString();
    String techName = data.cell(CellIndex.indexByString('B4')).value.toString();
    String poNumber = data.cell(CellIndex.indexByString('K3')).value.toString();
    String requisitioner =
        data.cell(CellIndex.indexByString('K2')).value.toString();
    String location = data.cell(CellIndex.indexByString('K4')).value.toString();
    var jobDate = data.cell(CellIndex.indexByString('B3')).value;

    List<StationCharge> stationCharges = [];
    List<dynamic> header = data.rows[10];
    List<dynamic> activeRow;
    Map<Service, double> serviceMap = Map();
    Map<Item, double> itemMap = Map();
    String code;
    bool isItem;
    bool isService;
    Item item;
    Service service;

    int i = 11;
    int j = 3;
    while (data.rows[i][1].toString() != "Instance of Formula" &&
        data.rows[i][1] != null &&
        data.rows[i][1].toString().trim() != '') {
      // print('lease:${data.rows[i][1].toString()}.');
      activeRow = data.rows[i];
      while (header[j] != null) {
        // print('header: ${header[j].toString()}');
        if (activeRow[j].toString() != '0' &&
            activeRow[j].toString() != '' &&
            !activeRow[j].toString().contains('Instance of') &&
            activeRow[j] != null) {
          code = header[j].toString();
          isItem = await checkExist('items', code);
          isService =
              await checkExist('services', translateServiceHeader(code));
          if (isItem) {
            //get Item
            item = await flutterfire.getItem(code);
            itemMap[item] = double.parse(activeRow[j].toString());
          } else if (isService) {
            // get Service
            service =
                await flutterfire.getService(translateServiceHeader(code));
            serviceMap[service] = double.parse(activeRow[j].toString());
          }

          print(
              'chargeMap[${header[j].toString()}] = ${double.parse(activeRow[j].toString())}');
        }
        j++;
      }
      print('creating charge...');
      stationCharges.add(StationCharge(
        leaseNumber: activeRow[0].toString(),
        leaseName: activeRow[1].toString(),
        notes: activeRow[2].toString(),
        itemMap: Map.of(itemMap),
        serviceMap: Map.of(serviceMap),
      ));
      i++;
      j = 3;
      itemMap.clear();
      serviceMap.clear();
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

  static Future<bool> checkExist(String collection, String docID) async {
    bool exists = false;
    FireBaseController fireBaseController = Get.find();
    try {
      await fireBaseController.firebase
          .collection('$collection')
          .doc('$docID')
          .get()
          .then((doc) {
        if (doc.exists) {
          exists = true;
          print('$collection $docID exists');
        } else {
          print('$collection $docID doesn\'t exist');
          exists = false;
        }
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  String translateServiceHeader(String header) {
    // map work ticket column header to firestore service name
    String serviceCode;

    switch (header.trim().toLowerCase()) {
      case 'sample':
        serviceCode = 'c6GasSample';
        break;
      case 'stain tube':
        serviceCode = 'stainTube';
        break;
      case 'efm collect':
        serviceCode = 'efmCollection';
        break;
      case 'travel':
        serviceCode = 'travelTime';
        break;
      case 'tech time':
        serviceCode = 'techTime';
        break;
      case 'miles':
        serviceCode = 'mileage';
        break;
      default:
        serviceCode = header.toLowerCase();
    }

    return serviceCode;
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
