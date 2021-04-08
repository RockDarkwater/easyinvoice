import 'package:easyinvoice/controllers/ui_controller.dart';
import 'package:easyinvoice/models/job.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvoiceSummary extends StatelessWidget {
  final Job job;
  final UIController uiController = Get.find();

  InvoiceSummary(this.job);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: uiController.invWidth.value,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Summary of Charges'),
          ),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemExtent: 15.0,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: job?.chargeSummary?.length ?? 0,
              itemBuilder: (context, index) {
                return ListTile(
                    onTap: () => {},
                    leading: Text(
                      '${job.chargeSummary.values.toList()[index]}',
                      style: uiController.invoiceTextStyle,
                    ),
                    title: Text(
                      '${job.chargeSummary.keys.toList()[index]}',
                      style: uiController.invoiceTextStyle,
                    ));
              })
        ],
      ),
    );
  }
}
