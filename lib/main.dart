import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kongosho/constants.dart';
import 'package:kongosho/basal.dart';
import 'package:kongosho/state.dart';
import 'package:provider/provider.dart';
import 'router.dart' as router;
import 'package:shared_preferences/shared_preferences.dart';
import 'data/moor_database.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'dart:isolate';
import 'dart:ui';
import 'dart:math';
import 'package:moor/isolate.dart';
import 'package:moor/moor.dart' as moor;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.reload();
  // if (!prefs.containsKey('basal_rate')) {
  //   prefs.setDouble('basal_rate', 1.6);
  //   print('no basal rate found, 1.6 U set/hr');
  // }
  await AndroidAlarmManager.initialize();
  runApp(MyApp());
  await AndroidAlarmManager.periodic(const Duration(minutes: 1), 0, printHello,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
      startAt: DateTime.now());
  await AndroidAlarmManager.periodic(
      const Duration(minutes: 1), 33, basalBackground,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
      startAt: DateTime.now());
}

void printHello() async {
  try {
  // create a moor executor in a new background isolate. If you want to start the isolate yourself, you
  // can also call MoorIsolate.inCurrent() from the background isolate
  MoorIsolate isolate = await MoorIsolate.inCurrent(backgroundConnection);

  // we can now create a database connection that will use the isolate internally. This is NOT what's
  // returned from _backgroundConnection, moor uses an internal proxy class for isolate communication.
  moor.DatabaseConnection connection = await isolate.connect();

  final db = AppDatabase.connect(connection);
  var activeInsulin = 0.0;
    var records = await db.bolusRecordDao.getAllBolusRecords();
    for (var record in records) {
      if (record.timeStamp
          .isAfter(DateTime.now().subtract(Duration(hours: 4)))) {
        activeInsulin += record.bolusAmount;
      }
    }
    SendPort sendPort = IsolateNameServer.lookupPortByName(isolateName);
    print("Active Insulin Sending task is being called, value:$activeInsulin");
    if (activeInsulin == 0 || activeInsulin == null) {
      activeInsulin = 0;
    }
    sendPort?.send(activeInsulin);
    db.close();//to prevent multiple db constructors
    
  } catch (err) {
    print("Error retrieving Active Insulin from the database:\n $err");
  }
  // you can now use your database exactly like you regularly would, it transparently uses a
  // background isolate internally
}

correctBasal() async {
  double deliver_basal = 0.0;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.reload();
  if (!prefs.containsKey('basal_rate')) {
    await prefs.setDouble('basal_rate', 1.6);
    print('no basal rate found, 1.6 U set/hr');
  }
  bool CheckValue = prefs.containsKey(
      'new_basal_rate'); //checking if the value is present in SF. Will return true if persistent storage contains the given key and false if not.
  print('Is new basal there? $CheckValue'); //WORKS

  if (CheckValue == true) {
    deliver_basal = prefs.getDouble('new_basal_rate');
  } else {
    deliver_basal = prefs.getDouble('basal_rate');
  }
  return deliver_basal;
}

//inserting row into basal table:
Future<dynamic> addBasal(double deliver_basal) async {
  MoorIsolate isolate = await MoorIsolate.inCurrent(backgroundConnection);
  moor.DatabaseConnection connection = await isolate.connect();
  final db = AppDatabase.connect(connection);
  final basalRecord = BasalRecordsCompanion(
    basalAmount: moor.Value(deliver_basal),
    timeStamp: moor.Value(DateTime.now()),
  );

  db.basalRecordDao.insertBasalRecord(basalRecord).then((value) => db.close()).catchError((err) {
    print("Error storing Basal Record in DB: $err");
    db.close();
  });
  
}

basalBackground() async {
  try {
    double deliver_basal = await correctBasal() ?? 0.0;
    print('deliver basal from SF:$deliver_basal');

    //TODO:send to BLE. If successful, store in db
    //send to BLE, 'then'. add to db
    addBasal(deliver_basal);
  } catch (err) {
    print("Error carrying out the basal background fx:\n $err");
  }
}

//let stateless widget hold mainly the UI
class MyApp extends StatelessWidget {
  final AppDatabase db = AppDatabase();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MaterialApp(
        onGenerateRoute: router.Router.generateRoute,
        initialRoute: firstPage,
      ),
      providers: [
        Provider<BolusRecordDao>(create: (_) => db.bolusRecordDao),
        Provider<BasalRecordDao>(create: (_) => db.basalRecordDao),
        ChangeNotifierProvider<AppState>(create: (_) => AppState()),
        //change notifier provider lets me update different screens with the same data.Let us set the activeInsulin to this
      ],
    );
  }
}

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  SharedPreferences prefs; //Global variable

  //provider that listens to changes made:
  AppState appState;

  @override
  void initState() {
    super.initState();

    // SharedPreferences.getInstance().then((value) { if (mounted){
    //  setState(() {
    //    prefs = value;
    //  });
    // }});
  }

  @override
  BuildContext get context => super.context;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appState = Provider.of<AppState>(context);
  }

  //setting activeInsulin to shared preferences(SF):
  // activeInsulinAmountSF() async {
  //   print("Random task is being called");
  //   var activeInsulin = 0.0;
  //   try {
  //     activeInsulin = await _activeInsulinAmount(context);
  //     if (activeInsulin == 0 || activeInsulin == null) {
  //       activeInsulin = 0;
  //     }
  //   } catch (err) {
  //     print('err DB to SF');
  //   }
  //   print('Active Insulin: $activeInsulin');
  //   appState.setInsulinAmount(
  //       activeInsulin); //NOTE: Making the data available in all screens
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Kongosho')),
        backgroundColor: Color(0xff0288d1), //hex code:#0288D1
      ),
      backgroundColor: Color(0xff03a9f4),
      // hex code: #03A9F4
      // HACK: append Color(0x(this is a letter)ff____then the code (si lazima iwe lowercase),remove the #),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
            child: Center(
              child: Text(
                "Kongosho",
                style: TextStyle(
                    fontFamily: 'Pacifico', fontSize: 30, color: Colors.white),
              ),
            ),
          ),
          Center(
              child: Text("the support application",
                  style: TextStyle(fontSize: 15, color: Color(0xffBDBDBD)))),
          SizedBox(
            height: 50,
          ),
          RaisedButton(
            padding: const EdgeInsets.all(8.0),
            color: Color(0xffB3E5FC),
            child: Text(
              "Karibu",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            onPressed: () async {
              Navigator.of(context).pushNamed('/second');
            },
          )
        ],
      ),
    );
  }
}
