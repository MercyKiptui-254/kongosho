import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'package:provider/provider.dart';
import 'data/moor_database.dart';
import 'package:moor/moor.dart' as moor;
import 'package:android_alarm_manager/android_alarm_manager.dart';


class BolusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        //appbar with BACK BUTTON correctly placed. Copy on all pages except the first one
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Center(child: Text('Bolus Calculator')),
        ),

        // body
        body: BolusForm(),
      ),
    );
  }
}

class BolusForm extends StatefulWidget {
  BolusForm({Key key}) : super(key: key);

  @override
  _BolusFormState createState() => _BolusFormState();
}

class _BolusFormState extends State<BolusForm> {
  //getting the values from SharedPreferences:
  Future<List> getDoubleValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return basal rate:
    double basal_rate = prefs.getDouble('basal_rate') ?? 1.6;

    //Return sensitivity:
    double sensitivity = prefs.getDouble('sensitivity') ?? 1.5;

    //Return carb_ratio:
    double carb_ratio = prefs.getDouble('carb_ratio') ?? 6.4;

    //Return high_BG:
    double high_BG = prefs.getDouble('high_BG') ?? 7.8;

    //Return low_BG:
    double low_BG = prefs.getDouble('low_BG') ?? 5.7;

    //Return max_Bolus:
    double max_Bolus = prefs.getDouble('max_Bolus') ?? 13.0;

    return [basal_rate, sensitivity, carb_ratio, high_BG, low_BG, max_Bolus];
  }

  //declaring the variables:
  //outputted calculated value
  num current_BG = 0.0; //input
  num carb_amount = 0.0; //input carb amount
  num basal_rate = 1.6; //TODO: add for different times, different values
  num sensitivity = 1.5;
  num carb_ratio =
      6.4; //this is insulin to carb ratio //TODO: add for different times, different values
  num high_BG = 7.8; //this is the high target of BG
  num low_BG = 5.7;
  num max_Bolus = 13.0;

  //now, the calculating part:
  double correctionLevel;
  dynamic correctionBolus;
  dynamic foodBolus;
  dynamic totalBolus;
  dynamic bolusTime;

  double activeInsulin = 0.0;

  @override
  void initState() {
    //NEVER put initstate in build fx
    super.initState();
    getDoubleValuesSF().then((value) {
      setState(() {
        basal_rate = value[0];
        sensitivity = value[1];
        carb_ratio = value[2];
        high_BG = value[3];
        low_BG = value[4];
      });
    }).catchError((err) {
      print(err);
    }); //will print the error.
  }

  // the alert box dialog:
  void _showNull() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("No Bolus Delivered"),
          content: new Text(
              "Dear user, no bolus has been delivered. Fill in the required fields."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //alert box when max bolus exceeded:
  // the alert box dialog:
  void _showMax() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Max Bolus Exceeded"),
          content: new Text(
              "Max bolus amount exceeded. Contact healthcare professional if need be."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();

                //
              },
            ),
          ],
        );
      },
    );
  }

  void _showNone() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("No Bolus Delivered"),
          content: new Text(
              "Bolus calculated is less than/ equal to zero. No bolus delivered."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();

                //
              },
            ),
          ],
        );
      },
    );
  }

  //correct correctional:
  dynamic correctCorrectional(){
    print('Correction bolus, before corrections: $correctionBolus');
    if(correctionBolus <= 0.0){
      correctionBolus = 0.0;
    }
  }
  //calc for bolus calc:
  dynamic getBolus() {
    dynamic totalBolus;
    setState(() {
//now, four situations:
      //1.given carb amount only;
      if (carb_amount != 0.0 && current_BG == 0.0) {
        //need only foodBolus
        correctionBolus = 0.0 - activeInsulin;
        correctCorrectional();
        foodBolus = carb_amount / carb_ratio;
        totalBolus = foodBolus + correctionBolus;
      }

      //2. given current BG only;
      else if (carb_amount == 0.0 && current_BG != 0.0) {
        foodBolus = 0.0;
        //for correctionBolus:
        if (current_BG >= high_BG) {
          //sugar is equal or above high limit
          correctionLevel = current_BG - high_BG;
          correctionBolus = (correctionLevel / sensitivity)- activeInsulin;
          correctCorrectional();
          totalBolus = foodBolus + correctionBolus;
        } else if (current_BG <= low_BG) {
          //sugar is equal or below low limit
          correctionLevel = low_BG - current_BG;
          correctionBolus = (correctionLevel / sensitivity) - activeInsulin;
          correctCorrectional();
          totalBolus = foodBolus -
              correctionBolus; //NOTE, this is why we do individual fx of totalBolus. coz here it is NEGATIVE correctional
        } else {
          correctionBolus = 0.0 - activeInsulin;
          correctCorrectional();
          totalBolus = foodBolus + correctionBolus;
        }
      }

      //3. given both carb amount and current BG
      else if (carb_amount != 0.0 && current_BG != 0.0) {
        foodBolus = carb_amount / carb_ratio;
        //for correctionBolus:
        if (current_BG >= high_BG) {
          //sugar is equal or above high limit
          correctionLevel = current_BG - high_BG;
          correctionBolus = (correctionLevel / sensitivity) - activeInsulin;
          correctCorrectional();
          totalBolus = foodBolus + correctionBolus;
        } else if (current_BG <= low_BG) {
          //sugar is equal or below low limit
          correctionLevel = low_BG - current_BG;
          correctionBolus = (correctionLevel / sensitivity) - activeInsulin;
          correctCorrectional();
          totalBolus = foodBolus - correctionBolus; //Also have the negative correctional here
        } else {
          correctionBolus = 0.0 - activeInsulin;
          correctCorrectional();
          totalBolus = foodBolus + correctionBolus;
        }
      }

      //4.Neither values are given:
      else {
        print(
            "No input given"); //this category is JUST IN CASE it gets here. should not reach here
        foodBolus = 0.0;
        correctionBolus = 0.0;
        totalBolus = 0.0;
      }
    });
    setState(() {
      this.totalBolus = totalBolus;
    });
  }

// for Null resetting:
  void makeZero() {
    if (carb_amount == null && current_BG == null) {
      setState(() {
        carb_amount = 0.0;
        current_BG = 0.0;
        _showNull(); //this DOES not  go to the getBolus fx
      });
    } else if (carb_amount != null && current_BG == null) {
      setState(() {
        current_BG = 0.0;
        getBolus();
      });
    } else if (carb_amount == null && current_BG != null) {
      setState(() {
        carb_amount = 0.0;
        getBolus();
      });
    } else {
      getBolus();
    }
  }

  //getting the correct Bolus delivered:
  checkBolus() async {
    if (totalBolus > max_Bolus) {
      _showMax();
    } else if (totalBolus <= 0) {
      _showNone();
    } else {
      addBolus(context, totalBolus);
      final x =  await activeInsulinAmount(context);
      setState(() {
        this.activeInsulin = x;
      });
    }
  }

  //using insulin adjustment
  usingAdjustment() {}

  //inserting row into bolus table:
  Future<dynamic> addBolus(BuildContext context, dynamic totalBolus) async {
    final dao = Provider.of<BolusRecordDao>(context, listen: false);

    final bolusRecord = BolusRecordsCompanion(
      bolusAmount: moor.Value(totalBolus),
      timeStamp: moor.Value(DateTime.now()),
    );

    dao.insertBolusRecord(bolusRecord).catchError((err) {
      print("Error storing Bolus Record in DB: $err");
    });
  }

//getting active insulin in body:
  Future<double> activeInsulinAmount(BuildContext context) async {
    double activeInsulin = 0.0;
    final dao = Provider.of<BolusRecordDao>(context, listen: false);

    //return await dao.activeInsulinAmount();
    try {
      var records = await dao.getAllBolusRecords();
      for (var record in records) {
        if (record.timeStamp.isAfter(
            DateTime.now().subtract(Duration(hours: 4)))) {
          activeInsulin += record.bolusAmount;

        }
      }
    } catch (err) {
      print("Error retrieving Active Insulin from the database.");
    }
    return activeInsulin;
  }

  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff1976D2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //for current_BG input:
          TextField(
            onChanged: (text) {
              setState(() {
                current_BG = num.tryParse(text);
              });
            },
            keyboardType:
                TextInputType.numberWithOptions(signed: false, decimal: true),
            textAlign: TextAlign.center,
            maxLength: 4,
            style: TextStyle(
              fontSize: 20.0,
              color: Color(0xff1976D2),
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              icon: Icon(Icons.invert_colors),
              labelText: "Current BG",
              helperText: 'Input your current blood glucose',
              counterText: '4 characters',
              contentPadding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
              border: const OutlineInputBorder(),
            ),
          ),

          //for carb_amount input:
          TextField(
            onChanged: (text) {
              setState(() {
                carb_amount = num.tryParse(text);
              });
            },
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 3,
            style: TextStyle(
              fontSize: 20.0,
              color: Color(0xff1976D2),
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              icon: Icon(Icons.invert_colors),
              labelText: "Carb Count",
              helperText: 'Input how many carbs you are eating',
              contentPadding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
              border: const OutlineInputBorder(),
            ),
          ),

          RaisedButton(
            child: Text(
              "Deliver Bolus",
              style: TextStyle(fontSize: 20),
            ),
            color: Color(0xff03A9F4),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Color(0xff1976D2))),
            textColor: Colors.white,
            onPressed: () {
              print("current_BG: $current_BG");
              print("carb amount: $carb_amount");
              print("sensitivity: $sensitivity");
              print("carb_ratio: $carb_ratio");
              print("high_BG: $high_BG");
              print("low_BG: $low_BG");
              activeInsulinAmount(context).then((value) {
                setState(() {
                  activeInsulin = value;//NOTE: CALC is AFTER we get value of active insulin. Do NOT need alarm manager here.
                  makeZero(); //the getBolus fx lives here
                  print("total bolus: $totalBolus");
                  print("correction bolus: $correctionBolus");
                  print("food bolus: $foodBolus");
                  checkBolus();
                 // print("total bolus,after checking: $totalBolus");
                  print("active insulin: $activeInsulin");
                });
              }).catchError((err) {
                print(err);
              });


            },
          ),
        ],
      ),
    );
  }
}
