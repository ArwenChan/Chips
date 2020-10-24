import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showLoadingDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: const EdgeInsets.fromLTRB(120, 0, 120, 0),
        content: Platform.isAndroid
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor))
            : CupertinoActivityIndicator(radius: 20),
      );
    },
  );
}

showNewListDialog(BuildContext context) async {
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
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('OK', style: TextStyle(fontSize: 16)),
            textColor: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context).pop(textController.text);
            },
          ),
        ],
      );
    },
  );
}

showDeleteDialog(BuildContext context) async {
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
              Navigator.of(context).pop(false);
            },
          ),
          FlatButton(
            child: Text('CONFIRM', style: TextStyle(fontSize: 16)),
            textColor: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}

showToast(BuildContext context, String tips, bool isError) {
  Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(tips),
      duration: Duration(seconds: 2),
      backgroundColor: isError ? Colors.red : Colors.green));
}

showBottom({BuildContext context, List<Widget> list}) async {
  await showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        width: double.infinity,
        height: 100,
        color: Colors.white70,
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: list),
        ),
      );
    },
  );
}

showResultDialog(BuildContext context, String tips,
    {bool isError: true}) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.black87,
        insetPadding: EdgeInsets.symmetric(horizontal: 90),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            isError
                ? Icon(Icons.error, size: 50, color: Colors.white70)
                : Icon(Icons.done, size: 50, color: Colors.white70),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 26, 10, 0),
              child: Text(tips,
                  style: TextStyle(fontSize: 18, color: Colors.white70)),
            )
          ],
        ),
        contentPadding: const EdgeInsets.fromLTRB(15, 30, 15, 30),
      );
    },
  );
}
