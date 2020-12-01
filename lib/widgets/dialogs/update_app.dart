import 'dart:io';

import 'package:dict/common/api.dart' show getVersion;
import 'package:dict/common/dialogs.dart';
import 'package:dict/common/global.dart';
import 'package:dict/i10n/localizations.dart';
import 'package:dict/models/app_version.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:dict/widgets/dialogs/do_not_ask_again_dialog.dart';
import 'package:dict/common/constants.dart' show kUpdateDialogKeyName;

class UpdateApp extends StatefulWidget {
  final Widget child;

  UpdateApp({this.child});

  @override
  _UpdateAppState createState() => _UpdateAppState();
}

class _UpdateAppState extends State<UpdateApp> {
  @override
  void initState() {
    super.initState();

    checkLatestVersion(context);
  }

  checkLatestVersion(context) async {
    await Future.delayed(Duration(seconds: 2));

    getVersion().then((data) {
      AppVersion appVersion = AppVersion.fromJson(data);
      Version minAppVersion = Version.parse(appVersion.minVersion);
      Version latestAppVersion = Version.parse(appVersion.latest);
      Global.latestVersion = appVersion.latest;
      Version currentVersion = Version.parse(Global.packageInfo.version);
      if (minAppVersion > currentVersion) {
        _showCompulsoryUpdateDialog(
          context,
          "Please update the app to continue\n",
        );
      } else if (latestAppVersion > currentVersion) {
        bool showUpdates;
        showUpdates = Global.prefs.getBool(kUpdateDialogKeyName);
        if (showUpdates == false) {
          return;
        }

        _showOptionalUpdateDialog(
          context,
          "A newer version of the app is available\n",
        );
        debugPrint('Update available');
      } else {
        debugPrint('App is up to date');
      }
    }).catchError((error) {
      debugPrint(error.toString());
    });
  }

  _showOptionalUpdateDialog(context, String message) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        String title = "App Update Available";
        String btnLabel = "Update Now";
        String btnLabelCancel = "Later";
        String btnLabelDontAskAgain = "Don't ask me again";
        return DoNotAskAgainDialog(
          kUpdateDialogKeyName,
          title,
          message,
          btnLabel,
          btnLabelCancel,
          _onUpdateNowClicked,
          doNotAskAgainText:
              Platform.isIOS ? btnLabelDontAskAgain : 'Never ask again',
        );
      },
    );
  }

  _onUpdateNowClicked() {
    debugPrint('On update app clicked');
    LaunchReview.launch(
      // TODO: Android play store 不能使用.
      writeReview: false,
      androidAppId: "com.iyaffle.kural",
      iOSAppId: "585027354",
    );
  }

  _showCompulsoryUpdateDialog(context, String message) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "App Update Available";
        String btnLabel = "Update Now";
        return Platform.isIOS
            ? new CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(
                      btnLabel,
                    ),
                    isDefaultAction: true,
                    onPressed: _onUpdateNowClicked,
                  ),
                ],
              )
            : new AlertDialog(
                title: Text(
                  title,
                  style: TextStyle(fontSize: 22),
                ),
                content: Text(message),
                actions: <Widget>[
                  FlatButton(
                    child: Text(btnLabel),
                    onPressed: _onUpdateNowClicked,
                  ),
                ],
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
