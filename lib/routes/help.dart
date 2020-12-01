import 'dart:async' show Completer;
import 'dart:io' show Platform;

import 'package:dict/common/constants.dart' show HOST;
import 'package:flutter/cupertino.dart';
import 'package:dict/i10n/localizations.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DefaultLocalizations.of(context).features),
        backgroundColor: Colors.grey[300],
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
      ),
      body: WebView(
        initialUrl: '$HOST/feature',
        initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
