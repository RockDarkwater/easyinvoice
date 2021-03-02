import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:file_picker/file_picker.dart';

Future<void> refreshItems() async {
  FilePickerResult result = await FilePicker.platform.pickFiles();
  print('pick successful');

  if (result == null) {
    // User canceled the picker
    print('null pick');
  } else {
    // var _filePath = "C:\Anal\HFS Item List.xlsx";
    var _excel = Excel.decodeBytes(result.files.first.bytes);
    var _itemSheet = _excel.sheets[_excel.sheets.keys.last];

    // delete all items in items collection
    await batchDelete('items');
    print('items deleted');

    // add items from spreadsheet
    writeItems(_itemSheet);
    print('items refreshed');
  }
}

Future<void> batchDelete(String collectionName) {
  // Loop to delete all items in items collection
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference collection = firestore.collection(collectionName);
  WriteBatch batch = firestore.batch();

  return collection.get().then((querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      batch.delete(doc.reference);
    });

    return batch.commit();
  });
}

void writeItems(Sheet sheet) {
  // for each row after 1, code item details to flutterfire batch write
  FirebaseFirestore fbfs = FirebaseFirestore.instance;
  WriteBatch batch = fbfs.batch();
  print('write batch created');

  sheet.rows.forEach((row) {
    Map rowVals = row.asMap();
    if (rowVals[1].toString().toLowerCase() == 'active' &&
        rowVals[2].toString().toLowerCase().contains('part')) {
      // add values to doc "item code" (D): item name(E), item cost(N), item price(Q)
      batch.set(fbfs.collection('items').doc('${rowVals[3]}'), {
        "name": rowVals[4],
        "cost": rowVals[13],
        "price": rowVals[16],
      });

      // print('item: ${rowVals[3]} added to batch');
    }
  });

  try {
    batch.commit();
  } catch (err) {
    print('error comitting batch: $err');
  }
}

Future<void> uploadServices() async {
  FilePickerResult result = await FilePicker.platform.pickFiles();
  if (result == null) {
    // User canceled the picker
    print('null pick');
  } else {
    // var _filePath = "C:\Anal\HFS Services List.xlsx";
    var _excel = Excel.decodeBytes(result.files.first.bytes);
    var _itemSheet = _excel.sheets[_excel.sheets.keys.first];

    await batchDelete('services');

    FirebaseFirestore fbfs = FirebaseFirestore.instance;
    WriteBatch batch = fbfs.batch();

    _itemSheet.rows.forEach((row) {
      Map rowMap = row.asMap();

      if (rowMap[0] != 'serviceCode') {
        batch.set(fbfs.collection('services').doc('${rowMap[3].toString()}'), {
          'name': rowMap[1],
          'qbName': rowMap[4],
          'category': rowMap[2],
          'workUnits': rowMap[5] ?? 0,
        });
        print('added: ${rowMap[1]}');
      }
    });

    try {
      return batch.commit();
    } catch (err) {
      return print('error uploading services: $err');
    }
  }
}

Future<void> uploadCustomers() async {
  FilePickerResult result = await FilePicker.platform.pickFiles();
  if (result == null) {
    // User canceled the picker
    print('null pick');
  } else {
    // var _filePath = "C:\Anal\HFS Services List.xlsx";
    var _excel = Excel.decodeBytes(result.files.first.bytes);
    var _itemSheet = _excel.sheets[_excel.sheets.keys.first];

    await batchDelete('customers');
    print('customers list deleted');

    FirebaseFirestore firebase = FirebaseFirestore.instance;
    // change to for loop, commit every 500 customers

    int loops = (_itemSheet.maxRows ~/ 500) + 1;
    print('running ${_itemSheet.maxRows} times: $loops loops');

    int currentMax;
    int j = 0;
    WriteBatch batch;
    Map<int, List<dynamic>> rowIndex;
    Map<int, dynamic> rowMap;

    for (int i = 0; i <= loops; i++) {
      (i * 500 > _itemSheet.maxRows)
          ? currentMax = _itemSheet.maxRows
          : currentMax = i * 500;
      batch = firebase.batch();
      rowIndex = _itemSheet.rows.asMap();
      print('starting at $j');

      for (; j < currentMax; j++) {
        rowMap = rowIndex[j].asMap();

        if (rowMap[0] != 'ID') {
          batch.set(
              firebase.collection('customers').doc('${rowMap[2].toString()}'), {
            'billingName': rowMap[3],
            'parentCustomer': rowMap[1],
            'add1': rowMap[4] ?? '',
            'add2': rowMap[5] ?? '',
            'add3': rowMap[6] ?? '',
            'city': rowMap[7] ?? '',
            'state': rowMap[8] ?? '',
            'zip': rowMap[9] ?? '',
            'ccFee': rowMap[12].toString().toLowerCase() == 'no' ? false : true,
            'requisitioner': rowMap[13],
            'poNum': rowMap[14] ?? '',
            'fieldArea': rowMap[15] ?? '',
            'taxRate': rowMap[16] ?? 8.25,
            'custClass': rowMap[17] ?? '',
            'billingDeets': rowMap[18] ?? '',
            'distList': rowMap[19] ?? '',
            'fieldMethod': rowMap[20] ?? 'byLease',
            'noChargeArray': rowMap[21] ?? '',
            'convertArray': rowMap[22] ?? '',
          });
          print('added: ${rowMap[3]}');
        }
      }
      try {
        j += 1;
        await batch.commit();
      } catch (err) {
        print('error uploading services: $err');
      }
    }
  }
}
