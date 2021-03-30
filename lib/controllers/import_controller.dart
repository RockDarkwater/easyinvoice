import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyinvoice/controllers/firebase_controller.dart';
import 'package:easyinvoice/models/customer.dart';
import 'package:easyinvoice/models/item.dart';
import 'package:easyinvoice/models/job.dart';
import 'package:easyinvoice/models/service.dart';
import 'package:easyinvoice/models/station_charge.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImportController extends GetxController {
  RxList<Job> jobs = <Job>[].obs;
  RxInt importQty = 1.obs;
  RxInt currentImport = 1.obs;
  RxInt processQty = 1.obs;
  RxInt currentProcess = 1.obs;
  RxList<String> resultNames = <String>[''].obs;

  Future<void> import() async {
    print('starting import.');
    FilePickerResult result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    resultNames.insertAll(0, result.names);
    List<List<String>> txtFile;
    List<String> rows;
    Excel book;
    String date;

    print('imported ${result.files.length} files');
    importQty.value = result.files.length;
    //For each picked file, either add csv to txtDocs, or add excel to sheets
    for (int i = 0; i < result.files.length; i++) {
      currentImport.value = i;
      if (result.files[i].name.contains('.txt')) {
        //import text files
        print('txt file');
        rows =
            LineSplitter().convert(String.fromCharCodes(result.files[i].bytes));
        txtFile = List.generate(rows.length, (index) {
          return rows[index].split('\t');
        });
        date = result.files[i].name;
        date = date.substring(date.indexOf('_') + 1, date.indexOf('.'));
        print(date);
        await buildAmisJobs(txtFile, date);
      } else if (result.files[i].name.contains('.xls')) {
        //import excel files
        print(
            'filetype: ${result.files[i].name.substring(result.files[i].name.indexOf('.'), result.files[i].name.length)}');
        book = Excel.decodeBytes(result.files[i].bytes);

        // Convert from Amis
        if (book.sheets.keys.contains('Billing_Export'))
          await buildAccugasJobs(book['Billing_Export']);
        // Convert from Work Ticket
        if (book.sheets.keys.contains('Work Ticket')) {
          await buildWorkTicketJob(book['Work Ticket']);
        }
      } else {
        print('${result.files[i].name} is not text or excel');
      }
    }
  }

  Future<void> buildAmisJobs(List<List<String>> data, String date) async {
    print('starting Amis import.');

    //construction variables
    Job job;
    StationCharge stationCharge;
    Service service;
    double quantity;
    int cycle;
    bool orifice;

    //job variables
    Customer customer;
    String techName;
    String location;
    DateTime jobDate;

    //station charge variables
    String leaseName;
    String leaseNumber;
    String notes;
    print('looping through ${data.length} rows');
    processQty.value = data.length;
    //for each row after header, add service charge to job-> station charge -> item map
    for (int i = 1; i < data.length; i++) {
      currentProcess.value = i;
      // print('Row Customer: ${data[i][0]}');
      if (customer?.custNum != data[i][0].toString()) {
        customer = await parseCustomer(data[i][0]);
      }
      //get raw data
      techName = 'amis';
      location = data[i][17];
      leaseName = data[i][5];
      leaseNumber = data[i][4];
      notes = data[i][6];
      jobDate = DateTime.tryParse(date.replaceAll('_', '-'));
      cycle = int.tryParse(data[i][7]) ?? 0;
      orifice = !notes.contains('EGM');
      quantity = double.tryParse(data[i][11]) ?? 0;
      service = await getChartService(cycle: cycle, orifice: orifice);

      // check if job exists for same customer.
      //   - if not make it with the current line station charge.
      job = jobs.firstWhere((job) => job.customer.custNum == customer.custNum,
          orElse: () {
        print('new customer job: ${customer.billingName}');
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

      // if job exists, check if station charge has been created.
      //  - if not, make it and then add the line charge.
      stationCharge = job.stationCharges
          .firstWhere((charge) => charge.leaseName == leaseName, orElse: () {
        // print('new station charge job: $leaseName');
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

      // if station has the current charge, add additional quantity.
      // if not, add service & quantity to charge map.
      if (stationCharge.serviceMap.containsKey(service)) {
        stationCharge.serviceMap[service] += quantity;
      } else {
        stationCharge.serviceMap[service] = quantity;
      }
    }
    processQty.value = 1;
    currentProcess.value = 0;
    print('ending Amis import.');
  }

  Future<void> buildAccugasJobs(Sheet data) async {
    print('starting AccuGas import.');

    //construction variables
    String custNum;
    Service service;

    //job variables
    Customer customer;
    String techName;
    String location;
    DateTime jobDate;

    //station charge variables
    String leaseName;
    String leaseNumber;
    String notes;

    processQty.value = data.maxRows;
    print('looping ${data.maxRows} rows');
    //for each row after header, add service charge to job-> station charge -> item map
    for (int i = 2; i <= data.maxRows; i++) {
      //get raw data

      currentProcess.value = i;
      custNum = data.cell(CellIndex.indexByString("C$i")).value.toString();
      techName = data.cell(CellIndex.indexByString("BA$i")).value.toString();
      location = data.cell(CellIndex.indexByString("AX$i")).value.toString();
      jobDate = DateTime.tryParse(
          data.cell(CellIndex.indexByString("I$i")).value.toString());
      leaseName = data.cell(CellIndex.indexByString("F$i")).value.toString();
      leaseNumber = data.cell(CellIndex.indexByString("D$i")).value.toString();
      notes = data.cell(CellIndex.indexByString("M$i")).value.toString();
      service = await getGasService(notes);
      customer = await parseCustomer(custNum);

      //check if job exists for same customer, if not make it.
      jobs
              .firstWhere((job) => job.customer.custNum == customer.custNum,
                  orElse: () {
                // print('new job: ${customer.custNum}');
                Job newJob = Job(
                    customer: customer,
                    techName: techName,
                    location: location,
                    jobDate: jobDate,
                    stationCharges: []);
                jobs.add(newJob);
                return newJob;
              })
              .stationCharges
              .firstWhere((charge) => charge.leaseNumber == leaseNumber,
                  orElse: () {
                // print('new station charge: $leaseNumber');
                StationCharge newCharge = StationCharge(
                  leaseName: leaseName,
                  leaseNumber: leaseNumber,
                  notes: notes,
                  serviceMap: {service: 0},
                  itemMap: {},
                );
                jobs
                    .firstWhere(
                        (job) => job.customer.custNum == customer.custNum)
                    .stationCharges
                    .add(newCharge);
                return newCharge;
              })
              .serviceMap[
          jobs
              .firstWhere((job) => job.customer.custNum == customer.custNum)
              .stationCharges
              .firstWhere((charge) => charge.leaseNumber == leaseNumber)
              .serviceMap
              .keys
              .firstWhere((key) => key.name == service.name)] += 1;
    }
    processQty.value = 1;
    currentProcess.value = 0;
    print('ending Accugas import.');
  }

  Future<void> buildWorkTicketJob(Sheet data) async {
    //set normal
    print('starting WT import');
    FireBaseController flutterfire = Get.find();
    Customer customer = await parseCustomer(
        data.cell(CellIndex.indexByString('B2')).value.toString());
    String techName = data.cell(CellIndex.indexByString('B4')).value.toString();
    String poNumber = data.cell(CellIndex.indexByString('K3')).value.toString();
    String requisitioner =
        data.cell(CellIndex.indexByString('K2')).value.toString();
    String location = data.cell(CellIndex.indexByString('K4')).value.toString();
    DateTime jobDate = DateTime.tryParse(
        data.cell(CellIndex.indexByString('B3')).value.toString());

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
            // print('item: ${item.name} added, x${itemMap[item]}');
          } else if (isService) {
            // get Service
            service =
                await flutterfire.getService(translateServiceHeader(code));
            serviceMap[service] = double.tryParse(activeRow[j].toString()) ?? 0;

            // print('service: ${service.name} added, x${serviceMap[service]}');
          }

          // print(
          //     'chargeMap[${header[j].toString()}] = ${double.tryParse(activeRow[j].toString())}');
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
    jobs.add(Job(
      customer: customer,
      techName: techName,
      poNumber: poNumber,
      requisitioner: requisitioner,
      location: location,
      jobDate: jobDate,
      stationCharges: stationCharges,
    ));
  }

  Future<bool> checkExist(String collection, String docID) async {
    FireBaseController fireBaseController = Get.find();

    DocumentSnapshot ds = await fireBaseController.firebase
        .collection('$collection')
        .doc('$docID')
        .get();
    return ds.exists;
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
    // print('$cycle - $orifice');
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

  Future<Customer> parseCustomer(String customer) async {
    FireBaseController controller = Get.find();
    Customer cust;
    QuerySnapshot qry;
    List<String> searchVals;
    String testNum;

    // if customer given is primarily numeric and only one word, assume customer number and build
    (customer.length > 1)
        ? testNum = customer.substring(0, 2)
        : testNum = customer;
    if (int.tryParse(testNum) != null && customer.split(' ').length == 1) {
      String testCust = customer.toString();
      // print('customer request is numeric: $customer');
      cust = await controller?.getCustomer('$customer');
      while (cust == null && testCust.substring(0, 1) == '0') {
        // print('couldn\'t find $testCust, removing zero');
        testCust = testCust.substring(1, testCust.length);
        // print('getting $testCust');
        cust = await controller?.getCustomer('$testCust');
      }
    }

    if (cust == null) {
      // print('searching string $customer');
      // if non-numeric or multi-word, search each word and compile a list of potential customers
      searchVals =
          customer.toLowerCase().replaceAll(RegExp(r"[^\s\w]"), '').split(' ');
      searchVals.removeWhere((element) => element.length == 0);

      qry = await controller.firebase
          .collection('customers')
          ?.where('searchValues', arrayContains: searchVals[0])
          ?.get();
      if (qry == null) print('could not find ${searchVals[0]}');

      // print('found ${qry.docs.length} documents ');

      if (qry.docs.length > 1) {
        return await Get.dialog(
          AlertDialog(
            content: Container(
              height: 400,
              width: 800,
              child: Column(
                children: [
                  Text(
                    'Choose customer number for $customer',
                    style:
                        TextStyle(fontSize: 24, color: Colors.deepOrange[800]),
                  ),
                  Flexible(
                    child: ListView.builder(
                        itemCount: qry.docs.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              'C - ${qry.docs[index].id}: ${qry.docs[index].data()['billingName']}',
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none),
                            ),
                            onTap: () async {
                              // print(qry.docs[index].id);
                              Get.back(
                                  result: await controller
                                      .getCustomer(qry.docs[index].id));
                            },
                            focusColor: Colors.white54,
                          );
                        }),
                  ),
                ],
              ),
            ),
            scrollable: true,
          ),
          barrierColor: Colors.white70,
        );
      } else {
        return await controller.getCustomer(qry.docs.first.id);
      }
    } else
      return cust;
  }
}
