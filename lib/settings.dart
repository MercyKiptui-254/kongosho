import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:moor/moor.dart' as moor;
import 'package:kongosho/data/moor_database.dart';
import 'package:moor/isolate.dart';

class SettingsScreen extends StatelessWidget {
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
          title: Center(child: Text('Settings')),
        ),

        body: SettingsForm(),
      ),
    );
  }
}

class SettingsForm extends StatefulWidget {
  SettingsForm({Key key}) : super(key: key);

  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  //variables and default initial values:
  //TODO: the default should be the prior setting (level 2)
  num basal_rate = 1.6; //TODO: add for different times, different values
  num sensitivity = 1.5;
  num carb_ratio =
      6.4; //this is insulin to carb ratio //TODO: add for different times, different values
  num high_BG = 7.8; //this is the high target of BG
  num low_BG = 5.7; //this is the low target of BG
  num max_Bolus; //max allowed Bolus

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        //basal_rate field:
        TextField(
          onChanged: (text1) {
            setState(() {
              basal_rate = num.tryParse(text1);
            });
          },
          keyboardType:
              TextInputType.numberWithOptions(signed: false, decimal: true),
          //basal rate is eg 1.6, decimal but not signed
          textAlign: TextAlign.center,
          maxLength: 3,
          style: TextStyle(
            fontSize: 20.0,
            color: Color(0xff1976D2),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white24,
            icon: Icon(Icons.settings),
            labelText: "Basal Rate",
            helperText: 'Input your normal basal rate (U/Hr)',
            counterText: '3 characters',
            contentPadding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
            border: const OutlineInputBorder(),
          ),
        ),

        //sensitivity ratio field:
        TextField(
          onChanged: (text) {
            sensitivity = num.tryParse(text);
          },
          keyboardType:
              TextInputType.numberWithOptions(signed: false, decimal: true),
          //basal rate is eg 1.6, decimal but not signed
          textAlign: TextAlign.center,
          maxLength: 3,
          style: TextStyle(
            fontSize: 20.0,
            color: Color(0xff1976D2),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white24,
            icon: Icon(Icons.settings),
            labelText: "Sensitivity Ratio",
            helperText: 'Input your insulin sensitivity (mmol/L per U)',
            counterText: '3 characters',
            contentPadding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
            border: const OutlineInputBorder(),
          ),
        ),

        // carb to insulin ratio field:
        TextField(
          onChanged: (text) {
            carb_ratio = num.tryParse(text);
          },
          keyboardType:
              TextInputType.numberWithOptions(signed: false, decimal: true),
          //basal rate is eg 1.6, decimal but not signed
          textAlign: TextAlign.center,
          maxLength: 3,
          style: TextStyle(
            fontSize: 20.0,
            color: Color(0xff1976D2),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white24,
            icon: Icon(Icons.settings),
            labelText: "Carb Ratio",
            helperText: 'Input your carbohydrate to insulin ratio (g/U)',
            counterText: '3 characters',
            contentPadding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
            border: const OutlineInputBorder(),
          ),
        ),

        //high BG limit field:
        TextField(
          onChanged: (text) {
            high_BG = num.tryParse(text);
          },
          keyboardType:
              TextInputType.numberWithOptions(signed: false, decimal: true),
          //basal rate is eg 1.6, decimal but not signed
          textAlign: TextAlign.center,
          maxLength: 4,
          style: TextStyle(
            fontSize: 20.0,
            color: Color(0xff1976D2),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white24,
            icon: Icon(Icons.settings),
            labelText: "High Limit BG",
            helperText: 'Input your High BG target (mmol/L)',
            counterText: '4 characters',
            contentPadding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
            border: const OutlineInputBorder(),
          ),
        ),

        //low BG limit field:
        TextField(
          onChanged: (text) {
            low_BG = num.tryParse(text);
          },
          keyboardType:
              TextInputType.numberWithOptions(signed: false, decimal: true),
          //basal rate is eg 1.6, decimal but not signed
          textAlign: TextAlign.center,
          maxLength: 4,
          style: TextStyle(
            fontSize: 20.0,
            color: Color(0xff1976D2),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white24,
            icon: Icon(Icons.settings),
            labelText: "Low Limit BG",
            helperText: 'Input your low BG target (mmol/L)',
            counterText: '4 characters',
            contentPadding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
            border: const OutlineInputBorder(),
          ),
        ),

        //max Bolus field:
        TextField(
          onChanged: (text) {
            max_Bolus = num.tryParse(text);
          },
          keyboardType:
              TextInputType.numberWithOptions(signed: false, decimal: true),
          //basal rate is eg 1.6, decimal but not signed
          textAlign: TextAlign.center,
          maxLength: 4,
          style: TextStyle(
            fontSize: 20.0,
            color: Color(0xff1976D2),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white24,
            icon: Icon(Icons.settings),
            labelText: "Max Bolus",
            helperText: 'Maximum allowed Bolus (U)',
            counterText: '4 characters',
            contentPadding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
            border: const OutlineInputBorder(),
          ),
        ),

        RaisedButton(
          child: Text("Change Your Settings"),
          color: Color(0xff1976D2),
          textColor: Colors.white,
          onPressed: () async {
            print("Basal rate: $basal_rate");
            print("Sensitivity: $sensitivity");
            print("Carb ratio: $carb_ratio");
            print("High BG: $high_BG");
            print("Low BG: $low_BG");
            print("Max Bolus: $max_Bolus");

            // for basal_rate:
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.reload();
            prefs.setDouble('basal_rate', basal_rate);
            prefs.setDouble('sensitivity', sensitivity);
            prefs.setDouble('carb_ratio', carb_ratio);
            prefs.setDouble('high_BG', high_BG);
            prefs.setDouble('low_BG', low_BG);
            prefs.setDouble('max_Bolus', max_Bolus);
            prefs.reload();

          },
        ),
      ],
    );
  }


}
