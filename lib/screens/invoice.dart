import 'package:easyinvoice/components/invoice_parts/header.dart';
import 'package:easyinvoice/controllers/import_controller.dart';
import 'package:easyinvoice/models/job.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Invoice extends StatelessWidget {
  final ImportController controller = Get.find();
  final Job job;

  Invoice(this.job);

  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: InvoiceHeader(job),
      content: Container(
        height: 350,
        width: 750,
        child: ListView.builder(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: job.stationCharges.length,
            itemBuilder: (context, index) {
              return ListTile(
                  title: Text(
                      'Station ${job.stationCharges[index].leaseName} - services:'),
                  subtitle: ListView.builder(
                      itemCount: job.stationCharges[index].serviceMap.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, ind) {
                        return ListTile(
                            title: Text(
                                '${job.stationCharges[index].serviceMap.keys.toList()[ind].name} - ' +
                                    '${job.stationCharges[index].serviceMap[job.stationCharges[index].serviceMap.keys.toList()[ind]]}'));
                      }));
            }),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: Icon(Icons.arrow_left))
      ],
    );
  }
}
