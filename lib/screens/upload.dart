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
        title: Text('EasyInvoice'),
      ),
      body: Center(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
              child: GestureDetector(
                onTap: () {
                  print('Tapped on Upload');
                  if (controller.jobs.length > 0) {
                    Get.to(
                        () => Scaffold(
                            appBar: AppBar(
                              title: Text('EasyInvoice v0.0.1'),
                            ),
                            body: BatchScreen()),
                        transition: Transition.noTransition);
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
                      color: Colors.orange)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Click the button to upload files:',
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
                      tooltip: 'Increment',
                      child: Icon(Icons.add),
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
