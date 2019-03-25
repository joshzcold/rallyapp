import 'package:flutter/material.dart';

class UserEvent extends StatelessWidget {
  // Variable that gets data from parent about the event
  final MapEntry event;

  UserEvent({@required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Event'),
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
