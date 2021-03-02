import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';

import 'item.dart';
import 'service.dart';

class StationCharge {
  String leaseName;
  String leaseNumber;
  String poNumber;
  Map<dynamic, double> chargeMap = Map();

  StationCharge.fromWorkTicket(Sheet workTicket, List<dynamic> row) {
    // pull number from column A, name from column B, and potential PO from C.
    leaseName = row[1].value.toString() ?? '';
    leaseNumber = row[0].value.toString() ?? '';
    poNumber = row[2].value.toString() ?? '';

    print('$leaseNumber - $leaseName: type: $poNumber');

    // create item map using row 11 as the header and row value as quantity
    //loop until column 12 is empty
    int i = 0;
    double qty = 0.0;

    while (workTicket.row(10)[i].value != null &&
        workTicket.row(10)[i].value.toString().trim() != '') {
      //starting with column D, map charges until last item in row 11
      if (i > 2) {
        print(
            'item: ${workTicket.row(10)[i].value} - cell value: ${row[i].value.toString()}');
        if (i < 12 && row[i].value != null) {
          // create service
          try {
            qty = double.parse(row[i].value.toString());
            if (qty > 0)
              chargeMap[createService(workTicket.row(10)[i].value)] = qty;
          } catch (err) {
            print('couldn\'t build service ${workTicket.row(10)[i].value}');
          }
        } else if (row[i].value != null) {
          // create item
          try {
            qty = double.parse(row[i].value.toString());
            if (qty > 0)
              chargeMap[createItem(workTicket.row(10)[i].value)] = qty;
          } catch (err) {
            print('couldn\'t build item ${workTicket.row(10)[i].value}');
          }
        }

        print('total charges: ${chargeMap.keys.length}');
      }
      i++;
    }
  }

  Item createItem(String itemCode) {
    String name;
    double cost;
    double price;

    FirebaseFirestore.instance
        .collection('items')
        .doc(itemCode)
        .get()
        .then((value) {
      if (value.exists) {
        name = value.data()['name'];
        price = value.data()['price'];
        cost = value.data()['cost'];
      } else {
        print('$itemCode does not exist');
      }
    }).onError((error, stackTrace) {
      print('Error retrieving item: ' + error.toString());
      print('Stacktrace: ' + stackTrace.toString());
    });

    return Item(itemCode, name, price, cost);
  }

  Service createService(String code) {
    String serviceCode = translateHeader(code);
    String name;
    String qbName;
    String category;
    double workUnits;

    FirebaseFirestore.instance
        .collection('services')
        .doc('$serviceCode')
        .get()
        .then((value) {
      if (value.exists) {
        name = value.data()['name'];
        qbName = value.data()['qbName'];
        category = value.data()['category'];
        workUnits = value.data()['workUnits'];
      } else {
        print('$serviceCode does not exist');
      }
    }).onError((error, stackTrace) {
      print('error with service: $error');
      print('stacktrace: $stackTrace');
    });

    return Service(serviceCode, name, qbName, category, workUnits);
  }

  String translateHeader(String header) {
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
}
