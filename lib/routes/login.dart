import 'package:dict/common/dialogs.dart';
import 'package:dict/common/dialogs.dart' show showLoadingDialog, showToast;
import 'package:dict/common/exception.dart';
import 'package:dict/common/global.dart';
import 'package:dict/common/validators.dart';
import 'package:dict/common/api.dart' show login, register;
import 'package:dict/models/user.dart';
import 'package:dict/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  TextEditingController _pwdConfirmController = new TextEditingController();
  bool pwdShow = false;
  GlobalKey _formKey = new GlobalKey<FormState>();
  bool isRegister = false;

  @override
  void initState() {
    _nameController.text = Global.profile.lastLogin;
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
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ConstrainedBox(
          constraints: const BoxConstraints.expand(height: 55.0),
          child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              color: Theme.of(context).primaryColor,
              onPressed: isRegister ? _onSignin : _onLogin,
              textColor: Colors.white,
              child: Text(isRegister ? "Sign in" : "Login",
                  style: TextStyle(fontSize: 20)))),
    );
  }

  Widget signinWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FlatButton(
          child: Text(
            isRegister ? 'Login' : 'Sign in',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          onPressed: () {
            setState(() {
              isRegister = !isRegister;
            });
          },
        )
      ],
    );
  }

  void _onLogin() async {
    primaryFocus?.unfocus();
    if ((_formKey.currentState as FormState).validate()) {
      var dialog = showLoadingDialog(context);
      String result = '';
      User user;
      try {
        user = await login(
            _nameController.text.trim(), _pwdController.text.trim());
        Navigator.pop(context, dialog);
        dialog = null;
        Provider.of<UserState>(context, listen: false).user = user;
        String lastLogin = Global.profile.lastLogin;
        if (user.email != lastLogin) {
          result = 'remote';
        }
        Navigator.pop(context, result);
      } on CustomException catch (e) {
        if (dialog != null) {
          Navigator.pop(context);
        }
        var errDialog = showResultDialog(context, e.toString());
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context, errDialog);
        });
      } catch (e) {
        if (dialog != null) {
          Navigator.pop(context);
        }
        showToast(context, e.toString(), true);
      }
    }
  }

  void _onSignin() async {
    primaryFocus?.unfocus();
    if ((_formKey.currentState as FormState).validate()) {
      var dialog = showLoadingDialog(context);
      String result = '';
      User user;
      try {
        user = await register(
            _nameController.text.trim(), _pwdController.text.trim());
        Navigator.pop(context, dialog);
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
        Navigator.pop(context, dialog);
        var errDialog = showResultDialog(context, e.toString());
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context, errDialog);
        });
      } catch (e) {
        Navigator.pop(context, dialog);
        showToast(context, e.toString(), true);
      }
    }
  }
}
