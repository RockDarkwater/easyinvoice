import 'package:excel/excel.dart';

class ImportBatch {
  List<Sheet> spreadsheets;
  Map<String, List<List<String>>> txtDocs = Map();

  ImportBatch({this.spreadsheets, this.txtDocs});
}
