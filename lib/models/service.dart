import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  final String code;
  String name;
  String qbName;
  String category;
  int workUnits;

  Service.fromFirebase(this.code) {
    String serviceCode = translateHeader(this.code);
    FirebaseFirestore.instance
        .collection('services')
        .doc('$serviceCode')
        .get()
        .then((value) => {
              this.name = value['name'],
              this.qbName = value['qbName'],
              this.category = value['category'],
              this.workUnits = value['workUnits']
            })
        .onError((error, stackTrace) => throw error);
  }

  String translateHeader(String header) {
    String serviceCode;

    switch (header) {
      case 'Sample':
        serviceCode = 'c6GasSample';
        break;
      case 'Stain Tube':
        serviceCode = 'stainTube';
        break;
      case 'EFM Collect':
        serviceCode = 'efmCollection';
        break;
      case 'Travel':
        serviceCode = 'travelTime';
        break;
      case 'Tech Time':
        serviceCode = 'techTime';
        break;
      case 'Miles':
        serviceCode = 'mileage';
        break;
      default:
        serviceCode = header.toLowerCase();
    }

    return serviceCode;
  }
}
