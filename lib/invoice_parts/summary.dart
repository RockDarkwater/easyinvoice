import 'package:easyinvoice/controllers/ui_controller.dart';
import 'package:easyinvoice/models/job.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InvoiceSummary extends StatelessWidget {
  final Job job;
  final UIController uiController = Get.find();
  final formatCurrency = NumberFormat.simpleCurrency();

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
          Container(
            decoration: BoxDecoration(border: Border.all()),
            child: Column(
              children: [
                Container(
                  color: Colors.black26,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        Expanded(flex: 1, child: Text('Qty')),
                        Expanded(flex: 12, child: Text('Service')),
                        Expanded(flex: 2, child: Text('Price')),
                        Expanded(flex: 2, child: Text('Total')),
                        Expanded(flex: 2, child: Text('Sales Tax')),
                      ],
                    ),
                  ),
                ),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: job?.chargeSummary?.length ?? 0,
                    itemBuilder: (context, index) {
                      return Container(
                        color: (index % 2 != 0) ? Colors.black12 : Colors.white,
                        child: ListTile(
                            dense: true,
                            onTap: () {
                              print('$index');
                            },
                            title: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  // Quantity
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      '${job.chargeSummary.values.toList()[index]}',
                                      style: uiController.invoiceTextStyle,
                                    ),
                                  ),
                                  //Description
                                  Expanded(
                                    flex: 12,
                                    child: Text(
                                      '${job.chargeSummary.keys.toList()[index].name}',
                                      style: uiController.invoiceTextStyle,
                                    ),
                                  ),
                                  //Price
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '${formatCurrency.format(job.chargeSummary.keys.toList()[index].price)}',
                                      style: uiController.invoiceTextStyle,
                                    ),
                                  ),
                                  //Total
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '${formatCurrency.format(job.chargeSummary.keys.toList()[index].price * job.chargeSummary[job.chargeSummary.keys.toList()[index]])}',
                                      style: uiController.invoiceTextStyle,
                                    ),
                                  ),
                                  //Sales Tax
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '(${formatCurrency.format(job.lineTax(job.chargeSummary.keys.toList()[index]))})',
                                      style: uiController.invoiceTextStyle,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      );
                    }),
                Divider(
                  color: Colors.black,
                ),
                Padding(
                  padding: EdgeInsets.only(left: uiController.invWidth / 2),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding:
                          EdgeInsets.only(right: uiController.invWidth / 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Sales Tax:'),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text(
                                '${formatCurrency.format(job.jobTaxTotal())}'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(
                  indent: uiController.invWidth / 1.5,
                  endIndent: uiController.invWidth / 25,
                  color: Colors.black,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: uiController.invWidth / 2, bottom: 8.0),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding:
                            EdgeInsets.only(right: uiController.invWidth / 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Total:'),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(
                                  '${formatCurrency.format(job.jobTotal())}'),
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
