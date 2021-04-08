import 'package:easyinvoice/models/job.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UIController extends GetxController {
  final invView = false.obs;
  final currentJob = Job().obs;
  final screenSize = Size(0, 0).obs;
  final invWidth = 0.0.obs;
  final invoiceTextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w100,
  );

  setSizes(BuildContext context) {
    screenSize.value = MediaQuery.of(context).size;
    invWidth.value = screenSize.value.width * 7 / 11;
  }
}
