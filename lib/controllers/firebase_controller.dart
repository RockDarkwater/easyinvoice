import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyinvoice/models/customer.dart';
import 'package:easyinvoice/models/item.dart';
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

    doc = await firebase.collection('customers').doc('$custNum').get();
    print('doc 1: ${doc.exists}');
    doc2 = await firebase.collection('servicePrices').doc('$custNum').get();
    print('doc 2: ${doc.data()['secondarySubmit']}');

    primarySubmit = SubmitOption.values.firstWhere((element) =>
        element.toString().split('.')[1] ==
        doc.data()['primarySubmit'].toString());
    billingName = doc.data()['billingName'];
    priceMap = doc2.data();
    add1 = doc.data()['add1'];
    add2 = doc.data()['add2'];
    add3 = doc.data()['add3'];
    secondarySubmit = SubmitOption.values.firstWhere(
        (element) =>
            element.toString().split('.')[1] == doc.data()['secondarySubmit'],
        orElse: () => SubmitOption.none);
    city = doc.data()['city'];
    state = doc.data()['state'];
    zip = doc.data()['zip'].toString();
    custClass = doc.data()['custClass'];
    distList = doc.data()['distList'];
    fieldArea = doc.data()['fieldArea'];
    poNum = doc.data()['poNum'];
    requisitioner = doc.data()['requisitioner'];
    taxRate = doc.data()['taxRate'] ?? 8.25;
    ccFee = doc.data()['ccFee'];

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
  }

  String translateServiceHeader(String header) {
    // map work ticket column header to firestore service name
    String serviceCode;

    switch (header.trim().toLowerCase()) {
      case 'sample':
        serviceCode = 'c6GasSample';
        break;
      case 'stain tube':
        serviceCode = 'stainTube';
        break;
      case 'efm collect':
        serviceCode = 'efmCollection';
        break;
      case 'travel':
        serviceCode = 'travelTime';
        break;
      case 'tech time':
        serviceCode = 'techTime';
        break;
      case 'miles':
        serviceCode = 'mileage';
        break;
      default:
        serviceCode = header.toLowerCase();
    }

    return serviceCode;
  }
}
