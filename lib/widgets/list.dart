import 'package:dict/common/global.dart';
import 'package:dict/models/word.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:dict/routes/home.dart';

import 'item.dart';

class Words extends StatefulWidget {
  @override
  WordsState createState() => WordsState();
}

class WordsState extends State<Words> {
  List<Word> data = Global.words[Global.wordListIndex].words;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  AnimatedListState get _animatedList => _listKey.currentState;

  HomePageState get homeState =>
      context.ancestorStateOfType(TypeMatcher<HomePageState>());

  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    Word item = data[index];
    return Item(
        key: ValueKey('$index-${item.spelling}'),
        animation: animation,
        data: item,
        index: index,
        remove: () {
          _remove(index);
        });
  }

  Widget _buildRemovedItem(
      Word item, BuildContext context, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Container(
        color: Colors.transparent,
        height: 60,
      ),
    );
  }

  void _insert(Word newItem) {
    data.insert(0, newItem);
    _animatedList.insertItem(0);
  }

  void _remove(int index) {
    Word removedItem = data.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(index,
          (BuildContext context, Animation<double> animation) {
        return _buildRemovedItem(removedItem, context, animation);
      }, duration: Duration(milliseconds: 200));
    }
  }

  void move(int currentIndex, int index, Word word) {
    setState(() {
      debugPrint('$currentIndex move before $index');
      data.removeAt(currentIndex);
      data.insert(currentIndex > index ? index : index - 1, word);
    });
  }

  void moveToLast(int currentIndex, Word word) {
    setState(() {
      debugPrint('$currentIndex move to last');
      data.removeAt(currentIndex);
      data.add(word);
    });
  }

  void scrollTo(double pos) {
    homeState.controller.animateTo(pos,
        duration: Duration(milliseconds: 100), curve: Curves.linear);
  }
  // TODO: 删除后面的item时,会上下都往中间调整位置,期待是下面往上面移动.

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AnimatedList(
        key: _listKey,
        itemBuilder: _buildItem,
        initialItemCount: 12,
        controller: homeState.controller,
      ),
      color: Colors.black,
    );
  }
}
