import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rallyapp/blocs/app/notifyBloc.dart';
import 'package:rallyapp/blocs/app/theme.dart';
import 'package:rallyapp/fireActions.dart';
import 'package:rallyapp/screens/newEventScreen.dart';

class FriendDetails extends StatelessWidget{
  final MapEntry friend;

  FriendDetails({@required this.friend});

  @override
  Widget build(BuildContext context) {
    final _themeBloc = BlocProvider.of<ThemeBloc>(context);
    ThemeLoaded theme = _themeBloc.currentState;

    final _notifyBloc = BlocProvider.of<NotifyBloc>(context);
    FireActions fireActions = new FireActions();

    return Scaffold(
      backgroundColor: theme.theme['background'],
      appBar: AppBar(
        backgroundColor: theme.theme['header'],
        title: Text('Friend Details'),
      ),
      body: BlocBuilder(
        bloc: _notifyBloc,
        builder: (context,notify){
          var notifyEvent = true;
          var notifyJoined = true;
          var thisFriend = notify.notify[friend.key];

          if(thisFriend['notifyEvent'] != null){
            notifyEvent = thisFriend['notifyEvent'];}

          if(thisFriend['notifyJoined'] != null){
            notifyJoined = thisFriend['notifyJoined'];}


          return ListView(
            children: <Widget>[
              Card(
                  color: theme.theme['card'],
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 10,
                      ),
                      CircleAvatar(
                        backgroundColor: theme.theme['card'],
                        radius: 50,
                        backgroundImage: NetworkImage(friend.value['userPhoto']),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          /// User Name
                          Expanded(
                              child: Center(
                                child: Text(
                                  '${friend.value['userName']}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                      color: theme.theme['textTitle']
                                  ),
                                ),
                              )
                          )
                        ],
                      ),
                      Container(height: 10,),
                      Text(
                        'Rally ID: ${friend.value['rallyID']}',
                        style: TextStyle(
                          color: theme.theme['text'],
                          fontSize: 20,
                        ),
                      ),
                      Container(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          Container(width: 10,),
                          FlatButton(
                              onPressed: () {
                                Clipboard.setData(new ClipboardData(text:friend.value['rallyID']));
                                Scaffold.of(context).showSnackBar(new SnackBar(
                                    content: new Row(
                                      children: <Widget>[
                                        Text('Copied RallyID: ${friend.value['rallyID']}'),
                                        Container(width: 15, height: 10,),
                                        Icon(Icons.arrow_forward),
                                        Container(width: 5, height: 10,),
                                        Icon(Icons.content_paste),
                                      ],
                                    )
                                ));
                              },
                              padding: EdgeInsets.all(0),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      decoration: BoxDecoration(color: theme.theme['colorSecondary'], borderRadius: BorderRadius.all(Radius.circular(8))),
                                      padding: EdgeInsets.all(10.0),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons.content_paste, color: Colors.white,),
                                          Container(width: 5,),
                                          Text('Copy RallyID', style: TextStyle(color: Colors.white, fontSize: 15),),
                                        ],
                                      )
                                  ),
                                ],
                              )
                          ),
                        ],
                      ),
                    ],
                  )
              ),
              Row(
                children: <Widget>[
                  Container(width: 10,),
                  Text('Notifications',
                    style: TextStyle(
                        fontSize: 20, fontStyle: FontStyle.italic, color: theme.theme['text']),)
                ],
              ),
              Card(
                  color: theme.theme['card'],
                  child: Column(
                      children: <Widget>[
                        Container(height: 10,),
                        Row(
                          children: <Widget>[
                            Container(width: 10,),
                            Text('Send me a notification when this user:',
                              style: TextStyle(
                                  fontSize: 14, fontStyle: FontStyle.italic, color: theme.theme['text']),)
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(width: 10,),
                            Text('Creates a new event',
                              style: TextStyle(
                                  fontSize: 14, fontStyle: FontStyle.italic, color: theme.theme['text']),),
                            Container(width: 10,),
                            Switch(
                              activeColor: theme.theme['colorPrimary'],
                              value: notifyEvent,
                              onChanged: (value){
                                print('changing notifyEvent to $value');
                                fireActions.updateNotifyOnFriend(friend.key, "notifyEvent", value);
                              },
                            )
                          ],
                        ),

                        Row(
                          children: <Widget>[
                            Container(width: 10,),
                            Text('Joins your events',
                              style: TextStyle(
                                  fontSize: 14, fontStyle: FontStyle.italic, color: theme.theme['text']),),
                            Container(width: 10,),
                            Switch(
                              activeColor: theme.theme['colorPrimary'],
                              value: notifyJoined,
                              onChanged: (value){
                                print('changing notifyJoined to $value');
                                fireActions.updateNotifyOnFriend(friend.key, "notifyJoined", value);
                              },
                            )
                          ],
                        ),
                      ]
                  )
              ),

              Container(height: 40,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  LoadingButton(friend: friend)
                ],
              ),

              Container(height: 40,),
            ],
          );
        },
      )
    );
  }
}

class LoadingButton extends StatefulWidget {
  final MapEntry friend;

  LoadingButton({@required this.friend});

  @override
  LoadingButtonState createState() => LoadingButtonState(friend: friend);
}

class LoadingButtonState extends State<LoadingButton>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  final MapEntry friend;

  LoadingButtonState({@required this.friend});


  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final _themeBloc = BlocProvider.of<ThemeBloc>(context);
    ThemeLoaded theme = _themeBloc.currentState;

    return GestureDetector(
      onTapDown: (_) => controller.forward(),
      onTapUp: (_) {
        if (controller.status == AnimationStatus.forward) {
          controller.reverse();
        } else{
          print("Unfriend button animation done");
          Navigator.pop(context);
          fireActions.removeFriend(friend.key);
        }
      },
      child: Container(
    decoration: BoxDecoration(color: theme.theme['colorDanger'], borderRadius: BorderRadius.all(Radius.circular(8))),
    padding: EdgeInsets.all(10.0),
    child:
      Row(
        children: <Widget>[
          Text('Unfriend', style: TextStyle(color: Colors.white, fontSize: 15),),
          Container(width: 20,),
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                value: 1.0,
                valueColor: AlwaysStoppedAnimation<Color>(theme.theme['colorDanger']),
              ),
              CircularProgressIndicator(
                value: controller.value,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              Icon(Icons.cancel, color: Colors.white,)
            ],
          ),
        ],
      )
      )
    );
  }
}