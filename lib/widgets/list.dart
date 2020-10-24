import 'package:dict/models/word.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:dict/routes/home.dart';
import 'package:provider/provider.dart';

import '../states.dart';
import 'item.dart';

class Words extends StatefulWidget {
  Words({Key key}) : super(key: key);
  @override
  WordsState createState() => WordsState();
}

class WordsState extends State<Words> {
  List<Word> data;
  GlobalKey<AnimatedListState> _listKey;

  AnimatedListState get _animatedList => _listKey.currentState;

  HomeListState get homeState => context.findAncestorStateOfType();

  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    Word item = data[index];
    return Item(
        key: ValueKey('$index-${item.word}'),
        animation: animation,
        data: item,
        list: data,
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

  void insert(Word newItem) {
    Provider.of<DataSheet>(context, listen: false).dataInsert(newItem);
    _animatedList.insertItem(0);
  }

  void _remove(int index) {
    Word removedItem =
        Provider.of<DataSheet>(context, listen: false).dataRemove(index);
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
      Provider.of<DataSheet>(context, listen: false)
          .dataMove(currentIndex, index, word);
    });
  }

  void moveToLast(int currentIndex, Word word) {
    setState(() {
      debugPrint('$currentIndex move to last');
      Provider.of<DataSheet>(context, listen: false)
          .dataMoveToLast(currentIndex, word);
    });
  }

  void scrollTo(double pos) {
    homeState.controller.animateTo(pos,
        duration: Duration(milliseconds: 100), curve: Curves.linear);
  }
  // TODO: 删除后面的item时,会上下都往中间调整位置,期待是下面往上面移动.

  @override
  Widget build(BuildContext context) {
    data = Provider.of<DataSheet>(context).data;
    _listKey = Provider.of<DataSheet>(context)
        .listKeys[Provider.of<DataSheet>(context).dataIndex];
    return Container(
      child: AnimatedList(
        key: _listKey,
        itemBuilder: _buildItem,
        initialItemCount: data.length,
        controller: homeState.controller,
      ),
    );
  }
}
