import 'package:flutter/material.dart';

void main() => runApp(HomePage());

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My List'), // TODO: change with user's default list
          backgroundColor: const Color(0xFF2ECC40),
          leading: IconButton(
            tooltip: 'Menu',
            icon: const Icon(Icons.menu),
            onPressed: () => {},
          ),
          actions: <Widget>[
            IconButton(
              tooltip: 'More',
              icon: const Icon(Icons.more_vert),
              onPressed: () => {},
            ),
          ],
        ),
      ),
      theme: Theme.of(context).copyWith(
        primaryColor: Colors.black,
        // primaryColor: const Color(0xFF2ECC40),
      ),
    );
  }
}

class Item {
  String word;
  String description;
  String status;

  Item(this.word, this.description, status);

  Item.fromJson(Map<String, dynamic> json)
      : word = json['name'],
        description = json['deacription'];

  Map<String, dynamic> toJson() => {
        'word': word,
        'description': description,
      };
}

class ItemList extends List<Item> {}
