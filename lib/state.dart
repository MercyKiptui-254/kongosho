/// Here, we shall implement a change notifier.

import 'package:flutter/material.dart';

/// This class extends a [ChangeNotifier].
/// It will enable us to dynamically change and access data that shall be needed
/// across many screens in the app e.g. active insulin
class AppState extends ChangeNotifier {
  double _activeInsulin = 0.0;

  void setInsulinAmount(double amount) {
    _activeInsulin = amount;
    notifyListeners();
  }

  double get getInsulinAmount => _activeInsulin;
}
