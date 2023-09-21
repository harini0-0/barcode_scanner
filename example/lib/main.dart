import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_barcode_scanner_example/model/form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;

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

//var url = Uri.parse('https://azuredevscs.o9solutions.com/api/ibplquery/5327/ExecuteQueryJson');
var tenantId = '1';
var url = Uri.parse('http://172.20.10.44:9876/api/ibplquery/1/scanbarcode');
  
  Map<String, String> mainHeader = 
  {
    "Content-type": "application/json",
    //"Authorization": "ApiKey blank"
    "Authorization": "ApiKey wu9ziff2.kgzrmi7w4hvgewks95w4scw"
  };

  Future<void> scanQR({required String context}) async {
    print("reached 2");
    print(context);
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
    await _addData(qrData: barcodeScanRes, context: context);
    setState(() {
      _scanBarcode = barcodeScanRes;

    });
  }
  Future _addData({required String qrData, required String context}) async {
    print("reached3");
    print(context);
    DocumentReference docRef = await FirebaseFirestore.instance.collection('qrData').add(
      {
        'qrMsg': qrData,
      },
    );

    print("reached4");

    //var response = await http.post(url, headers: mainHeader, body: {'qrMsg': qrData});

    
    var response = await http.post(url, headers: mainHeader, body: jsonEncode({'barcode': qrData, 'context' : context }));

    //var response = await http.post(url, headers: mainHeader, body: jsonEncode({'barcode': '123', 'context': 'gate-123' }));
  

  // check the status code for the result  
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }  

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
                            onPressed: () => scanQR(context: 'Picker'),
                            child: Text('Start QR scan1')),
                        ElevatedButton(
                            onPressed: () => scanQR(context: 'Dispatch'),
                            child: Text('Start QR scan2')),
                        ElevatedButton(
                            onPressed: () => scanQR(context: 'Receiver'),
                            child: Text('Start QR scan3')),
                        ElevatedButton(
                            onPressed: () => scanQR(context: 'Putaway'),
                            child: Text('Start QR scan4')),
                        Text('Scan result : $_scanBarcode\n',
                            style: TextStyle(fontSize: 20))
                      ]
                      ));
            })));
  }
}
