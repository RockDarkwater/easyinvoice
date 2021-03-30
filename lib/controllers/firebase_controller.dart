import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyinvoice/models/customer.dart';
import 'package:easyinvoice/models/item.dart';
import 'package:easyinvoice/models/service.dart';
import 'package:easyinvoice/test/generic_price_map.dart';
import 'package:get/get.dart';

class FireBaseController extends GetxController {
  FirebaseFirestore firebase = FirebaseFirestore.instance;

  Future<Item> getItem(String itemCode) async {
    String name;
    double price;
    double cost;

    DocumentSnapshot doc =
        await firebase.collection('items').doc('$itemCode').get();

    name = doc.data()['name'];
    price = doc.data()['price'];
    cost = doc.data()['cost'];

    return Item(itemCode: itemCode, name: name, price: price, cost: cost);
  }

  Future<Customer> getCustomer(String custNum) async {
    DocumentSnapshot doc;
    DocumentSnapshot doc2;
    SubmitOption primarySubmit;
    String billingName;
    Map<String, dynamic> priceMap;
    Map<String, dynamic> genericMap = genericPriceMap();
    String add1;
    String add2;
    String add3;
    SubmitOption secondarySubmit;
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

    // print('searching for $custNum');
    doc2 = await firebase.collection('servicePrices')?.doc('$custNum')?.get();
    doc = await firebase.collection('customers')?.doc('$custNum')?.get();
    if (!doc2.exists) priceMap = Map.from(genericMap);

    if (doc.exists) {
      primarySubmit = SubmitOption.values.firstWhere((element) =>
          element.toString().split('.')[1] ==
          doc.data()['primarySubmit'].toString());
      billingName = doc.data()['billingName'];
      priceMap ??= Map.from(doc2.data());
      for (var key in genericMap.keys) {
        if (!priceMap.keys.contains(key)) priceMap[key] = genericMap[key];
      }
      add1 = doc.data()['add1'];
      add2 = doc.data()['add2'];
      add3 = doc.data()['add3'];
      secondarySubmit = SubmitOption.values.firstWhere(
          (element) =>
              element.toString().split('.')[1] == doc.data()['secondarySubmit'],
          orElse: () => SubmitOption.none);
      city = doc?.data()['city'];
      state = doc?.data()['state'];
      zip = doc?.data()['zip'].toString();
      custClass = doc?.data()['custClass'] ?? '';
      distList = doc?.data()['distList'] ?? '';
      fieldArea = doc?.data()['fieldArea'] ?? '';
      poNum = doc?.data()['poNum'].toString() ?? '';
      requisitioner = doc?.data()['requisitioner'] ?? '';
      taxRate = doc?.data()['taxRate'] ?? 8.25;
      ccFee = doc?.data()['ccFee'] ?? false;

      return Customer(
          custNum: custNum,
          billingName: billingName,
          primarySubmit: primarySubmit,
          priceMap: priceMap,
          add1: add1,
          add2: add2,
          add3: add3,
          secondarySubmit: secondarySubmit,
          city: city,
          state: state,
          zip: zip,
          custClass: custClass,
          distList: distList,
          fieldArea: fieldArea,
          poNum: poNum,
          requisitioner: requisitioner,
          taxRate: taxRate,
          ccFee: ccFee);
    } else
      return null;
  }

  Future<Service> getService(String serviceCode) async {
    DocumentSnapshot doc =
        await firebase.collection('services').doc('$serviceCode').get();

    String name = doc.data()['name'];
    String qbName = doc.data()['qbName'];
    String category = doc.data()['category'];
    double workUnits = doc.data()['workUnits'];

    return Service(
        serviceCode: serviceCode,
        name: name,
        qbName: qbName,
        category: category,
        workUnits: workUnits);
  }
}
