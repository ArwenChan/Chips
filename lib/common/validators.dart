class Validators {
  static final _email = new RegExp(r'[\w\d_]+@[\w\d_.]+');
  static final _pwd = new RegExp(r'[a-z,0-9]*[0-9]+[a-z]+');

  static bool isEmail(String str) {
    return _email.hasMatch(str.toLowerCase());
  }

  static bool validatePassword(String str) {
    return _pwd.hasMatch(str.toLowerCase());
  }
}
