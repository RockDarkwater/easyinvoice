import 'package:excel/excel.dart';

import 'item.dart';
import 'service.dart';

class StationCharge {
  String leaseName;
  String leaseNumber;
  String poNumber;
  Map<dynamic, double> chargeMap = Map();

  StationCharge.fromWorkTicket(Sheet workTicket, List<dynamic> row) {
    // pull number from column A and name from column B.
    leaseName = row[1].toString();
    leaseNumber = row[0].toString();
    poNumber = row[2].toString() ?? '';

    // create item map using row 11 as the header and row value as quantity
    //loop until column 12 is empty
    int i = 0;

    while (workTicket.row(10)[i].value != '') {
      //starting with column D, map charges until last item in row 11
      if (row[i].value > 0 && i > 2) {
        if (i < 11) {
          // create service
          chargeMap[Service.fromFirebase(workTicket.row(10)[i].value)] =
              row[i].value;
        } else {
          // create item
          // ignore: unnecessary_statements
          chargeMap[Item.fromFirebase(workTicket.row(10)[i].value)] =
              row[i].value;
        }
      }
      i++;
    }
  }
}
