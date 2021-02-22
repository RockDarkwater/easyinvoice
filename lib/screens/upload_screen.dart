import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  String _fileName = 'No File Selected';
  FilePickerResult _batch;
  List<Sheet> excel = [];

  void _openFileExplorer() async {
    try {
      //launch file picker
      _batch = await FilePicker.platform.pickFiles(allowMultiple: true);
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    //not sure what this does
    if (!mounted) return;

    //translate data into excel plug-in
    for (var file in _batch.files) {
      Excel wb = Excel.decodeBytes(file.bytes);
      excel.add(wb.sheets[wb.sheets.keys.first]);
    }
    setState(() {});
    for (var sheet in excel) {
      var a11Val = sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 10))
          .value;
      print(a11Val);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('EasyInvoice v. 0.0.1'),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
              child: Column(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () => _openFileExplorer(),
                    child: const Text("Open file picker"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(_fileName),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
