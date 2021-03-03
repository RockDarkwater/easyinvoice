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

    // create item map using row 11 as the header and row value as quantity
    // loop until column 12 is empty
    int i = 0;
    double qty = 0.0;

    while (workTicket.row(10)[i].value != null &&
        workTicket.row(10)[i].value.toString().trim() != '') {
      //starting with column D, map charges until last item in row 11
      if (i > 2) {
        if (i < 12 && row[i].value != null) {
          // create service
          try {
            qty = double.parse(row[i].value.toString());
            if (qty > 0)
              // map service and quantity
              chargeMap[Service.fromFirebase(workTicket.row(10)[i].value)] =
                  qty;
          } catch (err) {
            print('couldn\'t build service ${workTicket.row(10)[i].value}');
          }
        } else if (row[i].value != null) {
          // create item
          try {
            qty = double.parse(row[i].value.toString());
            if (qty > 0)
              // map item and quantity
              chargeMap[Item.fromFirebase(workTicket.row(10)[i].value)] = qty;
          } catch (err) {
            print('couldn\'t build item ${workTicket.row(10)[i].value}');
          }
        }
      }
      i++;
    }
  }
}
