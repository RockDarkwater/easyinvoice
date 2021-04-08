import 'package:easyinvoice/components/invoice_parts/customer_address.dart';
import 'package:easyinvoice/controllers/ui_controller.dart';
import 'package:easyinvoice/models/job.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SubHeader extends StatelessWidget {
  final Job job;
  final UIController uiController = Get.find();

  SubHeader(this.job);

  Widget build(BuildContext context) {
    String invNum = 'HFS90884';

    return Container(
      width: uiController.invWidth.value,
      color: Colors.orange[50],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.all(uiController.invWidth.value * 3 / 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: uiController.invWidth.value * 5 / 100),
                      child: CustomerAddress(job.customer),
                    ),
                    Text('Following Are Charges for: ${job.jobSummary()}'),
                    Text(''),
                    Text(
                        'Work Performed: ${DateFormat.yMd().format(job.jobDate)}'),
                  ],
                ),
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Invoice Number:'),
              Text('Date:'),
              Text('Terms:'),
              Text('HMCO Code:'),
              Text('PO#:'),
              Text('Tech Name:'),
              Text('Location:'),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
                left: uiController.invWidth.value * 7 / 100,
                right: uiController.invWidth.value * 3 / 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$invNum'),
                Text('${DateFormat.yMd().format(DateTime.now())}'),
                Text('Net 30'),
                Text('${job.customer.custNum ?? ''}'),
                Text('${job.poNumber ?? job.customer.poNum ?? ''}'),
                Text('${job.techName ?? ''}'),
                Text('${job.location ?? ''}'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
