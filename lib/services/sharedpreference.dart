import 'package:shared_preferences/shared_preferences.dart';

class SharedStorageHelper {
  static const firstTimeStoragekey = "724f8ed29c15f7ff46fc340165ce0c2b";

  static isFirstTimeUser() async {
    SharedPreferences sharedpreferences = await SharedPreferences.getInstance();
    bool data = sharedpreferences.getBool(firstTimeStoragekey) ?? true;
    return data;
  }

  static setFirstTimeUser({bool value = false}) async {
    SharedPreferences sharedpreferences = await SharedPreferences.getInstance();
    sharedpreferences.setBool(firstTimeStoragekey, value);
  }
}
