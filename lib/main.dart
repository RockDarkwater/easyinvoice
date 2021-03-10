// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyinvoice/controllers/firebase_controller.dart';
import 'package:easyinvoice/models/customer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'components/firebase_curation_functions.dart';
import 'models/item.dart';

// Todo:
// - import for AMIS and Accugas data into import batch object.
//    - billable from job, lease info, quantity, and item or service code

// - customer model from firestore

// - ui to interact with customers, prices, items, and services.
// - invoice template

// - link to local email program, or method to send from "invoicing@howardmeasurement.com"
// - ADP and QB export files.

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final flutterfire = Get.put(FireBaseController());
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

  Future<void> _incrementCounter() async {
    FireBaseController flutterfire = Get.find();
    // await uploadServicePrices();
    // await refreshItems();
    // await uploadCustomers();

    Customer testCust = await flutterfire.getCustomer('8113');
    print('${testCust.billingName} - ${testCust.priceMap['calibrations']}');

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
}
