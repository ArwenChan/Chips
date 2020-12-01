import 'package:dict/common/dialogs.dart';
import 'package:dict/common/dialogs.dart' show showLoadingDialog, showToast;
import 'package:dict/common/exception.dart';
import 'package:dict/common/global.dart';
import 'package:dict/common/validators.dart';
import 'package:dict/common/api.dart' show forgetpsw, login, register;
import 'package:dict/i10n/localizations.dart';
import 'package:dict/models/user.dart';
import 'package:dict/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class Email extends StatefulWidget {
  final AnimationController controller;
  Email({Key key, this.controller});
  @override
  _EmailState createState() => _EmailState();
}

class _EmailState extends State<Email> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  TextEditingController _pwdConfirmController = new TextEditingController();
  bool pwdShow = false;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  GlobalKey<FormFieldState> _formFieldKey = new GlobalKey<FormFieldState>();
  bool isRegister = false;
  bool infocus = false;

  @override
  void initState() {
    if (Global.profile.lastLogin != null &&
        Global.profile.lastLogin.contains('@')) {
      _nameController.text = Global.profile.lastLogin;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(children: <Widget>[
                  Padding(
                    child: Icon(Icons.email),
                    padding: const EdgeInsets.fromLTRB(0, 20, 30, 0),
                  ),
                  Expanded(
                    child: TextFormField(
                      key: _formFieldKey,
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "",
                      ),
                      validator: (v) {
                        return Validators.isEmail(v.trim()) ? null : "邮箱格式不正确";
                      },
                    ),
                  ),
                ]),
                Row(children: <Widget>[
                  Padding(
                    child: Icon(Icons.lock),
                    padding: const EdgeInsets.fromLTRB(0, 20, 30, 0),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _pwdController,
                      decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "six digits",
                          suffixIcon: IconButton(
                            icon: Icon(pwdShow
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                pwdShow = !pwdShow;
                              });
                            },
                          )),
                      obscureText: !pwdShow,
                      validator: (v) {
                        return Validators.validatePassword(v.trim())
                            ? null
                            : "密码须是6位数字";
                      },
                    ),
                  ),
                ]),
                confirmButton(),
                signinWidget(),
                bottomWidget(),
                otherLogin(),
              ],
            ),
          )),
    );
  }

  Widget confirmButton() {
    if (isRegister) {
      return Row(children: <Widget>[
        Padding(
          child: Icon(Icons.lock),
          padding: const EdgeInsets.fromLTRB(0, 20, 30, 0),
        ),
        Expanded(
          child: TextFormField(
            controller: _pwdConfirmController,
            decoration: InputDecoration(
                labelText: "Confirm Password",
                hintText: "",
                suffixIcon: IconButton(
                  icon: Icon(pwdShow ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      pwdShow = !pwdShow;
                    });
                  },
                )),
            obscureText: !pwdShow,
            validator: (v) {
              return v.trim() == _pwdController.text.trim() ? null : '密码不一致';
            },
          ),
        ),
      ]);
    } else {
      return Text('', style: TextStyle(fontSize: 0));
    }
  }

  Widget bottomWidget() {
    return ConstrainedBox(
      constraints: const BoxConstraints.expand(height: 55.0),
      child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          color: Theme.of(context).primaryColor,
          onPressed: isRegister ? _onSignin : _onLogin,
          textColor: Colors.white,
          child: Text(
              isRegister
                  ? DefaultLocalizations.of(context).signup
                  : DefaultLocalizations.of(context).login,
              style: TextStyle(fontSize: 20))),
    );
  }

  Widget signinWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            child: Text(
              DefaultLocalizations.of(context).forgetPassword,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onPressed: () async {
              //  TODO:忘记密码操作
              if (_formFieldKey.currentState.validate()) {
                String email = _nameController.text.trim();
                try {
                  await forgetpsw(email);
                  showResultDialog(context, '请在邮箱中完成', isError: false);
                  Future.delayed(Duration(seconds: 2), () {
                    closeDialog(context);
                  });
                } on CustomException catch (e) {
                  primaryFocus?.unfocus();
                  showResultDialog(context, e.toString());
                  Future.delayed(Duration(seconds: 2), () {
                    closeDialog(context);
                  });
                } catch (e) {
                  showToast(context, e.toString(), true);
                }
              }
            },
          ),
          FlatButton(
            padding: EdgeInsets.zero,
            minWidth: 0,
            child: Text(
              isRegister
                  ? DefaultLocalizations.of(context).login
                  : DefaultLocalizations.of(context).signup,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onPressed: () {
              setState(() {
                isRegister = !isRegister;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget otherLogin() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: FlatButton(
        child: Text(
          '其他账号登录 >>',
          style: TextStyle(
            fontWeight: FontWeight.w300,
            color: Colors.black,
          ),
        ),
        onPressed: () {
          primaryFocus?.unfocus();
          widget.controller.reverse();
        },
      ),
    );
  }

  void _onLogin() async {
    primaryFocus?.unfocus();
    if (_formKey.currentState.validate()) {
      showLoadingDialog(context);
      String result = '';
      User user;
      try {
        user = await login(
            _nameController.text.trim(), _pwdController.text.trim());
        closeDialog(context);
        Provider.of<UserState>(context, listen: false).user = user;
        String lastLogin = Global.profile.lastLogin;
        if (user.username != lastLogin) {
          result = 'remote';
        }
        Navigator.pop(context, result);
      } on CustomException catch (e) {
        closeDialog(context);
        showResultDialog(context, e.toString());
        Future.delayed(Duration(seconds: 2), () {
          closeDialog(context);
        });
      } catch (e) {
        closeDialog(context);
        showToast(context, e.toString(), true);
      }
    }
  }

  void _onSignin() async {
    primaryFocus?.unfocus();
    if (_formKey.currentState.validate()) {
      showLoadingDialog(context);
      String result = '';
      User user;
      try {
        user = await register(
            _nameController.text.trim(), _pwdController.text.trim());
        closeDialog(context);
        showToast(
            context, 'check email and confirm to complete register.', false);
        String lastLogin = Global.profile.lastLogin;
        Provider.of<UserState>(context, listen: false).user = user;
        if (lastLogin != null) {
          result = 'local';
        }
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context, result);
        });
      } on CustomException catch (e) {
        closeDialog(context);
        showResultDialog(context, e.toString());
        Future.delayed(Duration(seconds: 2), () {
          closeDialog(context);
        });
      } catch (e) {
        closeDialog(context);
        showToast(context, e.toString(), true);
      }
    }
  }
}
