import 'package:easyinvoice/models/rule.dart';
import 'package:flutter/cupertino.dart';

class Customer {
  final UniqueKey key = UniqueKey();
  final String custNum;
  final SubmitOption primarySubmit;
  final String billingName;
  final Map<String, dynamic> priceMap;

  String add1;
  String add2;
  String add3;
  SubmitOption secondarySubmit;
  Map<int, String> parentCustomer;
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

  Customer.fromJson(Map<String, dynamic> json)
      : custNum = json['custNum'],
        billingName = json['billingName'],
        primarySubmit = SubmitOption.values.elementAt(json['primarySubmit']),
        priceMap = json['priceMap'],
        parentCustomer = json['parentCustomer'],
        add1 = json['add1'],
        add2 = json['add2'],
        add3 = json['add3'],
        city = json['city'],
        state = json['state'],
        zip = json['zip'],
        secondarySubmit =
            SubmitOption.values.elementAt(json['secondarySubmit']),
        custClass = json['custClass'],
        distList = json['distList'],
        fieldArea = json['fieldArea'],
        poNum = json['poNum'],
        requisitioner = json['requisitioner'],
        taxRate = json['taxRate'],
        ccFee = json['ccFee'],
        rules = json['rules'];

  Map<String, dynamic> toJson() => {
        'custNum': custNum,
        'billingName': billingName,
        'primarySubmit': primarySubmit.index,
        'secondarySubmit': secondarySubmit.index,
        'parentCustomer': parentCustomer,
        'add1': add1,
        'add2': add2,
        'add3': add3,
        'city': city,
        'state': state,
        'zip': zip,
        'custClass': custClass,
        'distList': distList,
        'fieldArea': fieldArea,
        'poNum': poNum,
        'requisitioner': requisitioner,
        'taxRate': taxRate,
        'ccFee': ccFee,
        'rules': rules,
        'priceMap': priceMap,
      };
}

enum SubmitOption { email, mail, openinvoice, ariba, none }
