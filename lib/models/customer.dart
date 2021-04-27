import 'package:easyinvoice/models/rule.dart';

class Customer {
  final String custNum;
  final SubmitOption primarySubmit;
  final String billingName;
  final Map<String, dynamic> priceMap;

  String add1;
  String add2;
  String add3;
  SubmitOption secondarySubmit;
  int parentCustomer;
  String city;
  String state;
  String zip;
  String custClass;
  String distList;
  String fieldArea;
  String poNum;
  String requisitioner;
  double taxRate;
  bool ccFee;
  List<Rule> rules;

  Customer(
      {this.custNum,
      this.billingName,
      this.primarySubmit,
      this.priceMap,
      this.parentCustomer,
      this.add1,
      this.add2,
      this.add3,
      this.city,
      this.state,
      this.zip,
      this.secondarySubmit,
      this.custClass,
      this.distList,
      this.fieldArea,
      this.poNum,
      this.requisitioner,
      this.taxRate,
      this.ccFee,
      this.rules});

  String toJSONString(String path) {
    Map map = {
      '$path.custNum': custNum,
      '$path.primarySubmit': primarySubmit.toString(),
      '$path.billingName': billingName,
      '$path.parentCustomer': parentCustomer.toString(),
      '$path.add1': add1,
      '$path.add2': add2,
      '$path.add3': add3,
      '$path.secondarySubmit': secondarySubmit.toString(),
      '$path.city': city,
      '$path.state': state,
      '$path.zip': zip,
      '$path.custClass': custClass,
      '$path.distList': distList,
      '$path.fieldArea': fieldArea,
      '$path.poNum': poNum,
      '$path.requisitioner': requisitioner,
      '$path.taxRate': taxRate,
      '$path.ccFee': ccFee
    };
    return map.toString();
  }
}

enum SubmitOption { email, mail, openinvoice, ariba, none }
