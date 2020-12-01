import 'package:badges/badges.dart';
import 'package:dict/common/api.dart'
    show getProducts, logout, update, updateMemorized;
import 'package:dict/common/dialogs.dart';
import 'package:dict/common/exception.dart';
import 'package:dict/common/global.dart';
import 'package:dict/common/subscribe.dart';
import 'package:dict/i10n/localizations.dart';
import 'package:dict/models/product.dart';
import 'package:dict/states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:launch_review/launch_review.dart';

const PRONUNCIATION_MAP = {'BrE': '英音', 'AmE': '美音'};

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DefaultLocalizations.of(context).settings),
        backgroundColor: Colors.grey[300],
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
      ),
      body: SettingList(),
    );
  }
}

class SettingList extends StatefulWidget {
  @override
  SettingListState createState() => SettingListState();
}

class SettingListState extends State<SettingList> {
  bool tranlateInplace;
  bool tranlateInplaceWithPronunciation;
  String pronunciation;
  int fromLangIndex = 0;
  int toLangIndex = 0;
  List<dynamic> from;
  List<dynamic> to;
  List<Product> products;
  List<dynamic> bought = [];

  bool get hasBought {
    return bought
        .contains('${from[fromLangIndex]['code']}_${to[toLangIndex]['code']}');
  }

  @override
  Widget build(BuildContext context) {
    tranlateInplace = Provider.of<UserSetting>(context).tranlateInplace;
    tranlateInplaceWithPronunciation =
        Provider.of<UserSetting>(context).tranlateInplaceWithPronunciation;
    pronunciation = Provider.of<UserSetting>(context).pronunciation;
    return Container(
      width: double.infinity,
      color: Colors.grey[300],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _widgetList(context),
      ),
    );
  }

  List<Widget> _widgetList(BuildContext context) {
    List<Widget> widgets = [
      _item(
        DefaultLocalizations.of(context).subscribe,
        Icon(Icons.arrow_forward_ios, size: 18),
        func: () async {
          if (Provider.of<UserState>(context, listen: false).isLogin) {
            showSheet();
          } else {
            Navigator.pushNamed(context, 'login');
          }
        },
        lastItem: true,
      ),
      _item(
        DefaultLocalizations.of(context).feedback,
        Icon(Icons.arrow_forward_ios, size: 18),
        func: () async {
          try {
            await feedback();
          } catch (e) {
            showToast(context, e.toString(), true);
          }
        },
      ),
      _item(
        DefaultLocalizations.of(context).review,
        Icon(Icons.arrow_forward_ios, size: 18),
        func: () {
          LaunchReview.launch(
            androidAppId: "com.potato.chips",
            iOSAppId: "1532868195",
          );
        },
      ),
      _item(
        DefaultLocalizations.of(context).features,
        Icon(Icons.arrow_forward_ios, size: 18),
        func: () {
          Navigator.pushNamed(context, 'help');
        },
      ),
      _item(
        DefaultLocalizations.of(context).update,
        Row(children: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Badge(
              badgeContent: Text(''),
              child: Text('${Global.packageInfo.version}',
                  style: TextStyle(fontSize: 18)),
              toAnimate: false,
              showBadge: Global.latestVersion != Global.packageInfo.version,
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 18)
        ]),
        func: () {
          LaunchReview.launch(
            writeReview: false,
            androidAppId: "com.potato.chips",
            iOSAppId: "1532868195",
          );
        },
      ),
      _item(
        DefaultLocalizations.of(context).share,
        Icon(Icons.arrow_forward_ios, size: 18),
        func: () {
          share();
        },
      ),
      _item(
        DefaultLocalizations.of(context).privacy,
        Icon(Icons.arrow_forward_ios, size: 18),
        lastItem: true,
        func: () {
          Navigator.pushNamed(context, 'privacy');
        },
      ),
      _buildBottom(context),
    ];
    // if (Global.canListenCopy) {
    //   widgets.insertAll(0, [
    //     _item(
    //       DefaultLocalizations.of(context).translateInPlace,
    //       Switch(
    //         value: tranlateInplace,
    //         activeColor: Theme.of(context).primaryColor,
    //         onChanged: (bool newValue) {
    //           Provider.of<UserSetting>(context, listen: false).tranlateInplace =
    //               newValue;
    //         },
    //       ),
    //     ),
    //     _item(
    //       DefaultLocalizations.of(context).translateInPlaceWithPronunciation,
    //       Switch(
    //         value: tranlateInplaceWithPronunciation,
    //         activeColor: Theme.of(context).primaryColor,
    //         onChanged: (bool newValue) {
    //           Provider.of<UserSetting>(context, listen: false)
    //               .tranlateInplaceWithPronunciation = newValue;
    //         },
    //       ),
    //     ),
    //     _item(
    //       DefaultLocalizations.of(context).pronunciationType,
    //       Row(children: [
    //         Text(PRONUNCIATION_MAP[pronunciation],
    //             style: TextStyle(fontSize: 18)),
    //         Icon(Icons.arrow_forward_ios, size: 18)
    //       ]),
    //       func: () {
    //         showBottom(
    //           context: context,
    //           list: [
    //             FlatButton(
    //               child: Text(PRONUNCIATION_MAP['BrE'],
    //                   style: TextStyle(fontSize: 16)),
    //               onPressed: () {
    //                 Provider.of<UserSetting>(context, listen: false)
    //                     .pronunciation = 'BrE';
    //                 Navigator.pop(context);
    //               },
    //             ),
    //             FlatButton(
    //               child: Text(PRONUNCIATION_MAP['AmE'],
    //                   style: TextStyle(fontSize: 16)),
    //               onPressed: () {
    //                 Provider.of<UserSetting>(context, listen: false)
    //                     .pronunciation = 'AmE';
    //                 Navigator.pop(context);
    //               },
    //             ),
    //           ],
    //         );
    //       },
    //       lastItem: true,
    //     ),
    //   ]);
    // }
    return widgets;
  }

  Widget _buildBottom(BuildContext context) {
    return Container(
      child: ButtonTheme(
        height: 50,
        minWidth: double.infinity,
        child: FlatButton(
          textColor: Colors.black87,
          child: Text(
            DefaultLocalizations.of(context).logout,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
          onPressed: () async {
            if (Provider.of<UserState>(context, listen: false).isLogin) {
              try {
                await checkAndUpdate();
                await logout();
                Provider.of<UserState>(context, listen: false).user = null;
                Navigator.pop(context);
              } on CustomException catch (e) {
                showResultDialog(context, e.toString());
                Future.delayed(Duration(seconds: 2), () {
                  closeDialog(context);
                  if (e.code == 4003) {
                    Navigator.pushNamed(context, 'login');
                  }
                });
              } catch (e) {
                showToast(context, e.toString(), true);
              }
            }
          },
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _item(String text, Widget widget,
      {VoidCallback func, bool lastItem: false}) {
    return GestureDetector(
      onTap: func,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: EdgeInsets.only(bottom: lastItem ? 20 : 0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom:
                BorderSide(width: lastItem ? 0 : 1.0, color: Colors.black12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              text,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            widget,
          ],
        ),
      ),
    );
  }

  Future feedback() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'chipsfrompotato@outlook.com',
      query:
          'subject=App Feedback&body=Version ${Global.packageInfo.version} \nPlatform  ${Global.deviceInfoString}\n \n ${DefaultLocalizations.of(context).writeFeedback}', //add subject and body here
    );

    var url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch email';
    }
  }

  checkAndUpdate() async {
    if (Global.words.any((v) => !v.updated)) {
      List ids = await update(Global.words);
      debugPrint('updated');
      Global.words.forEach((v) {
        if (!v.updated) {
          v.id = ids.removeAt(0);
          v.updated = true;
        }
      });
    }
    if (!Global.memorized['updated']) {
      String id = await updateMemorized(Global.memorized);
      debugPrint('updated memorized');
      Global.memorized['id'] = id;
      Global.memorized['updated'] = true;
    }
  }

  Future<void> share() async {
    await FlutterShare.share(
      title: 'Chips',
      text: 'Chips-极简风格词典APP',
      linkUrl: 'https://itunes.apple.com/cn/app/id1532868195',
    );
  }

  Future<void> showSheet() async {
    try {
      showLoadingDialog(context);
      dynamic langs = await getProducts();
      closeDialog(context);
      from = langs['from'];
      to = langs['to'];
      bought = langs['bought'];
      products = langs['products'].map<Product>((e) {
        return Product.fromJson(e);
      }).toList();
    } catch (e) {
      showToast(context, e.toString(), true);
    }
    List<Widget> fromList =
        from.map<Widget>((e) => Text(e['nativeName'])).toList();
    List<Widget> toList = to.map<Widget>((e) => Text(e['nativeName'])).toList();
    showModalBottomSheet<void>(
        context: context,
        enableDrag: false,
        backgroundColor: Colors.grey[300],
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlatButton(
                    child: Text(DefaultLocalizations.of(context).cancel,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400)),
                    height: 40,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: hasBought
                        ? Text(DefaultLocalizations.of(context).bought,
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                                fontWeight: FontWeight.w400))
                        : Text(DefaultLocalizations.of(context).confirm,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400)),
                    height: 40,
                    onPressed: () async {
                      if (!hasBought) {
                        Navigator.pop(context);
                        toBuy();
                      }
                    },
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 200,
                    child: ListWheelScrollView(
                      itemExtent: 40,
                      diameterRatio: 0.8,
                      useMagnifier: true,
                      magnification: 1.5,
                      squeeze: 1.0,
                      children: fromList,
                      onSelectedItemChanged: (int i) {
                        setState(() {
                          fromLangIndex = i;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 200,
                    child: ListWheelScrollView(
                      itemExtent: 40,
                      diameterRatio: 0.8,
                      useMagnifier: true,
                      magnification: 1.5,
                      children: toList,
                      onSelectedItemChanged: (int i) {
                        setState(() {
                          toLangIndex = i;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  void toBuy() async {
    Product p = products.firstWhere((element) =>
        element.langFrom == from[fromLangIndex]['code'] &&
        element.langTo == to[toLangIndex]['code']);
    await subscribe(p, context);
  }
}
