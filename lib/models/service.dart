import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  String code;
  String name;
  String qbName;
  String category;
  double workUnits;

  Service.fromFirebase(this.code) {
    // change work ticket column header to firestore service name
    String serviceCode = translateHeader(code);

    // create service object from firestore service name
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
