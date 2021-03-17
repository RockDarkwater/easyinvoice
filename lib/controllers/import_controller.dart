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
    Map<int, List<List<String>>> txtDocs = Map();
    List<String> rows;
    Excel book;
    String testVal;

    //For each picked file, either add csv to txtDocs, or add excel to sheets
    result.files.forEach((element) async {
      if (element.name.contains('.txt')) {
        //import text files
        print('csv file');
        rows = LineSplitter().convert(String.fromCharCodes(element.bytes));
        txtDocs[txtDocs.length] = List.generate(rows.length, (index) {
          return rows[index].split('\t');
        });
      } else if (element.name.contains('.xls')) {
        //import excel files
        print('not csv');
        book = Excel.decodeBytes(element.bytes);

        // Flag as Amis
        if (book.sheets.keys.contains('Billing_Export'))
          testVal = 'Billing_Export';

        // Flag as Work Ticket
        if (book.sheets.keys.contains('Work Ticket')) testVal = 'Work Ticket';

        // Flag as other
        testVal ?? book.sheets.keys.first.toString();
        sheets.add(book.sheets['$testVal']);
      } else {
        print('${element.name} is not text or excel');
      }
    });

    return ImportBatch(spreadsheets: sheets, txtDocs: txtDocs);
  }

  Future<List<Job>> buildAmisJobs(List<List<String>> data) async {
    //core variables
    FireBaseController flutterfire = Get.find();
    List<Job> jobs = [];

    //construction variables
    Job job;
    StationCharge stationCharge;
    Map<Service, double> serviceMap = Map();
    Service service;
    double quantity;
    int cycle;
    bool orifice;

    //job variables
    String customer;
    String techName;
    String location;
    var jobDate;

    //station charge variables
    String leaseName;
    String leaseNumber;
    String notes;

    print('looping: ${data.length} times');
    //for each row after header, add service charge to job-> station charge -> item map
    for (int i = 1; i < data.length; i++) {
      if (customer != data[i][0]) {
        print('new customer: ${data[i][0]}');
      }
      //get raw data
      customer = data[i][0];
      techName = 'amis';
      location = data[i][17];
      leaseName = data[i][5];
      leaseNumber = data[i][4];
      notes = data[i][6];
      cycle = int.tryParse(data[i][7]) ?? 0;
      orifice = !notes.contains('EGM');
      quantity = double.tryParse(data[i][11]) ?? 0;
      service = await getChartService(cycle: cycle, orifice: orifice);

      //check if job exists for same customer, if not make it.
      job = jobs.firstWhere((job) => job.customer == customer, orElse: () {
        print('job for $customer does not exist');
        Job newJob = Job(
            customer: customer,
            techName: techName,
            location: location,
            jobDate: jobDate,
            stationCharges: [
              StationCharge(
                leaseName: leaseName,
                leaseNumber: leaseNumber,
                notes: notes,
                serviceMap: {service: quantity},
                itemMap: {},
              ),
            ]);
        jobs.add(newJob);
        return newJob;
      });

      //check if station charge exists for job, if not, make it and then add it.
      stationCharge = job.stationCharges
          .firstWhere((charge) => charge.leaseName == leaseName, orElse: () {
        StationCharge newCharge = StationCharge(
          leaseName: leaseName,
          leaseNumber: leaseNumber,
          notes: notes,
          serviceMap: {service: quantity},
          itemMap: {},
        );
        job.stationCharges.add(newCharge);
        return newCharge;
      });

      //check if station charge includes service, if not, make it.
      if (serviceMap.containsKey(service)) {
        serviceMap[service] += quantity;
      } else {
        serviceMap[service] = quantity;
      }
    }
    return jobs;
  }

  Future<List<Job>> buildAccugasJobs(Sheet data) async {
    //core variables
    FireBaseController flutterfire = Get.find();
    List<Job> jobs = [];

    //construction variables
    Job job;
    StationCharge stationCharge;
    Map<Service, double> serviceMap = Map();
    Service service;
    int quantity;

    //job variables
    String customer;
    String techName;
    String location;
    var jobDate;

    //station charge variables
    String leaseName;
    String leaseNumber;
    String notes;

    //for each row after header, add service charge to job-> station charge -> item map
    for (int i = 2; i < data.maxRows; i++) {
      //get raw data
      customer = data.cell(CellIndex.indexByString("C$i")).value.toString();
      techName = data.cell(CellIndex.indexByString("BA$i")).value.toString();
      location = data.cell(CellIndex.indexByString("AX$i")).value.toString();
      jobDate = data.cell(CellIndex.indexByString("I$i")).value;
      leaseName = data.cell(CellIndex.indexByString("F$i")).value.toString();
      leaseNumber = data.cell(CellIndex.indexByString("D$i")).value.toString();
      notes = data.cell(CellIndex.indexByString("M$i")).value.toString();
      service = await getGasService(notes);

      //check if job exists for same customer, if not make it.
      job = jobs.firstWhere((job) => job.customer == customer, orElse: () {
        // print('job for $customer does not exist');
        Job newJob = Job(
            customer: customer,
            techName: techName,
            location: location,
            jobDate: jobDate,
            stationCharges: [
              StationCharge(
                leaseName: leaseName,
                leaseNumber: leaseNumber,
                notes: notes,
                serviceMap: {service: 1},
                itemMap: {},
              ),
            ]);
        jobs.add(newJob);
        return newJob;
      });

      //check if station charge exists for job, if not, make it and then add it.
      stationCharge = job.stationCharges
          .firstWhere((charge) => charge.leaseName == leaseName, orElse: () {
        StationCharge newCharge = StationCharge(
          leaseName: leaseName,
          leaseNumber: leaseNumber,
          notes: notes,
          serviceMap: {service: 1},
          itemMap: {},
        );
        job.stationCharges.add(newCharge);
        return newCharge;
      });

      //check if station charge includes service, if not, make it.
      if (serviceMap.containsKey(service)) {
        serviceMap[service]++;
      } else {
        serviceMap[service] = 1;
      }
    }
    return jobs;
  }

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
            itemMap[item] = double.tryParse(activeRow[j].toString()) ?? 0;
          } else if (isService) {
            // get Service
            service =
                await flutterfire.getService(translateServiceHeader(code));
            serviceMap[service] = double.tryParse(activeRow[j].toString()) ?? 0;
          }

          print(
              'chargeMap[${header[j].toString()}] = ${double.tryParse(activeRow[j].toString())}');
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

  Future<Service> getGasService(String value) async {
    FireBaseController fireBaseController = Get.find();
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
    // print('$value = $serviceName');
    return await fireBaseController.getService(serviceName);
  }

  Future<Service> getChartService({int cycle, bool orifice}) async {
    FireBaseController controller = Get.find();
    print('$cycle - $orifice');
    String servCode;
    if (orifice) {
      switch (cycle) {
        case 1:
          servCode = 'chart24';
          break;
        case 7:
          servCode = 'chart78';
          break;
        case 8:
          servCode = 'chart78';
          break;
        case 16:
          servCode = 'chart16';
          break;
        case 31:
          servCode = 'chart31';
          break;
        default:
          servCode = 'chart31';
      }
    } else
      servCode = 'efmMeter';

    return await controller.getService(servCode);
  }
}
