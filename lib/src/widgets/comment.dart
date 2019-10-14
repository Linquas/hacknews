import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hack/src/widgets/loading_container.dart';

import '../models/item_model.dart';

class Comment extends StatelessWidget {
  final int itemId;
  final Map<int, Future<ItemModel>> itemMap;
  final int depth;

  Comment({this.itemId, this.itemMap, this.depth});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: itemMap[itemId],
      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        }

        final children = <Widget>[
          ListTile(
            title: buildText(snapshot.data),
            subtitle: snapshot.data.by == ""
                ? Text(snapshot.data.by)
                : Text("deleted"),
            contentPadding:
                EdgeInsets.only(right: 16.0, left: (depth + 1) * 16.0),
          ),
          Divider()
        ];

        snapshot.data.kids.forEach((kidId) {
          final comment = Comment(
            itemId: kidId,
            itemMap: itemMap,
            depth: depth + 1,
          );
          children.add(comment);
        });

        return Column(
          children: children,
        );
      },
    );
  }

  Widget buildText(ItemModel item) {
    final text = item.text
        .replaceAll('&#x27', " ' ")
        .replaceAll('<p>', '\n\n')
        .replaceAll('</p>', '');
    return Text(text);
  }
}
