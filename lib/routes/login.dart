import 'package:dict/common/dialogs.dart';
import 'package:dict/common/dialogs.dart' show showLoadingDialog, showToast;
import 'package:dict/common/global.dart';
import 'package:dict/common/validators.dart';
import 'package:dict/models/user.dart';
import 'package:dict/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  bool pwdShow = false;
  GlobalKey _formKey = new GlobalKey<FormState>();
  bool _nameAutoFocus = true;

  @override
  void initState() {
    _nameController.text = Global.profile.lastLogin;
    if (_nameController.text != null) {
      _nameAutoFocus = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("登录")),
        body: Center(
          child: Form(
              key: _formKey,
              autovalidate: true,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    autofocus: _nameAutoFocus,
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "用户名",
                      hintText: "邮箱",
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (v) {
                      return Validators.isEmail(v.trim()) ? null : "邮箱格式不正确";
                    },
                  ),
                  TextFormField(
                    autofocus: !_nameAutoFocus,
                    controller: _pwdController,
                    decoration: InputDecoration(
                        labelText: "密码",
                        hintText: "密码",
                        prefixIcon: Icon(Icons.lock),
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
                          : "密码格式不对";
                    },
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: ConstrainedBox(
                          constraints: BoxConstraints.expand(height: 55.0),
                          child: RaisedButton(
                              color: Theme.of(context).primaryColor,
                              onPressed: _onLogin,
                              textColor: Colors.white,
                              child: Text("登录"))))
                ],
              )),
        ));
  }

  void _onLogin() async {
    if ((_formKey.currentState as FormState).validate()) {
      showLoadingDialog(context, "登录中");
      User user;
      try {
        // login
        await Future.delayed(Duration(seconds: 2), () async {
          user.email = "mock@email.com";
          Provider.of<UserState>(context, listen: false).user = user;
        });
        Navigator.of(context).pop();
      } catch (e) {
        showToast(context, e.toString());
      }
      if (user != null) {
        Navigator.of(context).pop();
      }
    }
  }
}
