import 'package:excel/excel.dart';

import 'billable_item.dart';

class BillableItemPacket {
  List<BillableItem> items = [];

  BillableItemPacket(this.items);

  BillableItemPacket.fromAmis(Excel data);

  BillableItemPacket.fromWorkTicket(Excel data);

  BillableItemPacket.fromAccuGas(Excel data) {
    //pull analysis data from Accgas export
    Sheet sheet = data.sheets[data.sheets.keys.first];
    // test that all rows are recognized
    int rows = sheet.maxRows;
    print('total rows in ${sheet.sheetName}: $rows');

    // create a billable item for each
    for (int i = 0; i < rows; i++) {
      String item = sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 14, rowIndex: i))
          .value;
      // Item lineItem = Item.fromFirebase(sampleType(item).toString());

      // if (i > 0) {
      //   items.add(BillableItem(
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
      //       1,
      //       lineItem));
      // }
    }
  }

  int sampleType(String type) {
    bool extended = false;
    bool liquid = false;

    if (type.indexOf('recom') > 0) return 53;
    if (type.indexOf('sulph') > 0) return 54;
    if (type == "flash") return 55;

    if (type == "rvp") return 58;
    if (type.indexOf('api') > 0) return 60;

    if (type.indexOf('train') > 0) return 61;

    if (type.indexOf("ext") > 0) extended = true;
    if (type.indexOf("liq") > 0) liquid = true;

    if (extended && liquid) {
      return 52;
    } else if (!extended && liquid) {
      return 50;
    } else if (extended && !liquid) {
      return 51;
    } else
      return 2;
  }
}
