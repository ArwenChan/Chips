import 'dart:async';
import 'dart:convert';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dict/common/dialogs.dart';
import 'package:dict/common/exception.dart';
import 'package:dict/common/global.dart';
import 'package:dict/common/api.dart'
    show query, toLocal, update, updateMemorized;
import 'package:dict/common/subscribe.dart' show subscribe;
import 'package:dict/models/product.dart';
import 'package:dict/models/word.dart';
import 'package:dict/states.dart';
import 'package:dict/widgets/drawer.dart';
import 'package:dict/widgets/list.dart';
import 'package:dict/widgets/memorized.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(Provider.of<DataSheet>(context).title), actions: [
        IconButton(
          icon: Icon(Icons.help_outline),
          onPressed: () {
            Navigator.pushNamed(context, 'help');
          },
        )
      ]),
      body: HomeList(),
      drawer: DrawerCotainer(),
    );
  }
}

class DrawerCotainer extends StatefulWidget {
  @override
  DrawerCotainerState createState() => DrawerCotainerState();
}

class DrawerCotainerState extends State<DrawerCotainer> {
  @override
  Widget build(BuildContext context) {
    return MyDrawer(routeFunction: toRoutes);
  }

  // routes:
  void toRoutes(String route) async {
    var result = await Navigator.pushNamed(context, route);
    debugPrint('login result: $result');
    if (result == 'remote') {
      Provider.of<DataSheet>(context, listen: false)
          .reloadRemote()
          .catchError((error) {
        showToast(context, error.toString(), true);
      });
    } else if (result == 'local') {
      Provider.of<DataSheet>(context, listen: false).reloadLocal();
    }
  }
}

class HomeList extends StatefulWidget {
  @override
  HomeListState createState() => HomeListState();
}

class HomeListState extends State<HomeList> with WidgetsBindingObserver {
  double headerHeight = 0;
  FocusNode focusNodeText = FocusNode();
  final ScrollController controller = ScrollController();
  final TextEditingController textController = TextEditingController();
  final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
  final GlobalKey<WordsState> wordsKey = GlobalKey<WordsState>();
  // StreamSubscription<dynamic> clipboardStream;
  bool inDrag = false;
  bool inPull = false;
  bool showText = false;
  bool querying = false;
  bool hasSubmit = false;
  double pullDistance = 0;
  Word queryOut;
  Timer timer;
  String queryWord;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    focusNodeText.addListener(focusListener);
    textController.addListener(textHandler);
    Future.delayed(Duration(seconds: 2), () async {
      if (Provider.of<UserState>(context, listen: false).isLogin &&
          Global.words.any((v) => !v.updated)) {
        update(Global.words).then((ids) {
          debugPrint('updated');
          Global.words.forEach((v) {
            if (!v.updated) {
              v.id = ids.removeAt(0);
              v.updated = true;
            }
          });
        });
      }
      if (Provider.of<UserState>(context, listen: false).isLogin &&
          !Global.memorized['updated']) {
        updateMemorized(Global.memorized).then((id) {
          debugPrint('updated memorized');
          Global.memorized['id'] = id;
          Global.memorized['updated'] = true;
        });
      }
    });
  }

  @override
  void dispose() {
    focusNodeText.removeListener(focusListener);
    textController.removeListener(textHandler);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    debugPrint('------$state-----');
    if (state == AppLifecycleState.inactive && Global.needSave) {
      await toLocal(Global.words, Global.memorized);
      Global.saveProfile();
      Global.needSave = false;
      debugPrint('finish to local');
    } else if (state == AppLifecycleState.resumed) {
      // don't save when it back from inactive to resumed
      Global.needSave = true;
    }
    // else if (state == AppLifecycleState.detached && Global.canListenCopy) {
    //   clipboardStream.cancel();
    // }
  }

  void takeUp() {
    textController.text = '';
    showText = false;
    setState(() {
      headerHeight = 0;
      queryOut = null;
    });
  }

  void focusListener() {
    if (hasSubmit) return;
    if (!focusNodeText.hasFocus) {
      takeUp();
    }
  }

  void textHandler() {
    if (hasSubmit) return;
    debugPrint('------------textHandler-----------');
    timer?.cancel();
    timer = Timer(Duration(milliseconds: 1000), () async {
      if (textController.text == '') {
        setState(() {
          queryOut = null;
          queryWord = null;
        });
        return;
      }
      final Word out = await _toQuery();
      if (out != null && queryWord != null) {
        setState(() {
          queryOut = out;
          if (hasSubmit) {
            insertItem();
            hasSubmit = false;
          }
        });
      }
    });
  }

  void submitHandler(word) async {
    hasSubmit = true;
    if (word != queryWord) {
      timer?.cancel();
      final Word out = await _toQuery();
      if (out != null && queryWord != null) {
        setState(() {
          queryOut = out;
          insertItem();
        });
      }
      hasSubmit = false;
    } else if (!querying) {
      setState(() {
        insertItem();
      });
      hasSubmit = false;
    }
  }

  void insertItem() {
    wordsKey.currentState.insert(queryOut);
    queryWord = null;
    takeUp();
  }

  Future<Word> _toQuery() async {
    debugPrint('-----------------query----------------');
    if (querying && textController.text == queryWord) {
      return null;
    }
    querying = true;
    queryWord = textController.text;
    Word out;
    try {
      out = await query(queryWord);
    } on CustomException catch (e) {
      if (hasSubmit) {
        takeUp();
      } else {
        focusNodeText.unfocus();
      }
      if (e.code == 4002) {
        final Product product = Product.fromJson(jsonDecode(e.detail));
        subscribe(product, context);
      } else if (e.code == 4003) {
        Navigator.pushNamed(context, 'login');
      } else {
        showResultDialog(context, e.toString());
        Future.delayed(Duration(seconds: 2), () {
          closeDialog(context);
        });
      }
    } catch (e) {
      showToast(context, e.toString(), true);
      if (hasSubmit) {
        takeUp();
      } else {
        focusNodeText.unfocus();
      }
    }
    querying = false;
    return out;
  }

  @override
  Widget build(BuildContext context) {
    // if (Global.canListenCopy) {
    //   clipboardStream = Event('clipboardChangeStream').listenClipboardChanges();
    //   clipboardStream.pause();
    // }
    if (Provider.of<DataSheet>(context).dataIndex > -1) {
      return _buildList();
    } else {
      return DecoratedBox(
        decoration: BoxDecoration(color: Color(0xFF232323)),
        child: MemorizedWords(),
      );
    }
  }

  Widget textWidget() {
    return Container(
      child: queryOut == null ? textWidgetBuilder1() : textWidgetBuilder2(),
      height: 60,
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
      margin: EdgeInsets.only(bottom: 0),
    );
  }

  Widget textWidgetBuilder1() {
    return Text(
      headerHeight >= 60 ? 'show translation here' : 'Pull down to add a word',
      style: TextStyle(
        color: Colors.grey,
        fontSize: headerHeight >= 60 ? 22 : 24,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget textWidgetBuilder2() {
    List<Widget> unfoldedWidgets = [];
    for (int i = 0; i < queryOut.defs.length; i++) {
      unfoldedWidgets.addAll([
        Text(
          queryOut.defs[i]['pos'] + ' ',
          style:
              TextStyle(fontSize: 20, color: Colors.grey[100].withOpacity(0.6)),
        ),
        Text(
          '${queryOut.defs[i]['def']}${i == queryOut.defs.length - 1 ? '' : '  '}',
          style: TextStyle(fontSize: 20, color: Colors.white),
        )
      ]);
    }
    return SingleChildScrollView(
      child: Row(children: unfoldedWidgets),
      scrollDirection: Axis.horizontal,
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
        controller: textController,
        autocorrect: false,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))
        ],
        onSubmitted: submitHandler,
      ),
      height: headerHeight,
      color: Colors.white,
    );
  }

  Widget _buildList() {
    return Listener(
        onPointerMove: (PointerMoveEvent event) {
          final double y = event.delta.dy;
          final double x = event.delta.dx;
          if (x.abs() >= y.abs() ||
              inDrag ||
              y < 0 ||
              focusNodeText.hasFocus ||
              (event.localPosition.dy > 60 && controller.offset > 0)) return;
          if (headerHeight < 60) {
            inPull = true;
            setState(() {
              headerHeight += y;
            });
          } else {
            FocusScope.of(context).requestFocus(focusNodeText);
          }
        },
        onPointerUp: (PointerUpEvent event) {
          if (inPull) {
            if (headerHeight > 30) {
              assetsAudioPlayer.open(
                Audio("assets/sounds/pull.mp3"),
              );
            }
          }
          inPull = false;
          if (focusNodeText.hasFocus) {
            if (showText) {
              focusNodeText.unfocus();
            } else {
              showText = true;
            }
          }
          if (headerHeight > 0 && headerHeight < 60) {
            setState(() {
              headerHeight = 0;
            });
          } else if (headerHeight > 60) {
            setState(() {
              headerHeight = 60;
            });
          }
        },
        child: DecoratedBox(
          child: Column(
            children: <Widget>[
              inputWidget(),
              textWidget(),
              Expanded(
                  child: Stack(
                children: <Widget>[
                  Words(key: wordsKey),
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    height: headerHeight >= 60 ? double.infinity : 0,
                  ),
                ],
              ))
            ],
          ),
          decoration: BoxDecoration(color: Color(0xFF232323)),
        ));
  }
}
