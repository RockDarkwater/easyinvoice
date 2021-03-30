import 'package:easyinvoice/controllers/import_controller.dart';
import 'package:easyinvoice/screens/invoice.dart';
import 'package:easyinvoice/test/test_objects.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OverviewScreen extends StatelessWidget {
  final ImportController controller = Get.find();
  final formatCurrency = NumberFormat.simpleCurrency();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EasyInvoice v0.0.1'),
      ),
      body: FutureBuilder(
          future: testJob(), //controller.import(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              controller.importQty.value = 1;
              controller.currentImport.value = 0;
              controller.currentProcess.value = 0;
              controller.processQty.value = 1;

              return Center(
                child: Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width / 3,
                  color: Colors.orange[50],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                'Loading ...',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.deepOrange, fontSize: 42),
                              ),
                            ),
                            Obx(() => Text(
                                  '${controller.resultNames[controller.currentImport.value]}',
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  style: TextStyle(
                                      color: Colors.deepOrange, fontSize: 14),
                                )),
                          ],
                        ),
                      ),
                      Stack(alignment: Alignment.center, children: [
                        Obx(() => LinearProgressIndicator(
                              minHeight: 25,
                              value: (controller.currentProcess.value /
                                  controller.processQty.value),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.deepOrange),
                              backgroundColor: Colors.orange,
                            )),
                        Obx(() => Text(
                              'Stations: ${controller.currentProcess.value} / ${controller.processQty.value}',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                              textAlign: TextAlign.center,
                            )),
                      ]),
                      SizedBox(
                        height: 5,
                        width: 200,
                      ),
                      Stack(alignment: Alignment.center, children: [
                        Obx(() => LinearProgressIndicator(
                              minHeight: 25,
                              value: (controller.currentImport.value /
                                  controller.importQty.value),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.deepOrange),
                              backgroundColor: Colors.orange,
                            )),
                        Obx(() => Text(
                              'Imports: ${controller.currentImport.value} / ${controller.importQty.value}',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                              textAlign: TextAlign.center,
                            )),
                      ]),
                    ],
                  ),
                ),
              );
            } else {
              return StreamBuilder(
                stream: controller.jobs.stream,
                builder: (context, _) => Padding(
                  padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: ListView.builder(
                            itemCount: controller.jobs.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Obx(() => Text(
                                    'C - ${controller.jobs[index].customer.custNum}: ' +
                                        '${controller.jobs[index].customer.billingName} - ' +
                                        '${controller.jobs[index].countCharges()} items charged, Total: ' +
                                        '${formatCurrency.format(controller.jobs[index].priceJob())}')),
                                onTap: () async => await Get.dialog(
                                    Invoice(controller.jobs[index])),
                                focusColor: Colors.white54,
                                leading: TextButton(
                                  onPressed: () {
                                    controller.jobs.removeAt(index);
                                    if (controller.jobs.length == 0) {
                                      Get.back();
                                      controller.currentImport.value = 1;
                                      controller.importQty.value = 1;
                                      controller.processQty.value = 1;
                                      controller.currentProcess.value = 1;
                                      controller.resultNames.clear();
                                      controller.resultNames.add('');
                                    }
                                    ;
                                  },
                                  child: Icon(Icons.remove),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}
