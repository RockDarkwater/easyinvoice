import 'package:easyinvoice/controllers/firebase_curation_functions.dart';
import 'package:easyinvoice/controllers/import_controller.dart';
import 'package:easyinvoice/controllers/ui_controller.dart';
import 'package:easyinvoice/screens/batch.dart';
import 'package:easyinvoice/screens/importing.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadScreen extends StatelessWidget {
  final ImportController controller = Get.find();
  final UIController uiController = Get.find();

  @override
  Widget build(BuildContext context) {
    uiController.setSizes(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'EasyInvoice',
          style: uiController.textTheme.headline1,
        ),
      ),
      body: Center(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
              child: GestureDetector(
                onTap: () async {
                  if (controller.jobs.length > 0) {
                    Get.to(
                        () => Scaffold(
                            appBar: AppBar(
                              centerTitle: true,
                              title: Text(
                                'EasyInvoice',
                                style: uiController.textTheme.headline1,
                              ),
                            ),
                            body: BatchScreen()),
                        transition: Transition.noTransition);
                  } else {
                    //await uploadServicePrices();
                  }
                },
              ),
            ),
            Container(
              height: 200,
              width: 600,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 10.0,
                      style: BorderStyle.solid,
                      color: Colors.grey[800])),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Click the button to upload files:',
                    style: uiController.textTheme.bodyText1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: FloatingActionButton(
                      onPressed: () async {
                        // await uploadCustomers();
                        // controller.jobs.add(await testJob());
                        Get.to(() => ImportingScreen(),
                            transition: Transition.noTransition);
                        // await controller.import();
                      },
                      child: Icon(
                        Icons.add,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
