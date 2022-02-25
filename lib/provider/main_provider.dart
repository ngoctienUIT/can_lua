import 'package:flutter/cupertino.dart';

class MainProvider extends ChangeNotifier {
  String _name = '';
  String _id = '';

  String get name => _name;

  set name(value) {
    _name = value;
    notifyListeners();
  }

  String get id => _id;

  set id(value) {
    _id = value;
    notifyListeners();
  }
}
