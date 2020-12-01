import 'dart:io';

import 'package:dict/common/global.dart';
import 'package:dict/i10n/localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showLoadingDialog(BuildContext context, {String tips: ''}) async {
  Global.inDialog++;
  if (tips.isEmpty) {
    tips = DefaultLocalizations.of(context).loading;
  } else if (tips.length > 10) {
    tips = tips.substring(0, 10);
  }
  return await showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    builder: (context) {
      return AlertDialog(
        insetPadding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.35),
        backgroundColor: Colors.black87,
        contentPadding: EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: Platform.isAndroid
                  ? CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.white70),
                      strokeWidth: 3,
                    )
                  : CupertinoTheme(
                      data: CupertinoTheme.of(context)
                          .copyWith(brightness: Brightness.dark),
                      child: CupertinoActivityIndicator(radius: 17),
                    ),
              margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
              height: 20.0,
              width: 20.0,
            ),
            Text(
              tips,
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
          ],
        ),
      );
    },
  );
}

showNewListDialog(BuildContext context) async {
  Global.inDialog++;
  final TextEditingController textController = TextEditingController();
  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text('List Name'),
        content: Container(
          width: 5,
          child: TextField(
            style: TextStyle(fontSize: 18),
            autofocus: true,
            cursorWidth: 1,
            cursorColor: Theme.of(context).primaryColor,
            maxLength: 15,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(5),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide(width: 1))),
            controller: textController,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: <Widget>[
          FlatButton(
            child: Text('CANCEL', style: TextStyle(fontSize: 16)),
            textColor: Theme.of(context).primaryColor,
            onPressed: () {
              closeDialog(context);
            },
          ),
          FlatButton(
            child: Text('OK', style: TextStyle(fontSize: 16)),
            textColor: Theme.of(context).primaryColor,
            onPressed: () {
              Global.inDialog--;
              Navigator.of(context).pop(textController.text);
            },
          ),
        ],
      );
    },
  );
}

showDeleteDialog(BuildContext context) async {
  Global.inDialog++;
  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text('Confirm to Delete?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: <Widget>[
          FlatButton(
            child: Text('CANCEL', style: TextStyle(fontSize: 16)),
            textColor: Theme.of(context).primaryColor,
            onPressed: () {
              Global.inDialog--;
              Navigator.of(context).pop(false);
            },
          ),
          FlatButton(
            child: Text('CONFIRM', style: TextStyle(fontSize: 16)),
            textColor: Theme.of(context).primaryColor,
            onPressed: () {
              Global.inDialog--;
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}

showToast(BuildContext context, String tips, bool isError) {
  if (tips.contains('Failed host lookup')) {
    tips = DefaultLocalizations.of(context).connectionLost;
  }
  Scaffold.of(context).showSnackBar(
    SnackBar(
        content: Text(tips),
        duration: Duration(seconds: 2),
        backgroundColor: isError ? Colors.red : Colors.green),
  );
}

showBottom({BuildContext context, List<Widget> list}) async {
  await showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        width: double.infinity,
        height: 120,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: list,
          ),
        ),
      );
    },
  );
}

showResultDialog(BuildContext context, String tips,
    {bool isError: true}) async {
  Global.inDialog++;
  return await showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.black87,
        insetPadding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.2),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 16),
              child: isError
                  ? Icon(Icons.error, size: 50, color: Colors.white70)
                  : Icon(Icons.done, size: 50, color: Colors.white70),
            ),
            Text(tips, style: TextStyle(fontSize: 18, color: Colors.white70)),
          ],
        ),
        contentPadding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      );
    },
  );
}

showAppleDialog(BuildContext context, tips) async {
  Global.inDialog++;
  await showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        content: Text(
          tips,
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.start,
          strutStyle: StrutStyle(
            forceStrutHeight: true,
            height: 2,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('确认', style: TextStyle(fontSize: 16)),
            onPressed: () {
              closeDialog(context);
            },
          ),
        ],
      );
    },
  );
}

void closeDialog(BuildContext context, {int level: 0}) {
  while (Global.inDialog > level) {
    Navigator.pop(context);
    Global.inDialog--;
  }
}
