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
      builder: (context, child, model) {
        this.model = model;
        return Text(model.friendList.toString());
      },
    );
  }
}