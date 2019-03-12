import 'package:flutter/material.dart';
import 'package:rallyapp/blocs/friends/friends.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FriendsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _friendsBloc = BlocProvider.of<FriendsBloc>(context);

    return Scaffold(
      body: BlocBuilder(
          bloc: _friendsBloc,
          builder: (BuildContext context, state) {
            if (state is FriendsLoading) {
              print('FriendsLoading...');
              return new Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is FriendsLoaded) {
              print('FriendsLoaded: ${state.friends.entries}');
              return new Container(
                  child: ListView(
                      children: state.friends.entries
                          .map<Widget>((item) => ListTile(
                                leading: Container(
                                    width: 40.0,
                                    height: 40.0,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: new NetworkImage(
                                                item.value['userPhoto'])))),
                                title: Text(item.value['userName']),
                                trailing: Text(item.value['rallyID']),
                              ))
                          .toList()));
            }
          }),
    );
  }
}