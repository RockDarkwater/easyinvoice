import 'package:easyinvoice/models/customer.dart';
import 'package:easyinvoice/models/item.dart';
import 'package:easyinvoice/models/service.dart';
import 'package:easyinvoice/models/station_charge.dart';

class Job {
  Customer customer;
  String techName;
  String poNumber;
  String requisitioner;
  String location;
  DateTime jobDate;
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
    for (var charge in stationCharges) {
      if (charge.itemMap != null) {
        for (var item in charge.itemMap.keys) {
          counter += charge.itemMap[item].toDouble();
        }
      }
      if (charge.serviceMap != null) {
        for (var service in charge.serviceMap.keys) {
          counter += charge.serviceMap[service].toDouble();
        }
      }
    }
    print('services + items: $counter');
    return counter;
  }

  double priceJob() {
    double price = 0;
    double calc = 0;
    for (StationCharge charge in stationCharges) {
      if (charge?.itemMap != null && charge?.itemMap?.length != 0) {
        for (Item item in charge.itemMap.keys) {
          calc = item.price * charge?.itemMap[item];
          price += calc;
          // print('Item: \$$calc added to price');
        }
      }

      if (charge?.serviceMap != null && charge?.serviceMap?.length != 0) {
        for (Service service in charge.serviceMap.keys) {
          calc = customer?.priceMap[service.serviceCode.toLowerCase()] *
              charge.serviceMap[service];
          // print('Service: \$$calc added to price');
          price += calc;
        }
      }
    }

    return price;
  }
}
