import 'package:easyinvoice/controllers/import_controller.dart';
import 'package:easyinvoice/models/job.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Invoice extends StatelessWidget {
  final ImportController controller = Get.find();
  final Job job;

  Invoice(this.job);

  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          'Invoice: ${job.customer.billingName} - ${DateFormat.MMMd().format(job.jobDate)}'),
      content: Text('Job is a job.'),
      actions: [
        TextButton(onPressed: () => Get.back(), child: Icon(Icons.arrow_left))
      ],
    );
  }
}
