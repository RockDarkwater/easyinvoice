import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String itemCode;
  String name;
  double price;
  bool taxable;

  double cost;

  Item(this.name, this.itemCode, this.price, this.taxable, {this.cost});

  Item.fromFirebase(this.itemCode) {
    //look on firebase for the item code, pull item details
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    firestore.collection('items').doc(this.itemCode).get().then((value) {
      this.name = value['name'];
      this.price = value['price'];
      this.cost = value['price'];
    }).onError((error, stackTrace) => throw error);
  }
}
