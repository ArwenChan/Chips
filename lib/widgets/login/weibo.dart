import 'dart:async';
import 'package:dict/common/dialogs.dart';
import 'package:dict/common/global.dart';
import 'package:dict/models/user.dart';
import 'package:dict/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weibo_kit/weibo_kit.dart';
import 'package:dict/common/api.dart' show thirdLogin;

class WeiBo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WeiBoState();
  }
}

class _WeiBoState extends State<WeiBo> {
  static const String _WEIBO_APP_KEY = '1523942230';
  static const List<String> _WEIBO_SCOPE = <String>[
    WeiboScope.ALL,
  ];

  Weibo _weibo = Weibo()
    ..registerApp(
      appKey: _WEIBO_APP_KEY,
      scope: _WEIBO_SCOPE,
    );

  StreamSubscription<WeiboAuthResp> _auth;

  WeiboAuthResp _authResp;

  @override
  void initState() {
    super.initState();
    _auth = _weibo.authResp().listen(_listenAuth);
  }

  void _listenAuth(WeiboAuthResp resp) async {
    _authResp = resp;
    if (resp.errorCode == 0) {
      try {
        String result = '';
        showLoadingDialog(context, tips: '正在登录');
        dynamic loginResult =
            await thirdLogin('wb${_authResp.userId}', 'weibo');
        User user = loginResult['user'];
        bool existed = loginResult['existed'];
        closeDialog(context);
        showResultDialog(context, '登录成功', isError: false);
        Provider.of<UserState>(context, listen: false).user = user;
        String lastLogin = Global.profile.lastLogin;
        if (user.username != lastLogin && existed) {
          result = 'remote';
        } else if (lastLogin != null && !existed) {
          result = 'local';
        }
        Future.delayed(Duration(seconds: 1), () {
          closeDialog(context);
        });
        Future.delayed(Duration(milliseconds: 1200), () {
          Navigator.pop(context, result);
        });
      } catch (e) {
        closeDialog(context);
        showResultDialog(context, '登录失败');
        Future.delayed(Duration(seconds: 2), () {
          closeDialog(context);
        });
      }
    } else {
      showResultDialog(context, '授权失败');
      Future.delayed(Duration(seconds: 2), () {
        closeDialog(context);
      });
    }
  }

  @override
  void dispose() {
    if (_auth != null) {
      _auth.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
      icon: new Tab(
        icon: new Image.asset("assets/weibo.png", width: 30),
      ),
      color: Colors.white,
      label: const Text('微博登录', style: TextStyle(fontSize: 18)),
      shape: const RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        side: const BorderSide(width: 1, color: Colors.black54),
      ),
      height: 48,
      minWidth: 235,
      onPressed: () {
        _weibo.auth(
          appKey: _WEIBO_APP_KEY,
          scope: _WEIBO_SCOPE,
        );
      },
    );
  }

  void weiboInstalled() async {
    await _weibo.isInstalled();
  }
}
