import 'package:flutter/material.dart';

class FriendDetails extends StatelessWidget{
  final MapEntry friend;

  FriendDetails({@required this.friend});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friend Details'),
      ),
      body: LayoutBuilder(
        builder: (context, viewPortConstraints) {
          return Column(
            children: <Widget>[
              Container(
                child: Center(
                  child: Text('$friend'),
                ),
              ),
              Row(
                children: <Widget>[
                  FlatButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Text('Cancel'),
                    ),
                  )
                ],
              )
            ],
          );
        },
      ),
    );
  }
}