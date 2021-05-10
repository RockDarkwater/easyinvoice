import 'dart:convert';
import 'dart:math';

import 'package:easyinvoice/models/customer.dart';
import 'package:easyinvoice/models/item.dart';
import 'package:easyinvoice/models/service.dart';
import 'package:easyinvoice/models/station_charge.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Job {
  final UniqueKey key = UniqueKey();
  Customer customer;
  String techName;
  String poNumber;
  String requisitioner;
  String location;
  List<StationCharge> stationCharges = [];
  Map<dynamic, double> chargeSummary = Map();

  Job(
      {this.customer,
      this.techName,
      this.poNumber,
      this.requisitioner,
      this.location,
      this.stationCharges,
      this.chargeSummary});

  Job.fromJson(Map<String, dynamic> json) {
    customer = Customer.fromJson(json['customer']);
    techName = json['techName'];
    poNumber = json['poNumber'];
    requisitioner = json['requisitioner'];
    location = json['location'];
    stationCharges = jsonDecode(json['stationCharges']);
    chargeSummary.addAll(
      Map.fromIterable(json['chargeSummary'],
          key: (key) => {
                (key.contains('isItem:true'))
                    ? Item.fromJson(key)
                    : Service.fromJson(key)
              },
          value: (value) => double.tryParse(value)),
    );
  }
  Map<String, dynamic> toJson() => {
        'key': key,
        'customer': customer.toJson(),
        'techName': techName,
        'poNumber': poNumber,
        'requisitioner': requisitioner,
        'location': location,
        'stationCharges': jsonEncode(stationCharges),
        'chargeSummary':
            Map.fromIterable(chargeSummary.entries, key: (key) => key.toJson()),
      };

  String dateSpan() {
    DateTime minDate = DateTime(3500, 1, 1);
    DateTime maxDate = DateTime(1900, 1, 1);

    stationCharges.forEach((charge) {
      if (charge.jobDate.isBefore(minDate)) minDate = charge.jobDate;
      if (charge.jobDate.isAfter(maxDate)) maxDate = charge.jobDate;
    });

    if (minDate != maxDate) {
      return '${DateFormat.yMd().format(minDate)} - ${DateFormat.yMd().format(maxDate)}';
    } else {
      return '${DateFormat.yMd().format(maxDate)}';
    }
  }

  List<String> headerRow() {
    List<String> list = [];
    list.add('Number');
    list.add('Name');
    list.add('Date');

    chargeSummary.forEach((key, value) {
      if (!key.isItem && !list.contains(key.name)) {
        list.add('${key.name}');
      }
    });
    if (stationCharges
            .where((charge) => charge.itemMap.length > 0)
            .toList()
            .length >
        0) list.add('Parts');
    if (jobTaxTotal() > 0) list.add('Tax');
    list.add('Total');
    list.add('Cost Center');
    return list;
  }

  double lineTax(dynamic lineItem) {
    double tax = 0;

    stationCharges.forEach((charge) {
      charge.itemMap.forEach((key, value) {
        if (key.name == lineItem.name)
          tax += roundTo(key.price * value * customer.taxRate / 100, 2);
      });
      charge.serviceMap.forEach((key, value) {
        if (key.name == lineItem.name) {
          if (key?.taxable ?? false)
            tax += roundTo(key.price * value * customer.taxRate / 100, 2);
        }
      });
    });
    return tax;
  }

  priceServices() {
    if (customer != null) {
      stationCharges.forEach((charge) {
        charge.serviceMap.forEach((key, value) {
          //calc tax if station has items
          if (charge.itemMap.length > 0) {
            if (key.serviceCode.toLowerCase() == 'calibration' ||
                key.serviceCode.toLowerCase() == 'techtime' ||
                key.serviceCode.toLowerCase() == 'witness') {
              key.taxable = true;
            }
          }
          key.price = customer.priceMap[key.serviceCode.toLowerCase()];
        });
      });
    }
  }

  double jobTaxTotal() {
    double tax = 0;
    stationCharges.forEach((charge) {
      charge.itemMap.forEach((key, value) {
        tax += roundTo(key.price * value * customer.taxRate / 100, 2);
      });
      charge.serviceMap.forEach((key, value) {
        if (key?.taxable ?? false) {
          tax += roundTo(key.price * value * customer.taxRate / 100, 2);
        }
      });
    });
    return tax;
  }

  double jobTotal() {
    double price = 0;
    chargeSummary.forEach((key, value) {
      price += key.price * value;
    });
    return roundTo(price, 2);
  }

  String jobSummary() {
    String string = '';

    if (stationCharges
            .where((charge) =>
                charge.serviceMap.keys
                    .where((service) => service.category == "Field Work")
                    .length >
                0)
            .length >
        0) string = '$string/Field Work';

    if (stationCharges
            .where((charge) =>
                charge.serviceMap.keys
                    .where((service) => service.category == "Analysis")
                    .length >
                0)
            .length >
        0) string = '$string/Analysis';

    if (stationCharges
            .where((charge) =>
                charge.serviceMap.keys
                    .where((service) => service.category == "Volumes")
                    .length >
                0)
            .length >
        0) string = '$string/Volumes';

    if (stationCharges.where((charge) => charge.itemMap.length > 0).length > 0)
      string = '$string/Resale';

    return string.substring(1);
  }

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
    // print('services + items: $counter');
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

  double roundTo(double value, int decimalPlaces) {
    return (value * pow(10, decimalPlaces)).round() / pow(10, decimalPlaces);
  }
}
