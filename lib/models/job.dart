import 'package:excel/excel.dart';

class Job {
  final String customer;
  final String techName;
  final DateTime jobDate;

  String poNumber;
  String requisitioner;
  String location;

  Job(this.customer, this.techName, this.jobDate);

  // Job.fromWorkTicket(Excel excel){
  //   excel.sheets[0].rows.first;
  // };

  // Job.fromAmis(List<dynamic> row);

  // Job.fromAccugas(List<dynamic> row);
}
