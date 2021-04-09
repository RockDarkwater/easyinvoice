import 'package:easyinvoice/controllers/ui_controller.dart';
import 'package:easyinvoice/models/job.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StationCharges extends StatelessWidget {
  final Job job;
  final UIController uiController = Get.find();
  final formatCurrency = NumberFormat.simpleCurrency();

  StationCharges(this.job);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: uiController.invWidth.value,
      child: Column(
        children: [
          Container(
            color: Colors.black26,
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: headerRow(job),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> headerRow(Job job) {
    List<Widget> headers = [];
    TextStyle headerStyle = TextStyle(fontSize: 10);
    headers.add(Text(
      'Lease Number',
      style: headerStyle,
    ));
    headers.add(Text(
      'Lease Name',
      style: headerStyle,
    ));
    headers.add(Text(
      'Job Date',
      style: headerStyle,
    ));
    job.chargeSummary.forEach((key, value) {
      if (!key.isItem)
        headers.add(Text(
          '${key.name}',
          style: headerStyle,
        ));
    });
    headers.add(Text(
      'Parts',
      style: headerStyle,
    ));
    headers.add(Text(
      'Sales Tax',
      style: headerStyle,
    ));
    headers.add(Text(
      'Total',
      style: headerStyle,
    ));
    headers.add(Text(
      'Cost Center',
      style: headerStyle,
    ));
    return headers;
  }
}
