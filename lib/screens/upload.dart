import 'package:easyinvoice/components/firebase_curation_functions.dart';
import 'package:easyinvoice/controllers/import_controller.dart';
import 'package:easyinvoice/test/test_objects.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadScreen extends StatelessWidget {
  final ImportController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EasyInvoice v0.0.1'),
      ),
      body: Center(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
              height: 200,
              width: 600,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.orange,
                      width: 10.0,
                      style: BorderStyle.solid)),
            ),
            Obx(
              () => controller.jobs.length == 0
                  ? Column(
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
                              await controller.import();
                            },
                            tooltip: 'Increment',
                            child: Icon(Icons.add),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              'Click \' - \' to remove the ${controller.jobs.length} jobs, Click \' + \' to add more.'),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FloatingActionButton(
                                  onPressed: () async => controller.import,
                                  child: Icon(Icons.remove),
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                FloatingActionButton(
                                  onPressed: () => controller.jobs.clear(),
                                  child: Icon(Icons.add),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
