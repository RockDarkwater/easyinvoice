import 'package:easyinvoice/models/station_charge.dart';
import 'package:excel/excel.dart';

class Job {
  String customer;
  String techName;
  String poNumber;
  String requisitioner;
  String location;
  var jobDate;
  List<StationCharge> stationCharges = [];

  Job(this.customer, this.techName, this.jobDate);

  Job.fromWorkTicket(Sheet workTicket) {
    customer = workTicket.cell(CellIndex.indexByString("B2")).value.toString();
    techName = workTicket.cell(CellIndex.indexByString("B4")).value.toString();
    jobDate = workTicket.cell(CellIndex.indexByString("B3")).value;
    poNumber = workTicket.cell(CellIndex.indexByString("K3")).value.toString();
    requisitioner =
        workTicket.cell(CellIndex.indexByString("K2")).value.toString();
    location = workTicket.cell(CellIndex.indexByString("K4")).value.toString();

    int i = 11;
    //create list of station charges
    while (workTicket.row(i)[0].value != null &&
        workTicket.row(i)[1].value != null &&
        workTicket.row(i)[0].value.toString().trim() != '' &&
        workTicket.row(i)[1].value.toString().trim() != '') {
      // create station charge with each row
      print('building row $i...');
      stationCharges
          .add(StationCharge.fromWorkTicket(workTicket, workTicket.row(i)));
      i++;
    }
  }

  // Job.fromAmis(List<dynamic> row);

  // Job.fromAccugas(List<dynamic> row);
}
