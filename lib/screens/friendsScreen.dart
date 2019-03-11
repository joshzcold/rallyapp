import 'package:flutter/material.dart';
import 'package:rallyapp/blocs/friends/friends.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FriendsScreen extends StatelessWidget{
  
  @override
  Widget build(BuildContext context) {
    final _friendsBloc = BlocProvider.of<FriendsBloc>(context);

    return BlocBuilder(
      bloc: _friendsBloc,
      builder: (BuildContext context, FriendsState state){
//        final data = (state as FriendsLoaded);
        print('what is friends: in the friends screen $friends');
        return Scaffold(
          body: Container(
            child: Text(''),
          ),
        );
      },
    );
  }
}


//builder: (context, child, model) => ListView(
//children: model.friendList.entries.map((item) => ListTile(
//leading: Container(
//width: 40.0,
//height: 40.0,
//decoration: new BoxDecoration(
//shape: BoxShape.circle,
//image: new DecorationImage(
//fit: BoxFit.fill,
//image: new NetworkImage(
//item.value['userPhoto'])
//)
//)),
//title: Text(item.value['userName']),
//trailing: Text(item.value['rallyID']),
//)).toList()