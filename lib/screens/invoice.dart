import 'package:easyinvoice/components/invoice_parts/header.dart';
import 'package:easyinvoice/components/invoice_parts/station_charges.dart';
import 'package:easyinvoice/components/invoice_parts/sub_header.dart';
import 'package:easyinvoice/components/invoice_parts/summary.dart';
import 'package:easyinvoice/controllers/import_controller.dart';
import 'package:easyinvoice/controllers/ui_controller.dart';
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
    return Container(
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back_ios_rounded),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Back'),
                        ),
                      ],
                    )),
                    Container(child: GestureDetector(onTap: () {
                      print('tapped left');
                      uiController.invView.value = false;
                    })),
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
                    Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_forward_ios_rounded),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Back'),
                        ),
                      ],
                    )),
                    Container(child: GestureDetector(onTap: () {
                      print('tapped left');
                      uiController.invView.value = false;
                    })),
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
