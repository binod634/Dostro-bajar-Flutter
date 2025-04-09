import 'package:dostrobajar/services/userdata.dart';
import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  Userdata? _userdata;

  get userdata => _userdata;

  void setUserdata(Userdata? userdata) {
    _userdata = userdata;
    notifyListeners();
  }
}
