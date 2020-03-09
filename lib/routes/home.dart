import 'package:dict/common/global.dart';
import 'package:dict/widgets/drawer.dart';
import 'package:dict/widgets/list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  double headerHeight = 0;
  FocusNode focusNodeText = FocusNode();
  final ScrollController controller = ScrollController();
  bool inDrag = false;
  bool showText = false;

  @override
  void initState() {
    super.initState();
    focusNodeText.addListener(focusListener);
  }

  @override
  void dispose() {
    focusNodeText.removeListener(focusListener);
    super.dispose();
  }

  void focusListener() {
    if (!focusNodeText.hasFocus) {
      setState(() {
        headerHeight = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Global.words[Global.wordListIndex].name),
      ),
      body: _buildBody(),
      drawer: MyDrawer(),
    );
  }

  Widget textWidget() {
    return Container(
      child: Text(
        'Pull down to add a word',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 24,
          fontWeight: FontWeight.w300,
        ),
      ),
      color: Colors.black,
      height: 60,
      alignment: Alignment.center,
    );
  }

  Widget inputWidget() {
    return Container(
      child: TextField(
          style: TextStyle(fontSize: 24),
          autofocus: false,
          focusNode: focusNodeText,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(20),
            hintText: 'type word',
          ),
          onChanged: (v) {
            print("onChange: $v");
          }),
      height: headerHeight,
    );
  }

  Widget _buildBody() {
    return Listener(
      onPointerMove: (PointerMoveEvent event) {
        final double y = event.delta.dy;
        if (inDrag ||
            y < 0 ||
            focusNodeText.hasFocus ||
            (event.localPosition.dy > 60 && controller.offset > 0)) return;
        if (headerHeight < 60) {
          setState(() {
            headerHeight += y;
          });
        } else {
          FocusScope.of(context).requestFocus(focusNodeText);
        }
      },
      onPointerUp: (PointerUpEvent event) {
        if (focusNodeText.hasFocus) {
          if (showText) {
            focusNodeText.unfocus();
            showText = false;
          } else {
            showText = true;
          }
        }
        if (headerHeight > 0 && headerHeight < 60) {
          setState(() {
            headerHeight = 0;
          });
        }
      },
      child: Column(
        children: <Widget>[
          inputWidget(),
          textWidget(),
          Expanded(
              child: Stack(
            fit: StackFit.loose,
            children: <Widget>[
              Words(),
              Container(
                color: Colors.black.withOpacity(0.5),
                height: headerHeight >= 60 ? double.infinity : 0,
              ),
            ],
          ))
        ],
      ),
    );
  }
}

// TODO: 根据text的controller获取和调整inputWidget
