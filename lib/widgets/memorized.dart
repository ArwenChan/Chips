import 'package:dict/states.dart';
import 'package:dict/widgets/memorizeditem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class MemorizedWords extends StatefulWidget {
  MemorizedWords({Key key}) : super(key: key);

  @override
  MemorizedWordsState createState() => MemorizedWordsState();
}

class MemorizedWordsState extends State<MemorizedWords> {
  List data;

  Widget _buildItem(BuildContext context, int index) {
    var item = data[index];
    return MemorizedItem(
      key: ValueKey('$index-${item['word']}'),
      word: item['word'],
    );
  }

  @override
  Widget build(BuildContext context) {
    data = Provider.of<DataSheet>(context).memorized;
    List<int> summary = _getSummary();
    return Stack(
      children: <Widget>[
        Container(
          child: ListView.builder(
            itemBuilder: _buildItem,
            itemCount: data.length,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: DecoratedBox(
            decoration: BoxDecoration(color: Colors.black87),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                DefaultTextStyle(
                  style: TextStyle(color: Colors.white54, height: 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text('Last week'),
                      Text('${summary[0]}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          )),
                      Text('words'),
                    ],
                  ),
                ),
                DefaultTextStyle(
                  style: TextStyle(color: Colors.white54, height: 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text('This month'),
                      Text('${summary[1]}',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                          )),
                      Text('words'),
                    ],
                  ),
                ),
                DefaultTextStyle(
                  style: TextStyle(color: Colors.white54, height: 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text('Total'),
                      Text('${summary[2]}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          )),
                      Text('words'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<int> _getSummary() {
    List<int> times = data.map((value) {
      int t = value['time'];
      return t;
    }).toList();
    DateTime d = DateTime.now();
    int d2 = d.subtract(Duration(days: d.weekday)).millisecond;
    int d1 = d.subtract(Duration(days: d.weekday + 7)).millisecond;
    int m2 = d.subtract(Duration(days: d.day)).millisecond;
    int m1 = d.subtract(Duration(days: d.day + 30)).millisecond;
    int lastWeek = times.where((v) {
      return v <= d2 && v >= d1;
    }).length;
    int lastMonth = times.where((v) {
      return v <= m2 && v >= m1;
    }).length;
    return [lastWeek, lastMonth, times.length];
  }
}
