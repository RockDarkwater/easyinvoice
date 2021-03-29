import 'package:easyinvoice/controllers/firebase_controller.dart';
import 'package:easyinvoice/controllers/import_controller.dart';
import 'package:easyinvoice/screens/upload.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

// Todo:

// - job splitting based on customer needs.
// - import with generic price map if customer map is deficient (TEST)
// - header with prompt for choosing customer dialog
// - overview list shows total price, date span, total items, etc.
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
  final ImportController controller = Get.find();

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
                accentColor: Colors.white70),
            home: UploadScreen(),
          );
        }
        // Otherwise, show progress indicator whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }
}
