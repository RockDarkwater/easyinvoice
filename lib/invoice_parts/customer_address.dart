import 'package:easyinvoice/models/customer.dart';
import 'package:flutter/material.dart';

class CustomerAddress extends StatelessWidget {
  final Customer customer;

  CustomerAddress(this.customer);

  @override
  Widget build(BuildContext context) {
    List<Widget> addy = [];
    addy.insert(0, Text('${customer.billingName}'));
    if (customer.add1.trim() != '') addy.add(Text('${customer.add1}'));
    if (customer.add2.trim() != '') addy.add(Text('${customer.add2}'));
    if (customer.add3.trim() != '') addy.add(Text('${customer.add3}'));
    if ('${customer.city}${customer.state}${customer.zip}'.trim().length > 0)
      addy.add(Text('${customer.city}, ${customer.state} ${customer.zip}'));

    while (addy.length < 5) {
      addy.add(Text(''));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: addy,
    );
  }
}
