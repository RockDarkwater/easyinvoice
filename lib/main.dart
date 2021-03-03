// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyinvoice/models/import_batch.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// Todo:
// - function to create service price collection for customers

// - import for AMIS and Accugas data into import batch object.
//    - billable from job, lease info, quantity, and item or service code

// - customer model from firestore

// - ui to interact with customers, prices, items, and services.
// - invoice template

// - link to local email program, or method to send from "invoicing@howardmeasurement.com"
// - ADP and QB export files.

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  // Create the firebase initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Container(alignment: Alignment.center, child: Text('error'));
        }
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          // Start Authentication
          return MyApp();
        }
        // Otherwise, show progress indicator whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  // If no auth call auth service
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() async {
    // testingConnection();

    if (await testImport()) {
      // await refreshItems();
      setState(() {
        _counter++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  testingConnection() async {
    FirebaseFirestore firebase = FirebaseFirestore.instance;
    try {
      DocumentSnapshot itemValue =
          await firebase.collection('items').doc('CABLE').get();

      print('itemValue data: ${itemValue.data()['name']}');
    } catch (err) {
      print('Error getting test doc: $err');
    }
  }

  Future<bool> testImport() async {
    try {
      FilePickerResult result =
          await FilePicker.platform.pickFiles(allowMultiple: true);
      if (result == null) {
        // User canceled the picker
        print('null pick');
      } else {
        print('picked ${result.files.length} files');
        ImportBatch batch = ImportBatch(result);
        print('Import batch created with ${batch.jobs.length} jobs');
      }
    } catch (err) {
      print('Error picking files: ' + err);
      return false;
    }
    return false;
  }
}
