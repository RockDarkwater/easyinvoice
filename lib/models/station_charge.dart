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
    leaseName = row[1].value.toString();
    leaseNumber = row[0].value.toString();
    poNumber = row[2].value.toString() ?? '';

    print('$leaseNumber - $leaseName: type: $poNumber');

    // create item map using row 11 as the header and row value as quantity
    //loop until column 12 is empty
    int i = 0;
    double qty = 0.0;

    while (workTicket.row(10)[i].value.toString() != '') {
      //starting with column D, map charges until last item in row 11
      if (i > 2) {
        print(row[i].value.toString());
        if (i < 11 && row[i].value != null) {
          // create service
          try {
            if (row[i].cellType == CellType.Formula) {
              print('sum: ${row[i].sum}');
            } else {
              qty = double.parse(row[i].value.toString());
            }

            if (row[i].cellType == CellType.Formula)
              chargeMap[Service.fromFirebase(workTicket.row(10)[i].value)] =
                  qty;
          } catch (err) {
            print('couldn\'t build service ${workTicket.row(10)[i].value}');
          }
        } else if (row[i].value != null) {
          // create item
          try {
            qty = double.parse(row[i].value.toString());

            chargeMap[Item.fromFirebase(workTicket.row(10)[i].value)] = qty;
          } catch (err) {
            print('couldn\'t build item ${workTicket.row(10)[i].value}');
          }
        }

        print('total charges: ${chargeMap.keys.length}');
      }
      i++;
    }
  }
}
