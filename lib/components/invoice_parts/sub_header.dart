import 'package:easyinvoice/components/invoice_parts/customer_address.dart';
import 'package:easyinvoice/models/job.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SubHeader extends StatelessWidget {
  final Job job;

  SubHeader(this.job);

  Widget build(BuildContext context) {
    String invNum = 'HFS90884';
    Size screen = MediaQuery.of(context).size;
    double invWidth = screen.width * 8.5 / 11;

    return Container(
      width: invWidth,
      color: Colors.orange[50],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 28.0),
                    child: CustomerAddress(job.customer),
                  ),
                  Text('Following Are Charges for: Test Calibration/Parts'),
                  Text(''),
                  Text('Work Performed: ${job.jobDate}'),
                ],
              )),
          Expanded(
            flex: 1,
            child: Column(
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
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$invNum'),
                  Text('${DateFormat.yMd().format(DateTime.now())}'),
                  Text('Net 30'),
                  Text('${job.customer.custNum}'),
                  Text('${job.customer.poNum}'),
                  Text('${job.techName}'),
                  Text('${job.location}'),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
