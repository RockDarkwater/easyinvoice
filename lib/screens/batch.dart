import 'package:easyinvoice/controllers/import_controller.dart';
import 'package:easyinvoice/controllers/ui_controller.dart';
import 'package:easyinvoice/screens/upload.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'invoice.dart';

class BatchScreen extends StatelessWidget {
  final ImportController controller = Get.find();
  final UIController uiController = Get.find();
  final formatCurrency = NumberFormat.simpleCurrency();

  void bounceBack() {
    print('Tapped on Upload');
    if (controller.parents.length > 0) {
      Get.offAll(() => UploadScreen(), transition: Transition.noTransition);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: uiController.invView.stream,
      builder: (cont, _) {
        if (uiController.invView.value) {
          return Obx(() => Invoice(uiController.currentJob.value));
        } else {
          return StreamBuilder(
            stream: controller.parents.stream,
            builder: (context, _) {
              return Stack(
                children: [
                  Container(
                    child: GestureDetector(
                      onTap: bounceBack,
                    ),
                  ),
                  Center(
                    child: Container(
                      width: uiController.invWidth.value,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Container(
                            color: Colors.grey[50],
                            child: GestureDetector(
                              onTap: bounceBack,
                            ),
                          )),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              "Customers Ready To Invoice",
                              style: uiController.invoiceHeaderTextStyle,
                            ),
                          ),
                          Flexible(
                            child: ListView.builder(
                              itemCount: controller.parents.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.grey.withOpacity(0.2)),
                                        BoxShadow(
                                            blurRadius: 75,
                                            color:
                                                Colors.grey.withOpacity(0.2)),
                                      ],
                                    ),
                                    child: ListTile(
                                      title: Center(
                                        child: Obx(() => Text(
                                            'C - ${controller.parents.keys.toList()[index]}: ' +
                                                '${controller.parents[controller.parents.keys.toList()[index]]} - ' +
                                                '${controller.countCustCharges(controller.parents.keys.toList()[index])} items charged, Total: ' +
                                                '${formatCurrency.format(controller.priceCustomer(controller.parents.keys.toList()[index]))}')),
                                      ),
                                      onTap: () {
                                        //set current jobs to all jobs with the clicked parent.
                                        uiController.currentJobs.assignAll(
                                            controller.jobs.where((job) =>
                                                job.customer.parentCustomer.keys
                                                    .first ==
                                                controller.parents.keys
                                                    .toList()[index]));
                                        //submit first job to invoice
                                        uiController.currentJob.value =
                                            uiController.currentJobs.first;
                                        //set invoice view to true to rebuild view
                                        uiController.invView.value = true;
                                      },
                                      tileColor: Colors.grey[200],
                                      focusColor: Colors.grey,
                                      hoverColor: Colors.white,
                                      leading: TextButton(
                                        onPressed: () {
                                          controller.jobs.removeWhere((job) =>
                                              job.customer.parentCustomer.keys
                                                  .first ==
                                              controller.parents.keys
                                                  .toList()[index]);

                                          if (controller.jobs.length == 0) {
                                            Get.back();
                                            controller.currentImport.value = 1;
                                            controller.importQty.value = 1;
                                            controller.processQty.value = 1;
                                            controller.currentProcess.value = 1;
                                            controller.resultNames.clear();
                                            controller.resultNames.add('');
                                            controller.parents.clear();
                                          } else {
                                            controller.compileParents();
                                          }
                                        },
                                        child: Icon(Icons.remove),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Expanded(
                              child: Container(
                            color: Colors.grey[50],
                            child: GestureDetector(
                              onTap: bounceBack,
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}
