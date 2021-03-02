import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  final String code;
  String name;
  String qbName;
  String category;
  int workUnits;

  Service.fromFirebase(this.code) {
    String serviceCode = translateHeader(this.code);

    print('building service: $serviceCode');

    FirebaseFirestore.instance
        .collection('services')
        .doc('$serviceCode')
        .get()
        .then((value) {
      if (value.exists) {
        this.name = value.data()['name'];
        this.qbName = value.data()['qbName'];
        this.category = value.data()['category'];
        this.workUnits = value.data()['workUnits'];
      } else {
        print('$serviceCode does not exist');
      }
    }).onError((error, stackTrace) {
      print('error with service: $error');
      print('stacktrace: $stackTrace');
    });
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
