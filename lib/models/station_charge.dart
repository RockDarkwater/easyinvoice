import 'package:easyinvoice/models/item.dart';
import 'package:easyinvoice/models/service.dart';

class StationCharge {
  String leaseName;
  String leaseNumber;
  String notes;
  Map<Service, double> serviceMap = Map();
  Map<Item, double> itemMap = Map();

  StationCharge(
      {this.leaseNumber,
      this.leaseName,
      this.notes,
      this.serviceMap,
      this.itemMap});
}
