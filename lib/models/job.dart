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

  double countCharges() {
    double counter = 0;
    print('counting...');
    for (var charge in stationCharges) {
      print('counting ${charge.leaseName}');
      if (charge.itemMap != null) {
        for (var item in charge.itemMap.keys) {
          counter += charge.itemMap[item].toDouble();
        }
      }
      print('items: $counter');
      if (charge.serviceMap != null) {
        for (var service in charge.serviceMap.keys) {
          counter += charge.serviceMap[service].toDouble();
        }
      }
      print('services + items: $counter');
    }
    return counter;
  }
}
