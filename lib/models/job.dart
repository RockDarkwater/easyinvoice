import 'package:easyinvoice/models/station_charge.dart';

class Job {
  String customer;
  String techName;
  String poNumber;
  String requisitioner;
  String location;
  var jobDate;
  List<StationCharge> stationCharges = [];

  Job(
      {this.customer,
      this.techName,
      this.poNumber,
      this.requisitioner,
      this.location,
      this.jobDate,
      this.stationCharges});
}
