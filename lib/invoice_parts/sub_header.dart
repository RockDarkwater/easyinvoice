import 'package:easyinvoice/controllers/ui_controller.dart';
import 'package:easyinvoice/models/job.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'customer_address.dart';

class SubHeader extends StatelessWidget {
  final Job job;
  final UIController uiController = Get.find();

  SubHeader(this.job);

  Widget build(BuildContext context) {
    String invNum = 'HFS90884';

    return Container(
      width: uiController.invWidth.value,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.only(
                    left: uiController.invWidth.value * 3 / 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: uiController.invWidth.value * 2 / 100),
                      child: CustomerAddress(job.customer),
                    ),
                    Text('Following Are Charges for: ${job.jobSummary()}'),
                    Text(''),
                    Text('Work Performed: ${job.dateSpan()}'),
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
              Text(''),
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
                  ] +
                  textValues(job),
            ),
          )
        ],
      ),
    );
  }

  List<Text> textValues(Job job) {
    List<Text> list = [];
    list.add(Text('${DateFormat.yMd().format(DateTime.now())}'));
    list.add(Text('Net 30'));
    list.add(Text('${job.customer.custNum}'));

    if (job.poNumber == 'null') {
      (job.customer.poNum == 'null') ? Text('') : Text('${job.customer.poNum}');
    } else {
      list.add(Text('${job.poNumber}'));
    }

    list.add(Text(''));

    (job.techName == 'null') ? list.add(Text('')) : Text('${job.techName}');

    (job.location == 'null') ? list.add(Text('')) : Text('${job.location}');

    return list;
  }
}
