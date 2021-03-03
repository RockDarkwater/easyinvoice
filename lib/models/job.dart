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
    // pull job specific variables
    customer = workTicket.cell(CellIndex.indexByString("B2")).value.toString();
    techName = workTicket.cell(CellIndex.indexByString("B4")).value.toString();
    jobDate = workTicket.cell(CellIndex.indexByString("B3")).value;
    poNumber = workTicket.cell(CellIndex.indexByString("K3")).value.toString();
    requisitioner =
        workTicket.cell(CellIndex.indexByString("K2")).value.toString();
    location = workTicket.cell(CellIndex.indexByString("K4")).value.toString();

    int i = 11;
    // create list of station charges
    while (workTicket.row(i)[1].value != null &&
        workTicket.row(i)[1].value.toString().trim() != '') {
      // create station charge with each row
      stationCharges
          .add(StationCharge.fromWorkTicket(workTicket, workTicket.row(i)));
      i++;
    }
  }

  Job.fromAccugas(Sheet workTicket, String customerNumber) {
    int i = 1;
    String testVal = workTicket
        .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: i))
        .value
        .toString();

    while (testVal != 'null' || testVal != '') {
      // on first row, populate job variables
      if (workTicket.rows[i].asMap()[2].toString() == customerNumber) {
        // TODO: customer, requisitioner, po number, location set by customer object
        techName ??
            workTicket
                .cell(CellIndex.indexByString("BA" + i.toString()))
                .value
                .toString();
        jobDate ??
            workTicket.cell(CellIndex.indexByString("I" + i.toString())).value;
        stationCharges.add(StationCharge.fromAccuGas(workTicket.rows[i]));
      }

      // add each row where column C matches customer number as station charge
      i++;
      //check for end of file
      testVal = workTicket
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: i))
          .value
          .toString();
    }
  }

  // Job.fromAmis(Sheet workTicket){
  // pull job specific variables
  // create list of station charges
  // create station charge with each row
  // }
}
