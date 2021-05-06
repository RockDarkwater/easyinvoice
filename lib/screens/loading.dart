import 'package:easyinvoice/controllers/import_controller.dart';
import 'package:easyinvoice/controllers/ui_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingScreen extends StatelessWidget {
  final UIController uiController = Get.find();
  final ImportController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width / 3,
        color: Colors.grey[50],
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
                      style: TextStyle(color: Colors.deepOrange, fontSize: 42),
                    ),
                  ),
                  Obx(() => Text(
                        '${controller.resultNames[controller.currentImport.value]}',
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style:
                            TextStyle(color: Colors.deepOrange, fontSize: 14),
                      )),
                ],
              ),
            ),
            Stack(alignment: Alignment.center, children: [
              Obx(() => LinearProgressIndicator(
                    minHeight: 25,
                    value: (controller.currentProcess.value /
                        controller.processQty.value),
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                    backgroundColor: Colors.orange,
                  )),
              Obx(() => Text(
                    'Stations: ${controller.currentProcess.value} / ${controller.processQty.value}',
                    style: TextStyle(fontSize: 15, color: Colors.white),
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
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                    backgroundColor: Colors.orange,
                  )),
              Obx(() => Text(
                    'Imports: ${controller.currentImport.value} / ${controller.importQty.value}',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                    textAlign: TextAlign.center,
                  )),
            ]),
          ],
        ),
      ),
    );
  }
}
