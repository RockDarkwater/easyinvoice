import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

Future<void> refreshItems() async {
  FilePickerResult result = await FilePicker.platform.pickFiles();
  print('pick successful');

  if (result == null) {
    // User canceled the picker
    print('null pick');
  } else {
    var _filePath = "C:\Anal\HFS Item List.xlsx";
    var _excel = Excel.decodeBytes(result.files.first.bytes);
    var _itemSheet = _excel.sheets[_excel.sheets.keys.last];

    // Loop to delete all items in items collection
    // FirebaseFirestore firestore = FirebaseFirestore.instance;
    // QuerySnapshot docsToDelete = await firestore.collection('items').get();
    // WriteBatch writeBatch = firestore.batch();
    // docsToDelete.docs.forEach((doc) {
    //   DocumentReference docRef = firestore.collection('testWrite').doc(doc.id);

    //   writeBatch.delete(docRef);
    // });
    // // Only 500 actions in a commit
    // await writeBatch.commit();

    // check if row is an active part

    int activeParts = 0;
    for (int i = 0; i < _itemSheet.maxRows - 1; i++) {
      bool activePart = true;

      String checkActive = _itemSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i + 1))
          .value
          .toString();
      if (checkActive.toLowerCase() != 'active') activePart = false;
      // print('$checkActive - $isActive');
      if (activePart) {
        String itemType = _itemSheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: i + 1))
            .value;
        if (!itemType.toLowerCase().contains('part')) activePart = false;
        if (activePart) activeParts++;
      }
    }
    print('total active parts: $activeParts');
  }
}
