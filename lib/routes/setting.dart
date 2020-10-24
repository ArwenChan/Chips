import 'package:dict/common/api.dart' show logout, update, updateMemorized;
import 'package:dict/common/dialogs.dart';
import 'package:dict/common/exception.dart';
import 'package:dict/common/global.dart';
import 'package:dict/i10n/localizations.dart';
import 'package:dict/states.dart';
import 'package:flutter/material.dart';
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
        DefaultLocalizations.of(context).features,
        Icon(Icons.arrow_forward_ios, size: 18),
      ),
      _item(
        DefaultLocalizations.of(context).review,
        Icon(Icons.arrow_forward_ios, size: 18),
        func: () {
          LaunchReview.launch(
            // TODO: Android play store 不能使用.
            androidAppId: "com.potato.chips",
            iOSAppId: "1532870328",
          );
        },
      ),
      _item(
        DefaultLocalizations.of(context).feedback,
        Icon(Icons.arrow_forward_ios, size: 18),
        func: () {
          feedback();
        },
      ),
      // TODO: 如果有更新显示一个小红点
      _item(
        DefaultLocalizations.of(context).update,
        Row(children: [
          Text('${Global.packageInfo.version}', style: TextStyle(fontSize: 18)),
          Icon(Icons.arrow_forward_ios, size: 18)
        ]),
        lastItem: true,
        func: () {
          LaunchReview.launch(
            // TODO: Android play store 不能使用.
            writeReview: false,
            androidAppId: "com.potato.chips",
            iOSAppId: "1532870328",
          );
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
                var dialog = showResultDialog(context, e.toString());
                Future.delayed(Duration(seconds: 2), () {
                  Navigator.pop(context, dialog);
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

  void feedback() async {
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
}
