import 'package:easyinvoice/controllers/import_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OverviewScreen extends StatelessWidget {
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
            ListView.builder(
                itemCount: controller.jobs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Customer: ${controller.jobs[index].customer}'),
                    leading: TextButton(
                      onPressed: () => controller.jobs.removeAt(index),
                      child: Icon(Icons.remove),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
