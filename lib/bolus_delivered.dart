import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'router.dart';
//import 'package:diagonal/diagonal.dart';

void main() => runApp(MyApp());

//let stateless widget hold mainly the UI
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BolusDeliveredScreen();
  }
}

class BolusDeliveredScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(

        //appbar with BACK BUTTON correctly placed. Copy on all pages except the first one
        appBar: AppBar
          (
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Center(child: Text('Kongosho: Bolus Delivered')),
        ),

        // body:
      ),
    );
  }
}
