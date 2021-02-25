import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  final String code;
  String name;
  String qbName;
  String category;
  int workUnits;

  Service.fromFirebase(this.code) {
    FirebaseFirestore.instance
        .collection('services')
        .doc('${this.code}')
        .get()
        .then((value) => {
              this.name = value['name'],
              this.qbName = value['qbName'],
              this.category = value['category'],
              this.workUnits = value['workUnits']
            })
        .onError((error, stackTrace) => throw error);
  }
}
