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
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: DataTable(
            dataRowHeight: 20,
            dividerThickness: 3,
            columns: List.generate(job.headerRow().length, (index) {
              return DataColumn(label: Text('${job.headerRow()[index]}'));
            }),
            rows: buildRows(),
          ),
        ));
  }

  List<DataRow> buildRows() {
    List<DataRow> list = [];
    List<DataCell> rowList = [];
    List<String> headers = job.headerRow();

    TextStyle style = TextStyle();

    job.stationCharges.forEach((charge) {
      rowList = [];
      headers.forEach((header) {
        switch ('$header') {
          case 'Parts':
            rowList.add(
              DataCell(
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    '${formatCurrency.format(charge.partCost())}',
                    style: style,
                  ),
                ),
              ),
            );
            break;
          case 'Tax':
            rowList.add(DataCell(
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  '${formatCurrency.format(charge.taxableAmount(job?.customer?.taxRate ?? 8.25))}',
                  style: style,
                ),
              ),
            ));
            break;
          case 'Total':
            rowList.add(DataCell(Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                '${formatCurrency.format(charge.totalCharge() + (charge.taxableAmount(job?.customer?.taxRate ?? 8.25)))}',
                style: style,
              ),
            )));
            break;
          case 'Cost Center':
            rowList.add(DataCell(Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                '',
                style: style,
              ),
            )));
            break;
          case 'Name':
            rowList.add(DataCell(Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                '${charge.toJson()['meterName'] ?? ''}',
                style: style,
              ),
            )));
            break;
          case 'Number':
            rowList.add(DataCell(Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                '${charge.toJson()['meterNumber'] ?? ''}',
                style: style,
              ),
            )));
            break;
          case 'Date':
            rowList.add(DataCell(Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                '${DateFormat.yMd().format(charge.toJson()['jobDate']) ?? ''}',
                style: style,
              ),
            )));
            break;
          default: // services
            rowList.add(DataCell(Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                '${formatCurrency.format(charge.serviceCost(header))}',
                style: style,
              ),
            )));
        }
      });
      list.add(DataRow(cells: rowList));
    });
    return list;
  }
}
