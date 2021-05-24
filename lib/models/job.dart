import 'dart:math';

import 'package:easyinvoice/models/customer.dart';
import 'package:easyinvoice/models/item.dart';
import 'package:easyinvoice/models/service.dart';
import 'package:easyinvoice/models/station_charge.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Job {
  UniqueKey key = UniqueKey();
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

  Job.fromJson(Map<String, dynamic> json)
      : key = json['key'],
        customer = Customer.fromJson(json['customer']),
        techName = json['techName'],
        poNumber = json['poNumber'],
        requisitioner = json['requisitioner'],
        location = json['location'],
        stationCharges = List.generate(List.from(json['stationCharges']).length,
            (index) => StationCharge.fromJson((json['stationCharges'][index]))),
        chargeSummary = Map.fromIterables(
            List.generate(Map.from(json['chargeSummary']).length, (ind) {
              var thing = Map.from(json['chargeSummary']).keys.toList()[ind];
              // print(thing.toString());
              if (thing.toString().indexOf("isItem: false") > -1) {
                //parse service
                return Service.fromJson(thing);
              } else {
                //parse item
                return Item.fromJson(thing);
              }
            }),
            List.from(Map.from(json['chargeSummary']).values));

  Map<String, dynamic> toJson() => {
        'key': key,
        'customer': customer.toJson(),
        'techName': techName,
        'poNumber': poNumber,
        'requisitioner': requisitioner,
        'location': location,
        'stationCharges': List.generate(
            stationCharges.length, (index) => stationCharges[index].toJson()),
        'chargeSummary': Map.fromIterables(
            List.generate(chargeSummary.keys.length,
                (index) => chargeSummary.keys.toList()[index].toJson()),
            chargeSummary.values),
      };

  String dateSpan() {
    DateTime minDate = DateTime(2050, 1, 1);
    DateTime maxDate = DateTime(2000, 1, 1);

    stationCharges.forEach((charge) {
      try {
        if (charge.jobDate.isBefore(minDate)) minDate = charge.jobDate;
        if (charge.jobDate.isAfter(maxDate)) maxDate = charge.jobDate;
      } catch (err) {
        //same date
      }
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

  summarize() {
    chargeSummary.clear();

    stationCharges.forEach((station) {
      station.serviceMap.forEach((key, value) {
        (chargeSummary.keys.firstWhere((element) => element.name == key.name,
                    orElse: () => null) !=
                null)
            ? chargeSummary[chargeSummary.keys
                .firstWhere((element) => element.name == key.name)] += value
            : chargeSummary[key] = value;
      });
    });
    stationCharges.forEach((station) {
      station.itemMap.forEach((key, value) {
        (chargeSummary.keys.firstWhere((element) => element.name == key.name,
                    orElse: () => null) !=
                null)
            ? chargeSummary[chargeSummary.keys
                .firstWhere((element) => element.name == key.name)] += value
            : chargeSummary[key] = value;
      });
    });
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

    stationCharges.forEach((station) {
      station.serviceMap.keys.forEach((service) {
        if (service.category == "Field Work" && !string.contains('/Field Work'))
          string = '$string/Field Work';
        if (service.category == "Analysis" && !string.contains('/Analysis'))
          string = '$string/Analysis';
        if (service.category == "Volumes" && !string.contains('/Volumes'))
          string = '$string/Volumes';
      });

      if (station.itemMap.length > 0 && !string.contains('/Resale'))
        string = '$string/Resale';
    });

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
