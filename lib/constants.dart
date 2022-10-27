import 'dart:isolate';

/// This file contains all the routing constants used within the app
const String firstPage = '/';
const String secondPage = '/second';
const String bolusPage = '/bolus';
const String basalPage = '/basal';
const String settingsPage = '/setting';
const String temp_basalPage = '/temp_basal';
const String bolus_deliveredPage = '/bolus_delivered';

//for BG service:
/// The name associated with the UI isolate's [SendPort].
const String isolateName = 'isolate';
/// A port used to communicate from a background isolate to the UI isolate.
//final ReceivePort port = ReceivePort();
