import 'package:flutter/material.dart';

class Item {
  final UniqueKey key = UniqueKey();
  final bool isItem = true;
  final String itemCode;
  final String name;
  final double price;
  final double cost;
  final bool taxable = true;

  Item({this.itemCode, this.name, this.price, this.cost});

  Item.fromJson(Map<String, dynamic> json)
      : itemCode = json['itemCode'],
        name = json['name'],
        price = json['price'],
        cost = json['cost'];

  Map<String, dynamic> toJSON() => {
        'price': price,
        'cost': cost,
        'itemCode': itemCode,
        'name': name,
        'taxable': taxable,
      };
}
