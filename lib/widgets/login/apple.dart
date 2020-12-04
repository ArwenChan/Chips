import 'package:dict/common/dialogs.dart';
import 'package:dict/common/global.dart';
import 'package:dict/models/user.dart';
import 'package:dict/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:dict/common/api.dart' show thirdLogin;

class Apple extends StatefulWidget {
  @override
  _AppleState createState() => _AppleState();
}

class _AppleState extends State<Apple> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 235,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black54),
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: SignInWithAppleButton(
        height: 48,
        style: SignInWithAppleButtonStyle.white,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        onPressed: () async {
          try {
            final AuthorizationCredentialAppleID credential =
                await SignInWithApple.getAppleIDCredential(
              scopes: [
                AppleIDAuthorizationScopes.email,
                AppleIDAuthorizationScopes.fullName,
              ],
            );
            String result = '';
            showLoadingDialog(context, tips: '正在登录');
            dynamic loginResult =
                await thirdLogin('apple${credential.userIdentifier}', 'apple');
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
            if (e.runtimeType == SignInWithAppleAuthorizationException) {
              showResultDialog(context, '授权失败');
            } else {
              showResultDialog(context, '登录失败');
            }
            Future.delayed(Duration(seconds: 2), () {
              closeDialog(context);
            });
          }
        },
      ),
    );
  }
}
