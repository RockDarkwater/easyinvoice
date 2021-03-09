import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  String custNum;
  FirebaseFirestore firebase = FirebaseFirestore.instance;
  String add1;
  String add2;
  String add3;
  String billingDeets;
  String billingName;
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
  Map<String, dynamic> priceMap = Map();

  Customer.fromFirebase(DocumentSnapshot value, {this.priceMap}) {
    //get customer level data
    this.custNum = value.id.toString();
    this.add1 = value.data()['add1'].toString();
    this.add2 = value.data()['add2'].toString();
    this.add3 = value.data()['add3'].toString();
    this.billingDeets = value.data()['billingDeets'].toString();
    this.billingName = value.data()['billingName'].toString();
    this.city = value.data()['city'].toString();
    this.state = value.data()['state'].toString();
    this.zip = value.data()['zip'].toString();
    this.custClass = value.data()['custClass'].toString();
    this.distList = value.data()['distList'].toString();
    this.fieldArea = value.data()['fieldArea'].toString();
    this.poNum = value.data()['poNum'].toString();
    this.requisitioner = value.data()['requisitioner'].toString();
    this.taxRate = value.data()['taxRate'] ?? 8.25;
    this.ccFee = value.data()['ccFee'] ?? false;
  }
}
