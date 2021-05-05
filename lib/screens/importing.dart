import 'package:easyinvoice/controllers/import_controller.dart';
import 'package:easyinvoice/controllers/ui_controller.dart';
import 'package:easyinvoice/screens/batch.dart';
import 'package:easyinvoice/screens/loading.dart';
import 'package:easyinvoice/test/test_objects.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ImportingScreen extends StatelessWidget {
  final ImportController controller = Get.find();
  final UIController uiController = Get.find();
  final AssetImage howard = AssetImage('assets/logo.png');
  final formatCurrency = NumberFormat.simpleCurrency();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("EasyInvoice"),
      ),
      body: FutureBuilder(
        future: testJob(), //controller.import(), //
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            controller.importQty.value = 1;
            controller.currentImport.value = 0;
            controller.currentProcess.value = 0;
            controller.processQty.value = 1;

            //Loading Process Screen
            return LoadingScreen();
          } else {
            //Batch Screen
            return BatchScreen();
          }
        },
      ),
    );
  }
}
