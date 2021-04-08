import 'package:easyinvoice/models/item.dart';
import 'package:easyinvoice/models/service.dart';

class StationCharge {
  String leaseName;
  String leaseNumber;
  String notes;
  Map<Service, double> serviceMap = Map();
  Map<Item, double> itemMap = Map();
  Map<String, double> stationPricing = Map();

  StationCharge(
      {this.leaseNumber,
      this.leaseName,
      this.notes,
      this.serviceMap,
      this.itemMap});

  double taxableAmount() {
    double taxable = 0;
    itemMap.forEach((key, value) {
      if (key.taxable) taxable += (value * key.price);
    });

    serviceMap.forEach((key, value) {
      if (key.taxable) taxable += (value * key.price);
    });
    return taxable;
  }
}
