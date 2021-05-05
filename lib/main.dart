import 'package:easyinvoice/controllers/firebase_controller.dart';
import 'package:easyinvoice/controllers/import_controller.dart';
import 'package:easyinvoice/controllers/ui_controller.dart';
import 'package:easyinvoice/screens/upload.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

// TODO:

// - job splitting based on customer needs.
//    - 5 field rule: incoming customer, bool test (field + value), change to make (field + value)
//    - JSON string for job (granular), useful for searches.
//    - parent # = pricing, billing # = location, QB# = upload

// - ui to interact with customers, service prices, items, services, and rules.
//    - update items from QB list.

// - link to local email program, or method to send from "invoicing@howardmeasurement.com"
// - ADP and QB export files.

// - Cimarex invoice template
// - enable desktop mode?

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(FireBaseController());
  Get.put(ImportController());
  Get.put(UIController());
  runApp(App());
}

class App extends StatelessWidget {
  // Create the firebase initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final ImportController controller = Get.find();
  final UIController uiController = Get.find();

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
          return GetMaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
                primarySwatch: Colors.deepOrange,
                primaryColor: Colors.orange,
                accentColor: Colors.white,
                primaryTextTheme: uiController.textTheme),
            home: UploadScreen(),
          );
        }
        // Otherwise, show progress indicator whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }
}
