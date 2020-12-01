import 'dart:async';
import 'package:dict/common/dialogs.dart';
import 'package:dict/common/global.dart';
import 'package:dict/models/user.dart';
import 'package:dict/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_kit/tencent_kit.dart';
import 'package:dict/common/api.dart' show thirdLogin;

class QQ extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _QQState();
  }
}

class _QQState extends State<QQ> {
  static const String _TENCENT_APPID = '101917384';

  Tencent _tencent = Tencent()..registerApp(appId: _TENCENT_APPID);
  StreamSubscription<TencentLoginResp> _login;

  @override
  void initState() {
    super.initState();
    _login = _tencent.loginResp().listen(_listenLogin);
  }

  void _listenLogin(TencentLoginResp resp) async {
    if (resp.isSuccessful()) {
      try {
        String result = '';
        showLoadingDialog(context, tips: '正在登录');
        dynamic loginResult = await thirdLogin('qq${resp.openid}', 'tencent');
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
    _login?.cancel();
    _login = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
      icon: new Tab(
        icon: new Image.asset("assets/qq.png", width: 25),
      ),
      label: Text('QQ登录', style: TextStyle(fontSize: 18)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        side: BorderSide(width: 1, color: Colors.black54),
      ),
      height: 48,
      minWidth: 226,
      onPressed: () {
        _tencent.login(
          scope: <String>[TencentScope.GET_SIMPLE_USERINFO],
        );
      },
    );
  }

  void qqInstalled() async {
    await _tencent.isQQInstalled();
  }
}
