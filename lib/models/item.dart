import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String itemCode;
  String name;
  double price;
  double cost;
  bool taxable = true;

  Item.fromFirebase(this.itemCode) {
    //look on firebase for the item code, pull item details
    FirebaseFirestore.instance
        .collection('items')
        .doc(this.itemCode)
        .get()
        .then((value) {
      this.name = value.data()['name'];
      this.price = value.data()['price'];
      this.cost = value.data()['cost'];
    });
  }
}
