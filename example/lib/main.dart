import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_barcode_scanner_example/model/form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'controller.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _scanBarcode = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  // Future<void> startBarcodeScanStream() async {
  //   FlutterBarcodeScanner.getBarcodeStreamReceiver(
  //           '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
  //       .listen((barcode) => print(barcode));
  // }

  Future<void> scanQR() async {
    print("reached 2");
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    // _submitForm(barcodeScanRes);
    await _addData(qrData: barcodeScanRes);
    setState(() {
      _scanBarcode = barcodeScanRes;

    });
  }
  Future _addData({required String qrData}) async {
    DocumentReference docRef = await FirebaseFirestore.instance.collection('qrData').add(
      {
        'qrMsg': qrData,
      },
    );
  }
  // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> scanBarcodeNormal() async {
  //   String barcodeScanRes;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
  //         '#ff6666', 'Cancel', true, ScanMode.BARCODE);
  //     print(barcodeScanRes);
  //   } on PlatformException {
  //     barcodeScanRes = 'Failed to get platform version.';
  //   }
  //
  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;
  //
  //   setState(() {
  //     _scanBarcode = barcodeScanRes;
  //   });
  // }
  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  // void _submitForm(String data) {
  //
  //   // if(_formKey.currentState.validate()){
  //   //   FeedbackForm feedbackForm = FeedbackForm(
  //   //       nameController.text,
  //   //       emailController.text,
  //   //       mobileNoController.text,
  //   //       feedbackController.text
  //   //   );
  //   var feedbackForm = QRResult(data);
  //
  //     var formController = FormController((String response){
  //       print("Response: $response");
  //       if(response == FormController.STATUS_SUCCESS){
  //         //
  //         print("Feedback Submitted");
  //       } else {
  //         print("Error Occurred!");
  //       }
  //     });
  //
  //     print("Submitting Feedback");
  //
  //     // Submit 'feedbackForm' and save it in Google Sheet
  //
  //     formController.submitForm(feedbackForm);
  //   // }
  //
  //
  // }

  // Method to show snackbar with 'message'.
  // _showSnackbar(String message) {
  //   final snackBar = SnackBar(content: Text(message));
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: const Text('Barcode scan')),
            body: Builder(builder: (BuildContext context) {
              return Container(
                  alignment: Alignment.center,
                  child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: () => scanQR(),
                            child: Text('Start QR scan')),
                        Text('Scan result : $_scanBarcode\n',
                            style: TextStyle(fontSize: 20))
                      ]));
            })));
  }
}
