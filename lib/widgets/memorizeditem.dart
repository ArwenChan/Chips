import 'package:flutter/material.dart';

class MemorizedItem extends StatelessWidget {
  MemorizedItem({Key key, @required this.word}) : super(key: key);
  final String word;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 20),
      margin: EdgeInsets.only(bottom: 1),
      color: Colors.white,
      height: 60,
      child: Text(
        word,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w400,
          color: Colors.green,
        ),
      ),
    );
  }
}
