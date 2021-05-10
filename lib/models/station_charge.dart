import 'dart:math';

import 'package:easyinvoice/models/item.dart';
import 'package:easyinvoice/models/service.dart';
import 'package:flutter/material.dart';

class StationCharge {
  UniqueKey key = UniqueKey();
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
    key ??= UniqueKey();
    this.billingFieldName ??= '$billingField';
  }
  StationCharge.fromJson(Map<String, dynamic> json)
      : key = json['key'],
        leaseNumber = json['leaseNumber'],
        leaseName = json['leaseName'],
        jobDate = json['jobDate'],
        notes = json['notes'],
        billingField = json['billingField'],
        billingFieldName = json['billingFieldName'],
        serviceMap = Map.fromIterable(json['serviceMap'],
            key: (key) => Service.fromJson(key),
            value: (value) => double.tryParse(value)),
        itemMap = Map.fromIterable(json['itemMap'],
            key: (key) => Item.fromJson(key),
            value: (value) => double.tryParse(value)),
        stationPricing = Map.fromIterable(json['stationPricing'],
            value: (value) => double.tryParse(value));

  Map<String, dynamic> toJson() => {
        'key': key,
        'leaseName': leaseName,
        'leaseNumber': leaseNumber,
        'jobDate': jobDate,
        'notes': notes,
        'billingField': billingField,
        'billingFieldName': billingFieldName,
        'serviceMap':
            Map.fromIterable(serviceMap.entries, key: (key) => key.toJson()),
        'itemMap':
            Map.fromIterable(itemMap.entries, key: (key) => key.toJson()),
        'stationPricing': stationPricing,
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
