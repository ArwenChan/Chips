import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/profile.dart';

class Global {
  static SharedPreferences _prefs;
  static Profile profile = Profile();

  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  static Future init() async {
    print(isRelease);
    _prefs = await SharedPreferences.getInstance();
    var _profile = _prefs.getString("profile");
    print(_profile);
    if (_profile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
      } catch (e) {
        print(e);
      }
    }
  }

  static saveProfile() =>
      _prefs.setString("profile", jsonEncode(profile.toJson()));
}
