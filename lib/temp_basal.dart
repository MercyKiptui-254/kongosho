import 'dart:async'; // when added package, affected flutter_test. said was disabled due to added package's greater version. I downgraded version
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'basal.dart';
import 'constants.dart';
//import 'package:flutter_countdown_timer/countdown_timer.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:vsync_provider/vsync_provider.dart';



class TempBasalScreen extends StatelessWidget {
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
          title: Center(child: Text('Temp Basal Delivered')),
        ),

        body: TempDelivered(),
      ),
    );
  }
}

class TempDelivered extends StatefulWidget {
  TempDelivered({Key key}) : super(key: key);

  @override
  _TempDeliveredState createState() => _TempDeliveredState();
}

class _TempDeliveredState extends State<TempDelivered> with SingleTickerProviderStateMixin {
  //getting values from SharedPreferences:

  Future<List> getValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double basal_rate = prefs.getDouble('basal_rate') ?? 1.6;
    double new_basal_rate = prefs.getDouble('new_basal_rate') ?? 5.7;
    String tempbasal_sec_total =
        prefs.getString('tempbasal_sec_total') ?? '0'; // is the TOTAL time
    String tempbasal_min_only = prefs.getString('tempbasal_min_only') ?? '0';
    String tempbasal_hr_only = prefs.getString('tempbasal_hr_only') ?? '0';

    return [
      basal_rate,
      new_basal_rate,
      tempbasal_sec_total,
      tempbasal_min_only,
      tempbasal_hr_only,
    ];
  }

  //variables:
  num basal_rate;

  //for the db and BLE:
  num tempbasal_time_sec_total; //NOTE:is the TOTAL time in seconds
  //for countdown timer:
  num tempbasal_time_hrOnly;
  num tempbasal_time_minOnly;
  num new_basal_rate; //let me remove this

  Duration tempbasal_time;

  Duration
      tempbasal_sec_total_dur; //for the background timer, converts the seconds total to duration (SharedPrefs canNOT transfer a duration, had to break down to num)

  String tempbasal_sec_total;
  String tempbasal_hr_only;
  String tempbasal_min_only;

  num deliver_basal;
  bool CheckValue;
  AnimationController _controller;

  void initState() {
    //NEVER put initstate in build fx
    super.initState();
    getValuesSF().then((value) {
      setState(() {
        basal_rate = value[0];
        new_basal_rate = value[1];
        tempbasal_sec_total = value[2];
        tempbasal_min_only = value[3];
        tempbasal_hr_only = value[4];
      });
    }).catchError((err) {
      print(' there is an SF import issue $err');
    }); //will print the error.

    _controller =
        AnimationController(vsync: this, duration: Duration(minutes: 5));
    _controller.forward();


  }

//show time:
  showTime() {
    print("seconds carried forward: $tempbasal_sec_total");
    print('min carried forward: $tempbasal_min_only');
    print('hr carried forward: $tempbasal_hr_only');

    print('new basal: $new_basal_rate');
    print('old basal: $basal_rate');
  }

  //assembling the temp basal time: NEED TO CALL IT IN THE WIDGET CODE
  assembleTime() {
    tempbasal_time_minOnly = num.tryParse(tempbasal_min_only);
    tempbasal_time_hrOnly = num.tryParse(tempbasal_hr_only);
    tempbasal_time = Duration(
        hours: tempbasal_time_hrOnly,
        minutes: tempbasal_time_minOnly,
        seconds: 0);

    //return tempbasal_time;
    tempbasal_time_sec_total = num.tryParse(tempbasal_sec_total);
    tempbasal_sec_total_dur = Duration(seconds: tempbasal_time_sec_total);
    print('time: $tempbasal_time');
    print('seconds time: $tempbasal_sec_total_dur');
    //NOTE, HAVE FOUND THAT tempbasal_time=tempbasal_sec_total_dur in duration
  }

  presentValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CheckValue = prefs.containsKey(
        'new_basal_rate'); //checking if the value is present in SF. Will return true if persistent storage contains the given key and false if not.
    print(CheckValue); //WORKS
    correctAnswer();
  }

  Widget correctAnswer(){
    if (CheckValue == true){
     return Center(child: Text("Temp Basal Status: Active", style: TextStyle(color: Colors.blueAccent, fontSize: 20)));
   }
   else{
     return Center(child: Text ("Temp Basal Status: Unactive", style: TextStyle(color: Colors.blueAccent, fontSize: 20),));
   }
  }

  num getSecs(){
    String source = tempbasal_sec_total.trim();
    tempbasal_time_sec_total = num.tryParse(source);
    return tempbasal_time_sec_total;
  }

//
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        //displaying current temp basal rate
        Center(
          child: Container(
            color: Color (0xff1976D2),
            child: Text(
              'Your temporary basal rate is: $new_basal_rate U/hr, duration as shown below:',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),

        Container(
          height:150,
          child: Center(
            child: Countdown(
              animation: StepTween(
                begin: getSecs(), // convert to seconds here
                end: 0,
              ).animate(_controller),
            ),
          ),
        ),

        RaisedButton(
          //was used for prototyping.
          child: Text('See Temp Basal Details'),
          color:Color (0xff1976D2),
          onPressed: () {
            showTime();
            assembleTime();
            presentValue();
            return Text(' Is the Temp Basal Active? $CheckValue, Basal original time $tempbasal_time');//not working
          },

        ),

//correctAnswer(),//TODO: Do manual refresh button instead of Raised Button above, so that CorrectAnswer works

        //RaisedButton(
          //was used for prototyping.
          //child: Text('Is Temp Basal Active?'),
          //color:Color (0xff1976D2),
          //onPressed: () {
           // presentValue();

          //},
        //),



      ],
    );
  }

@override
void dispose() {
  _controller.dispose();
  super.dispose();
}
}

class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inHours.remainder(60).toString()}:${clockTimer.inMinutes.remainder(60).toString()}:${(clockTimer.inSeconds.remainder(60) % 60).toString().padLeft(2, '0')}';

    return Text(
      "$timerText",
      style: TextStyle(
        fontSize: 110,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}

