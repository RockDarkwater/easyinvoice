import 'package:easyinvoice/models/import_batch.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ImportController extends GetxController {
  Future<FilePickerResult> pickFiles() async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    return result;
  }

  Future<ImportBatch> import() async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    List<Excel> sheets;
    result.files.forEach((element) {
      sheets.add(Excel.decodeBytes(element.bytes));
    });

    return ImportBatch(sheets);
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
