import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

import 'job.dart';

class ImportBatch {
  List<Job> jobs = [];

  ImportBatch(FilePickerResult result) {
    for (PlatformFile file in result.files) {
      var _excel = Excel.decodeBytes(file.bytes);
      var _itemSheet = _excel.sheets[_excel.sheets.keys.first];
      if (_itemSheet
              .cell(CellIndex.indexByString("A2"))
              .value
              .toString()
              .toLowerCase() ==
          'index') {
        // import AccuGas
        // loop through all the rows of the sheet, creating a job for each customer number

      } else if (_itemSheet
              .cell(CellIndex.indexByString("A11"))
              .value
              .toString()
              .toLowerCase() ==
          'station #') {
        //import Work Ticket
        jobs.add(Job.fromWorkTicket(_itemSheet));
      } else if (_itemSheet
              .cell(CellIndex.indexByString("C1"))
              .value
              .toString()
              .toLowerCase() ==
          'fld') {
        //import Amis
      } else {
        print('Unrecognized import');
      }
    }
  }
}
