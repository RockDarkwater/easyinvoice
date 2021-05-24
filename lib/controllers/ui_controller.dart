import 'dart:math';

import 'package:easyinvoice/models/job.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UIController extends GetxController {
  final invView = false.obs;
  final currentJob = Job().obs;
  final currentJobNum = 1.obs;
  final currentJobs = <Job>[].obs;
  final screenSize = Size(0, 0).obs;
  final invWidth = 0.0.obs;
  final TextTheme textTheme = TextTheme(
    headline1: TextStyle(
        fontSize: 22, fontWeight: FontWeight.w700, color: Colors.orange[600]),
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
    fontSize: 12,
  );
  final smallInvoiceTextStyle = TextStyle(
    fontSize: 12,
  );

  moveNextJob({bool backward = false}) {
    //increment index number in current jobs
    print('Moving Jobs');
    if (backward) {
      (currentJobNum.value > 1)
          ? currentJobNum.value--
          : currentJobNum.value = currentJobs.length;
    } else {
      (currentJobNum.value < currentJobs.length)
          ? currentJobNum.value++
          : currentJobNum.value = 1;
    }

    currentJob.value = currentJobs[currentJobNum.value - 1];
  }

  setSizes(BuildContext context) {
    screenSize.value = MediaQuery.of(context).size;

    invWidth.value = screenSize.value.height * 8.5 / 11;
    print(
        'Screen Width: ${screenSize.value.width}, Invoice Width: ${invWidth.value.toInt()}');
  }

  double roundTo(double value, int decimalPlaces) {
    return (value * pow(10, decimalPlaces)).round() / pow(10, decimalPlaces);
  }

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }
}
