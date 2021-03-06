// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class CardModel {
  CardModel(this.value, this.size, this.color);
  int value;
  Size size;
  Color color;
  String get label => 'Card $value';
  Key get key => new ObjectKey(this);
}

class PageViewApp extends StatefulWidget {
  @override
  PageViewAppState createState() => new PageViewAppState();
}

class PageViewAppState extends State<PageViewApp> {
  @override
  void initState() {
    super.initState();
    const List<Size> cardSizes = const <Size>[
      const Size(100.0, 300.0),
      const Size(300.0, 100.0),
      const Size(200.0, 400.0),
      const Size(400.0, 400.0),
      const Size(300.0, 400.0),
    ];

    cardModels = new List<CardModel>.generate(cardSizes.length, (int i) {
      final Color color = Color.lerp(Colors.red.shade300, Colors.blue.shade900, i / cardSizes.length);
      return new CardModel(i, cardSizes[i], color);
    });
  }

  static const TextStyle cardLabelStyle =
    const TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold);

  List<CardModel> cardModels;
  Size pageSize = const Size(200.0, 200.0);
  Axis scrollDirection = Axis.horizontal;
  bool itemsWrap = false;

  Widget buildCard(CardModel cardModel) {
    final Widget card = new Card(
      color: cardModel.color,
      child: new Container(
        width: cardModel.size.width,
        height: cardModel.size.height,
        padding: const EdgeInsets.all(8.0),
        child: new Center(child: new Text(cardModel.label, style: cardLabelStyle)),
      ),
    );

    final BoxConstraints constraints = (scrollDirection == Axis.vertical)
      ? new BoxConstraints.tightFor(height: pageSize.height)
      : new BoxConstraints.tightFor(width: pageSize.width);

    return new Container(
      key: cardModel.key,
      constraints: constraints,
      child: new Center(child: card),
    );
  }

  void switchScrollDirection() {
    setState(() {
      scrollDirection = (scrollDirection == Axis.vertical)
        ? Axis.horizontal
        : Axis.vertical;
    });
  }

  void toggleItemsWrap() {
    setState(() {
      itemsWrap = !itemsWrap;
    });
  }

  Widget _buildDrawer() {
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          new DrawerHeader(child: new Center(child: new Text('Options'))),
          new DrawerItem(
            icon: new Icon(Icons.more_horiz),
            selected: scrollDirection == Axis.horizontal,
            child: new Text('Horizontal Layout'),
            onPressed: switchScrollDirection,
          ),
          new DrawerItem(
            icon: new Icon(Icons.more_vert),
            selected: scrollDirection == Axis.vertical,
            child: new Text('Vertical Layout'),
            onPressed: switchScrollDirection,
          ),
          new DrawerItem(
            onPressed: toggleItemsWrap,
            child: new Row(
              children: <Widget>[
                new Expanded(child: new Text('Scrolling wraps around')),
                // TODO(abarth): Actually make this checkbox change this value.
                new Checkbox(value: itemsWrap, onChanged: null),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return new AppBar(
      title: new Text('PageView'),
      actions: <Widget>[
        new Text(scrollDirection == Axis.horizontal ? "horizontal" : "vertical"),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return new PageView(
      children: cardModels.map(buildCard).toList(),
      // TODO(abarth): itemsWrap: itemsWrap,
      scrollDirection: scrollDirection,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new IconTheme(
      data: const IconThemeData(color: Colors.white),
      child: new Scaffold(
        appBar: _buildAppBar(),
        drawer: _buildDrawer(),
        body: _buildBody(context),
      ),
    );
  }
}

void main() {
  runApp(new MaterialApp(
    title: 'PageView',
    theme: new ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      accentColor: Colors.redAccent,
    ),
    home: new PageViewApp(),
  ));
}
