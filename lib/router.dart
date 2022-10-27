import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kongosho/bolus1.dart';
import 'package:kongosho/bolus_delivered.dart';
import 'package:kongosho/temp_basal.dart';
import 'constants.dart';

//NOTE: put all the screen files HERE
import 'main.dart';
import 'second.dart';
import 'basal.dart';
import 'bolus1.dart';
import 'settings.dart';
import 'bolus_delivered.dart';
import 'temp_basal.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    // We will use this to validate screen to be shown by checking if it is of right type for respective screen
    // If not of proper type, we'll show an error screen
    final arguments = settings.arguments;
      switch (settings.name) {
        case firstPage:
          return MaterialPageRoute(builder: (BuildContext context) => FirstScreen());
        case secondPage:
          return MaterialPageRoute(builder: (BuildContext context) => SecondScreen());
        case bolusPage:
          return MaterialPageRoute(builder: (BuildContext context) => BolusPage());
        case basalPage:
          return MaterialPageRoute(builder: (BuildContext context) => BasalScreen());
        case settingsPage:
          return MaterialPageRoute(builder: (BuildContext context) => SettingsScreen());
        case bolus_deliveredPage:
          return MaterialPageRoute(builder: (BuildContext context) => BolusDeliveredScreen());
        case temp_basalPage:
          return MaterialPageRoute(builder: (BuildContext context) => TempBasalScreen());
        default:
          return MaterialPageRoute(
              builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));

    }

  }
}

