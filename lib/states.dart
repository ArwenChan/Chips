import 'package:flutter/material.dart';

import './common/global.dart';
import './models/profile.dart';
import './models/user.dart';

class ProfileChangeNotifier extends ChangeNotifier {
  Profile get _profile => Global.profile;

  @override
  void notifyListeners() {
    Global.saveProfile();
    super.notifyListeners();
  }
}

class UserState extends ProfileChangeNotifier {
  User get user => _profile.user;

  bool get isLogin => user != null;

  set user(User user) {
    if (user?.email != _profile.user?.email) {
      _profile.lastLogin = _profile.user?.email;
      _profile.user = user;
      notifyListeners();
    }
  }
}
