import 'package:easyinvoice/models/service.dart';
import 'package:excel/excel.dart';

import 'billable.dart';

class BillableItemPacket {
  List<Billable> items = [];

  BillableItemPacket(this.items);

  BillableItemPacket.fromAmis(Excel data);

  BillableItemPacket.fromWorkTicket(Excel data);

  BillableItemPacket.fromAccuGas(Excel data) {
    //pull analysis data from Accgas export
    Sheet sheet = data.sheets[data.sheets.keys.first];
    // test that all rows are recognized
    int rows = sheet.maxRows;
    int counter = 0;
    print('total rows in ${sheet.sheetName}: $rows');

    // create a billable item for each
    for (int i = 0; i < rows; i++) {
      String item = sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 14, rowIndex: i))
          .value;
      Service lineItem = Service.fromFirebase(sampleType(item).toString());

      //TODO: edit to create Job item from ticket and pass it to billable

      // if (i > 0) {
      //   items.add(Billable(
      //       sheet
      //           .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: i))
      //           .value,
      //       sheet
      //           .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: i))
      //           .value,
      //       sheet
      //           .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: i))
      //           .value,
      //       sheet
      //           .cell(CellIndex.indexByColumnRow(columnIndex: 54, rowIndex: i))
      //           .value,
      //       sheet
      //           .cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: i))
      //           .value,

      //       lineItem));
      // }
      counter++;
    }
    print('$counter items created from upload');
  }

  String sampleType(String type) {
    bool extended = false;
    bool liquid = false;

    if (type.indexOf('recom') > 0) return 'recomb';
    if (type.indexOf('sulph') > 0) return 'sulphur';
    if (type == "flash") return 'flash';

    if (type == "rvp") return 'rvpCalc';
    if (type.indexOf('api') > 0) return 'apiGrav';

    if (type.indexOf('train') > 0) return 'training';

    if (type.indexOf("ext") > 0) extended = true;
    if (type.indexOf("liq") > 0) liquid = true;

    if (extended && liquid) {
      return 'extLiquidSample';
    } else if (!extended && liquid) {
      return 'c6LiquidSample';
    } else if (extended && !liquid) {
      return 'extGasSample';
    } else
      return 'c6GasSample';
  }
}
