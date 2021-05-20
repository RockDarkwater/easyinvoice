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
            child: Stack(children: [
              Padding(
                padding: const EdgeInsets.only(top: 37.5),
                child: Column(
                    children: List<Widget>.generate(
                        job.stationCharges.length,
                        (index) => Container(
                            height: 30,
                            color: (index % 2 == 0)
                                ? Colors.black12
                                : Colors.white))),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 2.0),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: chargeBody(),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  List<Widget> chargeBody() {
    List<Widget> body = [];
    List<String> headers = job.headerRow();
    String headerName;
    List<Widget> list;
    TextStyle style = TextStyle(
      fontSize: 12,
    );
    Column column;

    headers.forEach((header) {
      list = [];
      (header.indexOf(' ') > 0 && header != 'Cost Center')
          ? headerName = header.substring(0, header.indexOf(' '))
          : headerName = header;
      list.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('$headerName'),
      ));
      job.stationCharges.forEach((charge) {
        switch ('$header') {
          case 'Parts':
            list.add(Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${formatCurrency.format(charge.partCost())}',
                style: style,
              ),
            ));
            break;
          case 'Tax':
            list.add(Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${formatCurrency.format(charge.taxableAmount(job?.customer?.taxRate ?? 8.25))}',
                style: style,
              ),
            ));
            break;
          case 'Total':
            list.add(Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${formatCurrency.format(charge.totalCharge() + (charge.taxableAmount(job?.customer?.taxRate ?? 8.25)))}',
                style: style,
              ),
            ));
            break;
          case 'Cost Center':
            list.add(Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '',
                style: style,
              ),
            ));
            break;
          case 'Name':
            list.add(Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${charge.toJson()['meterName'] ?? ''}',
                style: style,
              ),
            ));
            break;
          case 'Number':
            list.add(Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${charge.toJson()['meterNumber'] ?? ''}',
                style: style,
              ),
            ));
            break;
          case 'Date':
            list.add(Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${DateFormat.yMd().format(charge.toJson()['jobDate']) ?? ''}',
                style: style,
              ),
            ));
            break;
          default: // services
            list.add(Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${formatCurrency.format(charge.serviceCost(header))}',
                style: style,
              ),
            ));
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
