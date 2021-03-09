import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  String itemCode;
  String name;
  double price;
  double cost;
  bool taxable = true;

  Item.fromFirebase(DocumentSnapshot value) {
    // create item from firestore collection 'items'
    if (value.exists) {
      this.itemCode = value.data()['itemCode'];
      this.name = value.data()['name'];
      this.price = value.data()['price'];
      this.cost = value.data()['cost'];
    }
  }
}
