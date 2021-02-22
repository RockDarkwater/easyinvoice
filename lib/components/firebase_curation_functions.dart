import 'dart:io';

import 'package:excel/excel.dart';

void refreshItems() {
  var _filePath = "C:\Anal\HFS Item List.xlsx";
  var _bytes = File(_filePath).readAsBytesSync();
  var _excel = Excel.decodeBytes(_bytes);

  //clear items from firebase
  //add new items
}
