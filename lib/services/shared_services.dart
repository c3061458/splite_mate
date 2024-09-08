import 'package:shared_preferences/shared_preferences.dart';

class SharedServices {

  Future getData(String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cache = prefs.getString(data);
    return cache;
  }

  Future<void> setData(String title, String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(title, data);
  }
}