import 'package:dict/common/dialogs.dart';
import 'package:dict/common/exception.dart';
import 'package:dict/common/global.dart';
import 'package:dict/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key key, this.routeFunction}) : super(key: key);
  final Function routeFunction;

  @override
  MyDrawerState createState() => MyDrawerState();
}

class MyDrawerState extends State<MyDrawer> {
  int focusIndex = 0;
  @override
  Widget build(BuildContext context) {
    focusIndex = Provider.of<DataSheet>(context).dataIndex;
    return Container(
      color: Color(0xFF232323),
      padding:
          EdgeInsets.fromLTRB(0, MediaQuery.of(context).padding.top, 0, 100),
      width: MediaQuery.of(context).size.width * 0.75,
      child: Drawer(
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeader(context),
            Expanded(
              child: _buildMenus(),
            ),
            _buildBottom(context)
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 50,
      color: Color(0xFF2F2F2F),
      padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
      child: Row(
        children: <Widget>[
          Image(image: AssetImage("assets/logo.png"), width: 30),
          IconButton(
            icon: Icon(
              Icons.perm_identity,
              size: 30,
              color: Provider.of<UserState>(context).isLogin
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
            ),
            onPressed: () async {
              if (!Provider.of<UserState>(context, listen: false).isLogin) {
                await widget.routeFunction('login');
                // await Future.delayed(Duration(milliseconds: 500));
                Navigator.pop(context, 1);
              }
            },
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }

  Widget _buildMenus() {
    return Container(
      color: Color(0xFF2F2F2F),
      // color: Colors.red,
      child: ListView.builder(
        itemExtent: 70,
        itemCount: Global.words.length,
        itemBuilder: (BuildContext context, int index) {
          return FlatButton(
            onPressed: () {
              Provider.of<DataSheet>(context, listen: false).dataIndex = index;
              Navigator.pop(context);
            },
            onLongPress: () async {
              bool toDelete = await showDeleteDialog(context);
              if (toDelete) {
                try {
                  await Provider.of<DataSheet>(context, listen: false)
                      .remove(index);
                } on CustomException catch (e) {
                  var dialog = showResultDialog(context, e.toString());
                  Future.delayed(Duration(seconds: 2), () {
                    Navigator.pop(context, dialog);
                    if (e.code == 4003) {
                      Navigator.pushNamed(context, 'login');
                    }
                  });
                } catch (e) {
                  debugPrint(e.toString());
                }
              }
            },
            textColor: focusIndex == index ? Colors.white : Colors.white24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(Global.words[index].name,
                    style:
                        TextStyle(fontSize: 26, fontWeight: FontWeight.w300)),
                Text(
                  '${Global.words[index].words.length} words',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottom(BuildContext context) {
    return Container(
      height: 250,
      color: Color(0xFF232323),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            height: 70,
            color: Color(0xFF2F2F2F),
            child: IconButton(
              onPressed: () async {
                String name = await showNewListDialog(context);
                if (name == null || name.isEmpty) return;
                Provider.of<DataSheet>(context, listen: false).add(name);
              },
              icon: Icon(Icons.add, size: 35, color: Colors.white24),
            ),
          ),
          ButtonTheme(
            height: 70,
            child: FlatButton.icon(
              textColor: focusIndex == -1 ? Colors.white : Colors.white24,
              label: const Text('Memorized Words',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300)),
              icon: const Icon(Icons.check_circle, size: 25),
              onPressed: () {
                Provider.of<DataSheet>(context, listen: false).dataIndex = -1;
                Navigator.pop(context);
              },
            ),
          ),
          ButtonTheme(
            height: 70,
            child: FlatButton.icon(
              textColor: Colors.white24,
              label: const Text('Settings',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300)),
              icon: const Icon(Icons.settings, size: 25),
              onPressed: () async {
                widget.routeFunction('settings');
                // await Future.delayed(Duration(milliseconds: 50));
                // Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
