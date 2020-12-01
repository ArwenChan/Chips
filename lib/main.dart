import 'dart:async';
import 'dart:io' show Platform;

import 'package:dict/i10n/localizations.dart';
import 'package:dict/routes/help.dart';
import 'package:dict/routes/login.dart';
import 'package:dict/routes/privacy.dart';
import 'package:dict/routes/setting.dart';
import 'package:dict/widgets/dialogs/update_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sentry/sentry.dart';

import 'common/global.dart';
import 'states.dart';
import 'routes/home.dart';

final sentry = SentryClient(
    dsn:
        "https://fa9f19e608a448ce866b303083a6cb6f@o207451.ingest.sentry.io/1327595");

void main() async {
  runZonedGuarded(
    () => Global.init().then((e) {
      runApp(MyApp());
    }),
    (error, stackTrace) async {
      if (Global.isRelease) {
        await sentry.captureException(
          exception: error,
          stackTrace: stackTrace,
        );
      }
    },
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    List<String> localeInfo = Platform.localeName.split('_');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: UserState()),
        ChangeNotifierProvider.value(value: DataSheet()),
        ChangeNotifierProvider.value(value: UserSetting()),
      ],
      child: Consumer<UserState>(
          builder: (BuildContext context, userState, Widget child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            DefaultLocalizationsDelegate(),
          ],
          supportedLocales: [
            const Locale('en'), // 英语
            const Locale('zh', 'CN'), // 中文简体
            //其它Locales
          ],
          locale: Locale(localeInfo.first, localeInfo.last),
          theme: ThemeData(primaryColor: Colors.greenAccent[700]),
          routes: <String, WidgetBuilder>{
            "/": (context) => Consumer2<DataSheet, UserSetting>(builder:
                    (BuildContext context, dataSheet, userSetting,
                        Widget child) {
                  return UpdateApp(child: HomePage());
                }),
            "login": (context) => Consumer<UserState>(
                    builder: (BuildContext context, userState, Widget child) {
                  return LoginPage();
                }),
            "settings": (context) => Consumer2<UserState, UserSetting>(builder:
                    (BuildContext context, userState, userSetting,
                        Widget child) {
                  return SettingPage();
                }),
            "privacy": (context) => PrivacyPage(),
            "help": (context) => HelpPage(),
          },
        );
      }),
    );
  }
}
