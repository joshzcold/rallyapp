import 'package:flutter/material.dart';
import 'package:rallyapp/model/friendModel.dart';
import 'package:scoped_model/scoped_model.dart';


class Calendar extends StatelessWidget{

  FriendModel friendModel = FriendModel();

  @override
  Widget build(BuildContext context) {
    return new ScopedModel<FriendModel>(
      model: friendModel,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Friend Data",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: FriendsListToString()
      ),
    );
  }
}

class FriendsListToString extends StatelessWidget{
  BuildContext context;
  FriendModel model;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return ScopedModelDescendant<FriendModel>(
      builder: (context, child, model) => ListView(
      children: model.friendList.entries.map((item) => ListTile(
        leading: Container(
            width: 40.0,
            height: 40.0,
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: new NetworkImage(
                        item.value['userPhoto'])
                )
            )),
        title: Text(item.value['userName']),
        trailing: Text(item.value['rallyID']),
      )).toList()
      ),
    );
  }
}