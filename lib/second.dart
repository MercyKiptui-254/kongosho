import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';
import 'dart:ui';
import 'package:kongosho/state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kongosho/constants.dart';
import 'router.dart';
import 'data/moor_database.dart';
import 'package:provider/provider.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:diagonal/diagonal.dart';

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  SharedPreferences prefs; //Global variable

  //provider that listens to changes made.This is the global variable
  AppState appState;
  ReceivePort port = ReceivePort();
  StreamSubscription<double> streamSubscription;

  initIsolate() {
    if (!IsolateNameServer.registerPortWithName(port.sendPort, isolateName)) {
      throw 'Unable to name port';
    }
  }

  @override
  initState() {
    super.initState();

    initIsolate();
    streamSubscription = port.cast<double>().listen((value) {
      Provider.of<AppState>(context, listen: false).setInsulinAmount(value);
    });
  }

  @override
  void dispose() {
    super.dispose();
    IsolateNameServer.removePortNameMapping(isolateName);
    streamSubscription.cancel();
  }

  getDoubleValuesSF() async {
    // Ensure we've loaded the updated count from the background isolate.
    await prefs.reload();

    //Return active Insulin:
    double activeInsulin = prefs.getDouble('activeInsulin') ?? 0.0;

    setState(() {
      this.activeInsulin = activeInsulin;
    });
  }

  double activeInsulin = 0.0;

  @override
  BuildContext get context => super.context;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appState = Provider.of<AppState>(context);
    activeInsulin = appState.getInsulinAmount ?? 0.0;
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        //appbar with BACK BUTTON correctly placed. Copy on all pages except the first one
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Center(child: Text('Kongosho')),
        ),

        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            //TODO:where Zeek is to fill:
            Expanded(
              flex: 3,
              child: Container(
                color: Color(0xffB3E5FC),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //TODO:Zeek put Current Blood Glucose Reading
                    ]),
              ),
            ),

            //active insulin:
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.white,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                          child: Text(
                        "Active Insulin: ${appState.getInsulinAmount ?? 0.0} U",
                        //TODO: I put active insulin from db here

                        style:
                            TextStyle(fontSize: 15, color: Color(0xff757575)),
                      )),
                    ]),
              ),
            ),

            //to bolus and basal pages:
            Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                        child: Container(
                            width: 200,
                            height: 200,
                            child: Center(
                                child: Text(
                              "Bolus",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Pacifico',
                                  fontSize: 30),
                            )), // button text
                            decoration: BoxDecoration(
                              color: Colors.black,
                              image: DecorationImage(
                                  image: AssetImage("images/bolus.png"),
                                  fit: BoxFit.cover),
                            )),
                        onTap: () {
                          Navigator.of(context).pushNamed(bolusPage);
                        }),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                        child: Container(
                            width: 200,
                            height: 200,
                            child: Center(
                                child: Text(
                              "Basal",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Pacifico',
                                  fontSize: 30),
                            )), // button text
                            decoration: BoxDecoration(
                              color: Colors.black,
                              image: DecorationImage(
                                  image: AssetImage("images/basal.png"),
                                  fit: BoxFit.cover),
                            )),
                        onTap: () {
                          Navigator.of(context).pushNamed(basalPage);
                        })
                  ],
                )),

            //to settings page:
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: GestureDetector(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        image: AssetImage("images/settings.png"),
                        height: 50,
                        //TODO: have on tap button
                      ),
                      Center(
                          child: Text(
                        "Settings",
                        style: TextStyle(
                            color: Color(0xff0288D1),
                            fontFamily: 'Pacifico',
                            fontSize: 30),
                      )),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(settingsPage);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
