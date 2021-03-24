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
      body: StreamBuilder(
        stream: controller.jobs.stream,
        builder: (context, _) => Padding(
          padding: const EdgeInsets.only(left: 50.0, right: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: ListView.builder(
                    itemCount: controller.jobs.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                            'Customer: ${controller.jobs[index].customer.custNum} - ${controller.jobs[index].customer.billingName}'),
                        onTap: () async => Get.dialog(Container(
                            height: 200,
                            width: 400,
                            child: Center(
                              child: Text(
                                  "charges for ${controller.jobs[index].stationCharges.length} stations",
                                  style: TextStyle(
                                      color: Colors.black,
                                      decoration: TextDecoration.none)),
                            ))),
                        focusColor: Colors.white54,
                        leading: TextButton(
                          onPressed: () => controller.jobs.removeAt(index),
                          child: Icon(Icons.remove),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}