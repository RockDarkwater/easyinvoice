import 'dart:math';

import 'package:easyinvoice/models/item.dart';
import 'package:easyinvoice/models/service.dart';
import 'package:intl/intl.dart';

class StationCharge {
  String leaseName;
  String leaseNumber;
  DateTime jobDate;
  String notes;
  int billingField = 1;
  String billingFieldName;
  Map<Service, double> serviceMap = Map();
  Map<Item, double> itemMap = Map();
  Map<String, double> stationPricing = Map();

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

  String toJSONString(String path) {
    Map servs = Map();
    Map items = Map();
    int i = 0;
    serviceMap.forEach((key, value) {
      servs['$path.${key.toJSONString("$path.serviceMap.$i")}'] = value;
      i++;
    });
    i = 0;
    itemMap.forEach((key, value) {
      items['$path.${key.toJSONString("$path.itemMap.$i")}'] = value;
      i++;
    });

    Map map = {
      '$path.leaseName': leaseName,
      '$path.leaseNumber': leaseNumber,
      '$path.jobDate': jobDate,
      '$path.notes': notes,
      '$path.serviceMap': servs.toString(),
      '$path.itemMap': items.toString(),
    };

    return map.toString();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map();

    map['Name'] = leaseName;
    (leaseNumber == 'null')
        ? map['Number'] = ''
        : map['Number'] = leaseNumber ?? '';
    map['Date'] = DateFormat.yMd().format(jobDate);
    serviceMap.forEach((key, value) {
      map['${key.name}'] = key.price * value;
    });

    return map;
  }

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
