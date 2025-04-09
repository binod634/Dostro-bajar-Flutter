import 'package:dostrobajar/services/userdata.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileProvider extends ChangeNotifier {
  Userdata? _userdata;
  final supabaseclient = Supabase.instance.client;

  get userdata => _userdata;

  void getUserdata() async {
    final currentuserdata = supabaseclient.auth.currentUser;
    final datas = await supabaseclient
        .from("users")
        .select()
        .eq("email", currentuserdata?.email ?? '');
    print(datas);
    if (datas.isNotEmpty) {
      setUserdata(Userdata.fromJson(datas.first));
    }
  }

  void setUserdata(Userdata? userdata) {
    _userdata = userdata;
    notifyListeners();
  }
}
