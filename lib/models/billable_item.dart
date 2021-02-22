import 'item.dart';

class BillableItem {
  final String customer;
  final String leaseNumber;
  final String leaseName;
  final String techName;
  final double quantity;
  final DateTime jobDate;
  final Item item;

  String poNumber;
  String requisitioner;
  String location;

  BillableItem(this.customer, this.leaseNumber, this.leaseName, this.techName,
      this.jobDate, this.quantity, this.item);
}
