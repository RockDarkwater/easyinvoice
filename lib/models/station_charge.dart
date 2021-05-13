import 'dart:math';

import 'package:easyinvoice/models/item.dart';
import 'package:easyinvoice/models/service.dart';

class StationCharge {
  String leaseName;
  String leaseNumber;
  DateTime jobDate;
  String notes;
  int billingField = 1;
  String billingFieldName;
  Map<Service, double> serviceMap = Map();
  Map<Item, double> itemMap = Map();

  StationCharge(
      {this.leaseNumber,
      this.leaseName,
      this.jobDate,
      this.notes,
      this.billingField,
      this.billingFieldName,
      this.serviceMap,
      this.itemMap}) {
    this.billingFieldName ??= '$billingField';
  }
  StationCharge.fromJson(Map<String, dynamic> json)
      : leaseNumber = json['leaseNumber'],
        leaseName = json['leaseName'],
        jobDate = json['jobDate'],
        notes = json['notes'],
        billingField = json['billingField'],
        billingFieldName = json['billingFieldName'],
        serviceMap = Map.fromIterables(
            List.generate(
                Map.from(json['serviceMap']).length,
                (index) => Service.fromJson(
                    Map.from(json['serviceMap']).keys.toList()[index])),
            List.from(Map.from(json['serviceMap']).values)),
        itemMap = Map.fromIterables(
            List.generate(
                Map.from(json['itemMap']).length,
                (index) => Item.fromJson(
                    Map.from(json['itemMap']).keys.toList()[index])),
            List.from(Map.from(json['itemMap']).values));

  Map<String, dynamic> toJson() => {
        'leaseName': leaseName,
        'leaseNumber': leaseNumber,
        'jobDate': jobDate,
        'notes': notes,
        'billingField': billingField,
        'billingFieldName': billingFieldName,
        'serviceMap': Map.fromIterables(
            List.generate(serviceMap.length,
                (index) => serviceMap.keys.toList()[index].toJson()),
            List.from(serviceMap.values)),
        'itemMap': Map.fromIterables(
            List.generate(itemMap.length,
                (index) => itemMap.keys.toList()[index].toJson()),
            List.from(itemMap.values)),
      };

  double partCost() {
    double cost = 0;
    itemMap.forEach((key, value) {
      cost += key.price * value;
    });
    return cost;
  }

  double taxableAmount(double taxRate) {
    double taxable = 0;
    itemMap.forEach((key, value) {
      if (key?.taxable ?? false) taxable += (value * key.price);
    });

    serviceMap.forEach((key, value) {
      if (key?.taxable ?? false) taxable += (value * key.price);
    });
    return roundTo(taxable * taxRate / 100, 2);
  }

  double totalCharge() {
    double total = 0;
    itemMap.forEach((key, value) {
      total += key.price * value;
    });

    serviceMap.forEach((key, value) {
      total += value * key.price;
    });
    return roundTo(total, 2);
  }

  double roundTo(double value, int decimalPlaces) {
    return (value * pow(10, decimalPlaces)).round() / pow(10, decimalPlaces);
  }
}
