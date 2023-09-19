// import 'dart:convert' as convert;
// import 'package:flutter_barcode_scanner_example/model/form.dart';
// // import 'package:http/http.dart' as http;
// import 'package:flutter_barcode_scanner/example/lib/model/form.dart';
//
//
//
// class FormController {
//   // Callback function to give response of status of current request.
//   final void Function(String) callback;
//
//   // Google App Script Web URL
//   static const String URL = "https://script.google.com/macros/s/AKfycbz37o7kS2vKCMNryfMpy4rARTsqwxZmp-tJdlyi-ldQ7_C8WCghFcYJg1M104CIeRaE3A/exec";
//
//   static const STATUS_SUCCESS = "SUCCESS";
//
//   FormController(this.callback);
//
//   void submitForm(QRResult qrResult) async{
//     print("controller check");
//     try{
//       await http.get(Uri.parse(URL + qrResult.toParams())).then(
//               (response){
//             callback(convert.jsonDecode(response.body)['status']);
//           });
//       print("Correct");
//     } catch(e){
//       print("error");
//       print(e);
//     }
//   }
// }