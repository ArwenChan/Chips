import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'common/global.dart';
import 'states.dart';
import 'routes/home.dart';
import 'routes/login.dart';

void main() => Global.init().then((e) => runApp(MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider.value(value: UserState())],
        child: Consumer<UserState>(
            builder: (BuildContext context, userState, Widget child) {
          return MaterialApp(
            theme: ThemeData(primaryColor: Colors.green),
            home: HomePage(),
            routes: <String, WidgetBuilder>{"login": (context) => LoginPage()},
          );
        }));
  }
}
