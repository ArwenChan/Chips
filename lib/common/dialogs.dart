import 'package:flutter/material.dart';

showLoadingDialog(BuildContext context, String tips) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.only(top: 26.0),
              child: Text(tips),
            )
          ],
        ),
      );
    },
  );
}

showToast(BuildContext context, String tips) {
  Scaffold.of(context).showSnackBar(
      SnackBar(content: Text(tips), duration: Duration(seconds: 1)));
}
