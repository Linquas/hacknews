import 'package:flutter/material.dart';
import 'package:hack/src/blocs/story_bloc.dart';
import 'package:hack/src/widgets/news_list_tile.dart';
import 'package:hack/src/widgets/refresh.dart';

import '../blocs/stories_provider.dart';

class NewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Top News')),
      body: buildList(bloc),
    );
  }

  Widget buildList(StoriesBloc bloc) {
    return StreamBuilder(
      stream: bloc.topIds,
      builder: (context, AsyncSnapshot<List<int>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Refresh(
              child: ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, int index) {
              bloc.fetchitem(snapshot.data[index]);

              return NewsListTile(itemId: snapshot.data[index]);
            },
          ));
        }
      },
    );
  }
}
