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
                children: chargeBody(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> chargeBody() {
    List<Widget> body = [];
    List<String> headers = job.headerRow();
    List<Widget> list;
    Column column;

    headers.forEach((header) {
      list = [];
      list.add(Text('$header'));

      job.stationCharges.forEach((charge) {
        switch ('$header') {
          case 'Parts':
            list.add(Text('${charge.partCost()}'));
            break;
          case 'Tax':
            list.add(Text(
                '${charge.taxableAmount(job?.customer?.taxRate ?? 8.25)}'));
            break;
          case 'Total':
            list.add(Text(
                '${charge.totalCharge() + (charge.taxableAmount(job?.customer?.taxRate ?? 8.25))}'));
            break;
          case 'Cost Center':
            list.add(Text(''));
            break;
          default:
            list.add(Text('${charge.toJson()[header] ?? ''}'));
        }
      });

      column = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list,
      );
      body.add(column);
    });
    return body;
  }
}
