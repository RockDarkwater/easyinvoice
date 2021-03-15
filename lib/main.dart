import 'package:easyinvoice/controllers/firebase_controller.dart';
import 'package:easyinvoice/controllers/import_controller.dart';
import 'package:easyinvoice/models/import_batch.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import 'models/job.dart';

// Todo:

// - Move AMIS/AccuGas spreadsheet data into job/station/item structure
// - Function to find customer number from name string

// - ui to interact with customers, prices, items, and services.
// - invoice template

// - link to local email program, or method to send from "invoicing@howardmeasurement.com"
// - ADP and QB export files.

// - enable desktop mode?

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(FireBaseController());
  Get.put(ImportController());
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
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: MyHomePage(title: 'Flutter Demo Home Page'),
          );
        }
        // Otherwise, show progress indicator whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
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

  Future<void> _incrementCounter() async {
    // FireBaseController flutterfire = Get.find();
    ImportController importController = Get.find();
    // await uploadServicePrices();
    // await refreshItems();
    // await uploadCustomers();

    ImportBatch batch = await importController.import();

    List<Job> jobs =
        await importController.buildAccugasJobs(batch.spreadsheets.first);
    double count = jobs.first.countCharges();
    print('${jobs.length} jobs. First: ${jobs.first.customer} - $count');

    // print(
    //     '${jobs.length} jobs. First: ${jobs.first.customer} - ${jobs.first.stationCharges.length} stations, ${jobs.first.countCharges()}');
    // if (await testImport()) {
    //   setState(() {
    //     _counter++;
    //   });
    // }

    print('done!');
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
}
