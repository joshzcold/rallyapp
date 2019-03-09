import 'package:flutter/material.dart';

class FriendsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FriendsScreenState();
}

class FriendsScreenState extends State<FriendsScreen>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Text("Friends Screen"),
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