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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: uiController.invView.stream,
      builder: (cont, _) {
        if (uiController.invView.value) {
          return Obx(() => Invoice(uiController.currentJob.value));
        } else {
          return StreamBuilder(
            stream: controller.jobs.stream,
            builder: (context, _) {
              return Stack(
                children: [
                  Container(
                    child: GestureDetector(
                      onTap: () {
                        print('Tapped on Upload');
                        if (controller.jobs.length > 0) {
                          Get.to(() => UploadScreen(),
                              transition: Transition.noTransition);
                        }
                      },
                    ),
                  ),
                  Center(
                    child: Container(
                      width: uiController.invWidth.value,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: Container()),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              "Customers Ready To Invoice",
                              style: uiController.invoiceHeaderTextStyle,
                            ),
                          ),
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
                                  onTap: () {
                                    // print(
                                    //     '${controller.jobs[index].toJSONString()}');
                                    uiController.currentJob.value =
                                        controller.jobs[index];
                                    uiController.invView.value = true;
                                  },
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
                                    },
                                    child: Icon(Icons.remove),
                                  ),
                                );
                              },
                            ),
                          ),
                          Expanded(child: Container()),
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
