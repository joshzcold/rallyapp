import 'package:flutter/material.dart';

class FriendEvent extends StatelessWidget{
  final MapEntry event;

  FriendEvent({@required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friend Event'),
      ),
      body: LayoutBuilder(
        builder: (context, viewPortConstraints) {
          return Column(
            children: <Widget>[
              Container(
                child: Center(
                  child: Text('$event'),
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