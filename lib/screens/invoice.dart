import 'package:easyinvoice/controllers/import_controller.dart';
import 'package:easyinvoice/controllers/ui_controller.dart';
import 'package:easyinvoice/invoice_parts/header.dart';
import 'package:easyinvoice/invoice_parts/station_charges.dart';
import 'package:easyinvoice/invoice_parts/sub_header.dart';
import 'package:easyinvoice/invoice_parts/summary.dart';
import 'package:easyinvoice/models/job.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Invoice extends StatelessWidget {
  final ImportController controller = Get.find();
  final UIController uiController = Get.find();
  final Job job;

  Invoice(this.job);

  Widget build(BuildContext context) {
    double arrowWidth =
        (uiController.screenSize.value.width - uiController.invWidth.value) / 4;
    return Container(
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                        child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              print('tapped left');
                              uiController.invView.value = false;
                            })),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          print('tapped left box');
                          if (controller.jobs.length > 1) {
                            uiController.moveNextJob(backward: true);
                          }
                        },
                        child: Container(
                          height: arrowWidth,
                          width: arrowWidth,
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                blurRadius: 40,
                                spreadRadius: 10,
                                color: Colors.grey.withOpacity(.5))
                          ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_back_ios_rounded,
                                size: uiController.screenSize.value.width / 25,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Previous'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25.0),
                child: SingleChildScrollView(
                    controller: ScrollController(),
                    child: Container(
                      padding:
                          EdgeInsets.all(uiController.invWidth.value * 3 / 100),
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                          spreadRadius: 2,
                          blurRadius: 40,
                          color: Colors.grey,
                          offset: Offset(1, 5),
                        ),
                      ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InvoiceHeader(job),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: SubHeader(job),
                          ),
                          InvoiceSummary(job),
                          StationCharges(job),
                        ],
                      ),
                    )),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                        child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              print('tapped right');
                              uiController.invView.value = false;
                            })),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          print('tapped right box ${controller.jobs.length}');
                          if (controller.jobs.length > 1) {
                            uiController.moveNextJob(backward: false);
                          }
                        },
                        child: Container(
                          height: arrowWidth,
                          width: arrowWidth,
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                blurRadius: 40,
                                spreadRadius: 10,
                                color: Colors.grey.withOpacity(.5))
                          ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: uiController.screenSize.value.width / 25,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Next'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      // TextButton(onPressed: () => Get.back(), child: Icon(Icons.arrow_left))
    );
  }
}
