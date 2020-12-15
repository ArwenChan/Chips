import 'package:dict/widgets/login/apple.dart';
import 'package:dict/widgets/login/email.dart';
import 'package:dict/widgets/login/qq.dart';
import 'package:dict/widgets/login/weibo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<Offset> offsetAnimation;
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0.0),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 24),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        child: Stack(
          children: [
            Email(controller: controller),
            SlideCard(controller: controller, offsetAnimation: offsetAnimation),
          ],
        ),
      ),
    );
  }
}

class SlideCard extends StatelessWidget {
  final AnimationController controller;
  final Animation<Offset> offsetAnimation;
  SlideCard({Key key, this.controller, this.offsetAnimation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: offsetAnimation,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 150),
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: const Color(0xfffafafa),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: QQ(),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: WeiBo(),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Apple(),
              ),
              FlatButton.icon(
                onPressed: () {
                  controller.forward();
                },
                icon: Icon(Icons.email, size: 28, color: Colors.white),
                label: Text(
                  '邮箱登录',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                color: Theme.of(context).primaryColor,
                height: 48,
                minWidth: 235,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  side: BorderSide(width: 1, color: Colors.black12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
