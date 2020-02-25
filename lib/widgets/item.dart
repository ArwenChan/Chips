import 'package:flutter/widgets.dart';

class Item extends StatelessWidget {
  Item({@required this.word, this.translation, this.turned: false});
  final String word;
  final String translation;
  final bool turned;

  @override
  Widget build(BuildContext context) {}
}
