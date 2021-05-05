import 'dart:math';

import 'package:easyinvoice/models/job.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UIController extends GetxController {
  final invView = false.obs;
  final currentJob = Job().obs;
  final screenSize = Size(0, 0).obs;
  final invWidth = 0.0.obs;
  final TextTheme textTheme = TextTheme(
    headline1: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
    ),
    bodyText1: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w200,
    ),
  );
  final invoiceHeaderTextStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
  );
  final invoiceTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w200,
  );

  setSizes(BuildContext context) {
    screenSize.value = MediaQuery.of(context).size;
    invWidth.value = screenSize.value.height * 8.5 / 11;
  }

  double roundTo(double value, int decimalPlaces) {
    return (value * pow(10, decimalPlaces)).round() / pow(10, decimalPlaces);
  }
}
