import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:flutter_countdown_timer/countdown_timer.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'temp_basal.dart';
import 'package:kongosho/constants.dart';
import 'router.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'data/moor_database.dart';
import 'package:moor/moor.dart' as moor;
import 'package:android_alarm_manager/android_alarm_manager.dart';


class BasalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appbar with BACK BUTTON correctly placed. Copy on all pages except the first one
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Center(child: Text('Temporary Basal')),
        ),

        body: TempBasalForm(),
      );
  }
}

class TempBasalForm extends StatefulWidget {
  TempBasalForm({Key key}) : super(key: key);

  @override
  _TempBasalFormState createState() => _TempBasalFormState();
}

class _TempBasalFormState extends State<TempBasalForm> {
  //getting values from SharedPreferences:
  Future<double> getDoubleValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return basal rate:
    double basal_rate = prefs.getDouble('basal_rate') ?? 1.6;

    return basal_rate;
  }

  //variables:
  num basal_rate;
  Duration tempbasal_time;

  //for the db and BLE:
  num tempbasal_time_sec_total;

  //for countdown timer:
  int tempbasal_time_hrOnly;
  int tempbasal_time_minOnly;
  num tempbasal_percent;
  num new_basal_rate;

  //strings, for int conversions:
  String tempbasal_sec_total;
  String tempbasal_hr_only;
  String tempbasal_min_only;

  bool CheckValue;
  num deliver_basal;
  dynamic basalTime;

  void initState() {
    //NEVER put initstate in build fx
    super.initState();
    getDoubleValuesSF().then((value) {
      setState(() {
        basal_rate = value;
        deliver_basal = value;
      });
    }).catchError((err) {
      print(err);
    }); //will print the error.


  }

  //ask for time specifics
  void timeTap() {
    Picker(
      adapter: NumberPickerAdapter(data: <NumberPickerColumn>[
        const NumberPickerColumn(begin: 0, end: 999, suffix: Text(' hours')),
        const NumberPickerColumn(
            begin: 0, end: 60, suffix: Text(' minutes'), jump: 5),
      ]),
      delimiter: <PickerDelimiter>[
        PickerDelimiter(
          child: Container(
            width: 30.0,
            alignment: Alignment.center,
            child: Icon(Icons.more_vert),
          ),
        )
      ],
      hideHeader: true,
      confirmText: 'OK',
      confirmTextStyle:
          TextStyle(inherit: false, color: Colors.red, fontSize: 22),
      title: const Text('Select duration for Temp Basal'),
      selectedTextStyle: TextStyle(color: Colors.blue),
      onConfirm: (Picker picker, List<int> value) {
        //NOTE: comes out as integer values.MJ
        // You get your duration here
        tempbasal_time = Duration(
            hours: picker.getSelectedValues()[0],
            minutes: picker.getSelectedValues()[1]);
        tempbasal_time_sec_total = ((picker.getSelectedValues()[0] * 3600) +
            (picker.getSelectedValues()[1] * 60));
        tempbasal_time_hrOnly = picker.getSelectedValues()[0];
        tempbasal_time_minOnly = picker.getSelectedValues()[1];
      },
    ).showDialog(context);
  }

  // the alert box dialog:
  void _showNull() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Basal Rate has NOT been changed"),
          content: new Text(
              "Dear user, no temporary basal has been given. Fill in the required field(s)."),
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

  //deal with nulls
  void checkNulls() {
    if (tempbasal_percent == null &&
        tempbasal_time == Duration(hours: 0, minutes: 0, seconds: 0)) {
      tempbasal_percent = 0;
      _showNull();
    } else if (tempbasal_percent == null ||
        tempbasal_time == Duration(hours: 0, minutes: 0, seconds: 0)) {
      tempbasal_percent = 0;
      _showNull();
    } else {
      getNewBasal();
    }
  }

  // get the new basal rate
  num getNewBasal() {
    new_basal_rate = basal_rate * (tempbasal_percent / 100);
  }

  //convert to strings:
  intToString(){
  tempbasal_sec_total = tempbasal_time_sec_total.toString();
  tempbasal_hr_only = tempbasal_time_hrOnly.toString();
  tempbasal_min_only = tempbasal_time_minOnly.toString();
  }

  //construct the timer in the background:
  makeTimer() {
    Timer(tempbasal_time, () {
      print(
          "Yeah, this line is printed after $tempbasal_time_sec_total seconds");
      removeTemp();
    });
  }

  //removing temp basal:
  removeTemp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Remove double:
    prefs.remove(
        'new_basal_rate'); //NOTE: removes this rate IMMEDIATELY the tempbasal time is up

    //correctBasal();//bg
  }

  //checking for new_basal_rate and assigning the deliver_basal appropriately.
  //TODO:this fx correctBasal should be used when work manager wants to pick the correct basal(deliver_basal) periodically
  //should ALSO be used when the timer is up to display the "done" message-container and also to write to persistent memory the correct deliver_basal


  //prepping basal timestamp:
  getBasalClickTime(){
    basalTime = new DateTime.now();
    print("Timestamp of button click is: $basalTime"); //NOTE: the timestamp for basalTime is not soo important as data shall not be filtered for this table
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff1976D2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //for temp basal %:
          TextField(
            onChanged: (text) {
              setState(() {
                tempbasal_percent = num.tryParse(text);
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
              labelText: "Temp Basal %",
              helperText: 'Input temporary basal percentage',
              counterText: '3 characters',
              contentPadding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
              border: const OutlineInputBorder(),
            ),
          ),

          //for temp_basal_time:
          RaisedButton(
              child: Text(
                "Set Duration",
                style: TextStyle(fontSize: 20),
              ),
              color: Color(0xff212121),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Color(0xff212121))),
              textColor: Colors.white,
              onPressed: () {
                timeTap();
              }),

          RaisedButton(
              child: Text(
                "Set Temp Basal",
                style: TextStyle(fontSize: 20),
              ),
              color: Color(0xff03A9F4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Color(0xff1976D2))),
              textColor: Colors.white,
              onPressed: () async {
                checkNulls();
                print("new_basal_rate: $new_basal_rate");
                print("duration temp basal set for: $tempbasal_time");
                print('total seconds in int: $tempbasal_time_sec_total');
                //int values to string:
                intToString();
                //saving the data, to move to next page:
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.reload();
                prefs.setDouble('new_basal_rate', new_basal_rate);
                prefs.setString('tempbasal_sec_total',
                    tempbasal_sec_total); //to go to ESP 32. Arduino processes in milliseconds
                                //to set the countdown timer in next page:
                prefs.setString(
                    'tempbasal_min_only', tempbasal_min_only);
                prefs.setString('tempbasal_hr_only', tempbasal_hr_only);
                prefs.reload();
                //TODO: have a success message. Basal rate changed temporarily.And start timer

                //the next  fx go to basal page:
                makeTimer();

                Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new TempBasalScreen(),
                    ));

                //get the timestamp details (OF BUTTON CLICK):
                getBasalClickTime();

              }),

          //SecondBasalScreen(), //the going to this area from here interferes with the countdown
        ],
      ),
    );
  }
}

class SecondBasalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(
        "See Temp Basal State",
        style: TextStyle(fontSize: 20),
      ),
      color: Colors.white24,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Color(0xffBBDEFB))),
      textColor: Colors.white,
      onPressed: () {
        //to next page:
        Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => new TempBasalScreen(),
            ));
      },
    );
  }
}
