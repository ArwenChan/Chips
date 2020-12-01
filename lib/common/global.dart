import 'dart:convert';
import 'dart:io' show Platform;

import 'package:dict/common/purchase.dart';
import 'package:dict/models/list.dart';
import 'package:dict/common/api.dart' show fromLocal;
import 'package:dict/models/setting.dart';
import 'package:flutter/widgets.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info/package_info.dart';
import 'package:device_info/device_info.dart';

import '../models/profile.dart';

class Global {
  static SharedPreferences prefs;
  static Profile profile = Profile();
  static List<WordList> words;
  static var memorized;
  static int wordListIndex = 0;
  static PackageInfo packageInfo;
  static String deviceId;
  static String deviceInfoString;
  static bool needSave = true;
  static Purchase purchase;
  static int inDialog = 0;
  static String latestVersion;
  // static bool canListenCopy = false;

  static bool isRelease = bool.fromEnvironment("dart.vm.product");

  static Future init() async {
    debugPrint('-------init app---------');
    WidgetsFlutterBinding.ensureInitialized();
    InAppPurchaseConnection.enablePendingPurchases();
    purchase = Purchase();
    purchase.p.init();
    PackageInfo.fromPlatform().then((p) {
      packageInfo = p;
    });
    SharedPreferences.getInstance().then((instance) {
      prefs = instance;
      var _profile = prefs.getString("profile");
      debugPrint(_profile);
      if (_profile != null) {
        profile = Profile.fromJson(jsonDecode(_profile));
      }
      if (profile.settings == null) {
        profile.settings = Setting(
          tranlateInplace: true,
          tranlateInplaceWithPronunciation: true,
          pronunciation: 'BrE',
        );
      }
      getUniqueId();
    });
    var data = await fromLocal();
    words = data['words'];
    memorized = data['memorized'];
  }

  static saveProfile() =>
      prefs.setString("profile", jsonEncode(profile.toJson()));

  static getUniqueId() async {
    deviceId = prefs.getString("device");
    deviceInfoString = prefs.getString("deviceInfo");
    if (deviceInfoString == null) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        var androidInfo = await deviceInfo.androidInfo;
        var release = androidInfo.version.release;
        var sdkInt = androidInfo.version.sdkInt;
        var manufacturer = androidInfo.manufacturer;
        var model = androidInfo.model;
        deviceInfoString =
            'Android $release (SDK $sdkInt), $manufacturer $model';
        // Android 9 (SDK 28), Xiaomi Redmi Note 7
        deviceId = androidInfo.androidId;
      }

      if (Platform.isIOS) {
        var iosInfo = await deviceInfo.iosInfo;
        var systemName = iosInfo.systemName;
        var version = iosInfo.systemVersion;
        var name = iosInfo.name;
        var model = iosInfo.model;
        deviceInfoString = '$systemName $version, $name $model';
        // iOS 13.1, iPhone 11 Pro Max iPhone
        deviceId = iosInfo.identifierForVendor;
        debugPrint(deviceInfoString);
      }
      prefs.setString("device", deviceId);
      prefs.setString("deviceInfo", deviceInfoString);
    }
    // if (Platform.isAndroid && int.parse(deviceInfoString.split(' ')[1]) < 10) {
    //   canListenCopy = true;
    // }
  }
}
