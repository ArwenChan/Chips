import 'package:dict/common/global.dart';

class Validators {
  static final _email = new RegExp(r'^[\w\d_]+@[\w\d_.]+$');
  static final _pwd = new RegExp(r'^[0-9]{6}$');

  static bool isEmail(String str) {
    return _email.hasMatch(str.toLowerCase());
  }

  static bool validatePassword(String str) {
    if (!Global.isRelease) {
      return RegExp(r'[a-z0-9]+').hasMatch(str.toLowerCase());
    }
    return _pwd.hasMatch(str.toLowerCase());
  }
}
