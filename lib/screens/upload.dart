import 'package:easyinvoice/controllers/import_controller.dart';
import 'package:easyinvoice/screens/batch_overview.dart';

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
            Column(
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
                      Get.to(() => OverviewScreen(),
                          transition: Transition.noTransition);
                      // await controller.import();
                    },
                    tooltip: 'Increment',
                    child: Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
