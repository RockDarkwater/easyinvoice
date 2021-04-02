import 'package:easyinvoice/models/item.dart';
import 'package:easyinvoice/models/service.dart';

import 'customer.dart';

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

  priceStation(Customer customer) {
    serviceMap.forEach((key, value) {
      stationPricing[key.serviceCode] =
          customer.priceMap[key.serviceCode] * value;
    });

    itemMap.forEach((key, value) {
      stationPricing[key.itemCode] = key.price * value;
    });
  }
}
