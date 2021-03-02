import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String itemCode;
  String name;
  double price;
  double cost;
  bool taxable = true;

  Item.fromFirebase(this.itemCode) {
    //look on firebase for the item code, pull item details
//     try {
// Future<DocumentSnapshot> itemValue = FirebaseFirestore.instance
//         .collection('items')
//         .doc(this.itemCode)
//         .get()
//     }
    print('building item: ${this.itemCode}');

    FirebaseFirestore.instance
        .collection('items')
        .doc(this.itemCode)
        .get()
        .then((value) {
      if (value.exists) {
        this.name = value.data()['name'];
        this.price = value.data()['price'];
        this.cost = value.data()['cost'];
      } else {
        print('$itemCode does not exist');
      }
    }).onError((error, stackTrace) {
      print('Error retrieving item: ' + error.toString());
      print('Stacktrace: ' + stackTrace.toString());
    });
  }
}
