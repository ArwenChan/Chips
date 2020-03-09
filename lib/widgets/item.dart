import 'package:dict/common/global.dart';
import 'package:dict/models/word.dart';
import 'package:dict/widgets/list.dart';
import 'package:dict/widgets/triangle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:dict/routes/home.dart';

import 'flipcard.dart';

const double leftExtent = 80;
const List<double> rightExtent = [0, 160, 250];
const String mark = 'Mark';
const String grey = 'Almost';
const String memorized = 'Memorized';

class Item extends StatefulWidget {
  Item({
    Key key,
    @required this.data,
    @required this.animation,
    @required this.index,
    this.status: 'normal',
    Function remove,
  })  : this.removeSelf = remove,
        this.word = data.spelling,
        this.translations = data.translations,
        super(key: key);

  final String word;
  final List<List<String>> translations;
  final dynamic data;
  final int index;
  final String status;
  final Animation<double> animation;
  final Function removeSelf;

  @override
  _ItemState createState() => new _ItemState();

  List<Widget> translationCombined() {
    List<Widget> unfoldedWidgets = [];
    for (int i = 0; i < translations.length; i++) {
      unfoldedWidgets.addAll([
        Text(
          translations[i][0] + '. ',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.grey[100].withOpacity(0.5)),
        ),
        Text(
          '${translations[i][1]}${i == translations.length - 1 ? '' : ', '}',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
        )
      ]);
    }
    return unfoldedWidgets;
  }

  List<Word> get dataList {
    return Global.words[Global.wordListIndex].words;
  }
}

class _ItemState extends State<Item> {
  double _left = 0;
  double _right = 0;
  String itemStatus;

  @override
  void initState() {
    super.initState();
    itemStatus = widget.status;
  }

  int get rightState {
    if (_right > 0) {
      return _right <= rightExtent[1] ? 1 : 2;
    }
    return 0;
  }

  HomePageState get homeState =>
      context.ancestorStateOfType(TypeMatcher<HomePageState>());

  WordsState get listState =>
      context.ancestorStateOfType(TypeMatcher<WordsState>());

  Size get screenSize {
    return MediaQuery.of(context).size;
  }

  @override
  Widget build(BuildContext context) {
    Widget item = SizeTransition(
      sizeFactor: widget.animation,
      child: SizedBox(
        height: 60,
        child: DecoratedBox(
          child: Stack(
            children: <Widget>[
              Positioned(
                left: _left,
                top: 0,
                right: _right,
                bottom: 1,
                child: GestureDetector(
                  onHorizontalDragUpdate: (DragUpdateDetails details) {
                    final double x = details.delta.dx;
                    if (x > 0 && _left < leftExtent) {
                      setState(() {
                        _left += x;
                        _right -= x;
                      });
                    } else if (x < 0 && _right < rightExtent[2]) {
                      setState(() {
                        _right -= x;
                        _left += x;
                      });
                    }
                  },
                  onHorizontalDragEnd: (DragEndDetails details) {
                    if (_left > 0) {
                      setState(() {
                        itemStatus = itemStatus == 'tag' ? 'normal' : 'tag';
                        _left = 0;
                        _right = 0;
                      });
                    } else if (_right > 0) {
                      if (_right <= rightExtent[1]) {
                        setState(() {
                          itemStatus = itemStatus == 'grey' ? 'normal' : 'grey';
                          _left = 0;
                          _right = 0;
                        });
                      } else {
                        _left = 0;
                        _right = 0;
                        widget.removeSelf();
                      }
                    }
                  },
                  child: WidgetFlipper(
                    frontWidget: TriangleCorner(
                      width: itemStatus == 'tag' ? 16 : 0,
                      widget: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 20),
                        color: itemStatus == 'grey'
                            ? Colors.grey[300]
                            : Colors.white,
                        child: Text(
                          widget.word,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w400,
                            color: itemStatus == 'grey'
                                ? Colors.grey[500]
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    backWidget: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20),
                      color: Theme.of(context).primaryColor,
                      child: Row(
                        children: widget.translationCombined(),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                child: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 10),
                  color: Colors.blue[100],
                  child: Text(
                    mark,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                ),
                left: 0 - leftExtent - 20 + _left,
                top: 0,
                bottom: 1,
                width: leftExtent + 20,
              ),
              Positioned(
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20),
                  color: Colors.grey[100],
                  child: Text(
                    rightState == 2 ? memorized : grey,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                ),
                right: 0 - rightExtent[rightState] - 20 + _right,
                top: 0,
                bottom: 1,
                width: rightExtent[rightState] + 20,
              ),
            ],
          ),
          decoration: BoxDecoration(
            // border:
            //     Border(bottom: BorderSide(color: Colors.transparent, width: 1)),
            color: Colors.transparent,
          ),
        ),
      ),
    );
    Draggable draggable = LongPressDraggable<Word>(
      data: widget.data,
      axis: Axis.vertical,
      maxSimultaneousDrags: 1,
      child: item,
      childWhenDragging: Container(),
      feedback: Material(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: screenSize.width),
          child: item,
        ),
        elevation: 4.0,
      ),
      onDragStarted: () {
        homeState.inDrag = true;
      },
      onDragEnd: (DraggableDetails d) {
        homeState.inDrag = false;
      },
    );
    Listener listenableDraggable = Listener(
      child: draggable,
      onPointerMove: (PointerMoveEvent event) {
        if (!homeState.inDrag) return;
        if (event.position.dy > screenSize.height) {
          debugPrint('auto scroll to last');
          listState.scrollTo(homeState.controller.offset + 60);
        }
      },
    );
    DragTarget d = DragTarget<Word>(
      onWillAccept: (data) {
        return widget.dataList.indexOf(data) != widget.index;
      },
      onAccept: (data) {
        if (widget.dataList.indexOf(data) == widget.index - 1) return;
        listState.move(widget.dataList.indexOf(data), widget.index, data);
      },
      builder:
          (BuildContext context, List<Word> candidateData, List rejectedData) {
        return Column(
          children: <Widget>[
            candidateData.isEmpty
                ? Container()
                : Container(
                    height: 60,
                  ),
            candidateData.isEmpty ? listenableDraggable : item,
          ],
        );
      },
    );
    if (widget.index == widget.dataList.length - 1) {
      DragTarget lastTarget = DragTarget<Word>(
        onWillAccept: (data) {
          return widget.dataList.indexOf(data) != widget.dataList.length - 1;
        },
        onAccept: (data) {
          listState.moveToLast(widget.dataList.indexOf(data), data);
        },
        builder: (BuildContext context, List<Word> candidateData,
            List rejectedData) {
          return Column(
            children: <Widget>[
              candidateData.isEmpty
                  ? Container()
                  : Container(
                      height: 60,
                    ),
              candidateData.isEmpty ? Container(height: 60) : Container(),
            ],
          );
        },
      );
      return Column(
        children: <Widget>[d, lastTarget],
      );
    } else {
      return d;
    }
  }
}
