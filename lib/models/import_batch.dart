import 'package:easyinvoice/models/job.dart';
import 'package:excel/excel.dart';

class ImportBatch {
  List<Sheet> spreadsheets;
  Map<int, List<List<String>>> txtDocs = Map();
  List<Job> jobs = [];

  ImportBatch({this.spreadsheets, this.txtDocs});
}
