import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dict/models/word.dart';
import 'package:dict/states.dart';
import 'package:dict/widgets/list.dart';
import 'package:dict/widgets/triangle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:dict/routes/home.dart';
import 'package:provider/provider.dart';

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
    @required list,
    @required this.animation,
    @required this.index,
    Function remove,
  })  : this.removeSelf = remove,
        this.dataList = list,
        super(key: key);
  final Word data;
  final List<Word> dataList;
  final int index;
  final Animation<double> animation;
  final Function removeSelf;

  List<Map<String, String>> get defs {
    return data.defs;
  }

  String get word {
    return data.word;
  }

  bool get statusIsTag {
    return data.status == 'tag';
  }

  // memory stands for in memory, it's almost in UI.
  bool get statusIsMemory {
    return data.status == 'memory';
  }

  @override
  _ItemState createState() => _ItemState();

  Widget translationCombined() {
    List<Widget> unfoldedWidgets = [];
    for (int i = 0; i < defs.length; i++) {
      unfoldedWidgets.addAll([
        Text(
          defs[i]['pos'] + ' ',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.grey[100].withOpacity(0.6)),
        ),
        Text(
          '${defs[i]['def']}${i == defs.length - 1 ? '' : '  '}',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
        )
      ]);
    }
    return Row(children: unfoldedWidgets);
  }
}

class _ItemState extends State<Item> {
  double _left = 0;
  double _right = 0;
  bool showFront = true;
  final ScrollController itemRoller = ScrollController(keepScrollOffset: false);

  int get rightState {
    if (_right > 0) {
      return _right <= rightExtent[1] ? 1 : 2;
    }
    return 0;
  }

  HomeListState get homeState => context.findAncestorStateOfType();

  WordsState get listState => context.findAncestorStateOfType();

  Size get screenSize {
    return MediaQuery.of(context).size;
  }

  // for some reason, front text not show after turn back with a roll,
  // this is a fix.
  void turnFrontShow() {
    setState(() {
      showFront = !showFront;
    });
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
                    if (homeState.inPull) return;
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
                    homeState.inDrag = true;
                  },
                  onHorizontalDragEnd: (DragEndDetails details) {
                    if (homeState.inPull || !homeState.inDrag) return;
                    if (_left > 0) {
                      homeState.assetsAudioPlayer.open(
                        Audio("assets/sounds/finger.mp3"),
                        volume: 1.0,
                      );
                      setState(() {
                        Provider.of<DataSheet>(context, listen: false)
                            .dataChangeStatus(widget.index,
                                widget.statusIsTag ? 'normal' : 'tag');
                        _left = 0;
                        _right = 0;
                      });
                    } else if (_right > 0) {
                      if (_right <= rightExtent[1]) {
                        homeState.assetsAudioPlayer.open(
                          Audio("assets/sounds/sou1.mp3"),
                        );
                        setState(() {
                          Provider.of<DataSheet>(context, listen: false)
                              .dataChangeStatus(widget.index,
                                  widget.statusIsMemory ? 'normal' : 'memory');
                          _left = 0;
                          _right = 0;
                        });
                      } else {
                        homeState.assetsAudioPlayer.open(
                          Audio("assets/sounds/sou2.mp3"),
                        );
                        _left = 0;
                        _right = 0;
                        widget.removeSelf();
                      }
                    }
                    homeState.inDrag = false;
                  },
                  child: WidgetFlipper(
                    roller: itemRoller,
                    update: turnFrontShow,
                    whenTap: () async {
                      try {
                        await homeState.assetsAudioPlayer.open(
                          Audio.network(widget.data.pronunciations[
                              Provider.of<UserSetting>(context, listen: false)
                                  .pronunciation]),
                        );
                      } catch (t) {
                        debugPrint(t.toString());
                      }
                    },
                    frontWidget: TriangleCorner(
                      width: widget.statusIsTag ? 16 : 0,
                      widget: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 20),
                        color: widget.statusIsMemory
                            ? Colors.grey[300]
                            : Colors.white,
                        child: Text(
                          showFront ? widget.word : '',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w400,
                            color: widget.statusIsMemory
                                ? Colors.grey[500]
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    backWidget: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                      color: Theme.of(context).primaryColor,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: widget.translationCombined(),
                        controller: itemRoller,
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
