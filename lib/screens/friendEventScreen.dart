import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rallyapp/blocs/auth/auth.dart';
import 'package:rallyapp/blocs/events/event.dart';
import 'package:rallyapp/fireActions.dart';


FireActions fireActions = new FireActions();

class FriendEvent extends StatelessWidget {
  final MapEntry event;
  FriendEvent({@required this.event});

  @override
  Widget build(BuildContext context) {
    var party = event.value['party'];
    var partyLimit = party['partyLimit'];

    var maxWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title:Text(event.value['userName'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          backgroundColor: Color(_getColorFromHex(event.value['color'])),
        ),
        body: ListView(
          children: <Widget>[
            Container(
                child: Stack(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              height: 30,
                            ),
                            CircleAvatar(
                              backgroundColor: Color(_getColorFromHex(event.value['color'])),
                              radius: 30,
                              backgroundImage: NetworkImage(event
                                  .value['userPhoto']),
                            ),
                            Container(
                              height: 20,
                            ),
                            Text(
                              'Start Time',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                              Container(
                                  height: 30,
                                  width: maxWidth * .80,
                                  decoration: BoxDecoration(
                                    border:
                                    Border.all(color: Color(0xFFdadce0), width: 1),
                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  child: Text(
                                    '${DateTime.fromMillisecondsSinceEpoch(event.value['start'])}',
                                    style: TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                            Container(
                              height: 20,
                            ),
                            Text('End Time',
                                style:
                                TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                            Container(
                                  height: 30,
                                  width: maxWidth * .80,
                                  decoration: BoxDecoration(
                                    border:
                                    Border.all(color: Color(0xFFdadce0), width: 1),
                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  child: Text(
                                    '${DateTime.fromMillisecondsSinceEpoch(event.value['end'])}',
                                    style: TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                            Container(
                              height: 20,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Text('Event Title',
                                        style:
                                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),

                                  ],
                                )
                              ],
                            ),
                            Container(height: 10,),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                  border: Border.all(
                                      color: Color(0xFFdadce0),
                                      width: 1)
                              ),
                              width: maxWidth/1.2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(event.value['title']),
                                ],
                              ),
                            ),
                            
                            Container(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Text('Party Limit',
                                        style:
                                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                                    Container(
                                      width: maxWidth * .20,
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons.group, color: Colors.grey),
                                          Container(width: 10,),
                                          Text(partyLimit)
                                        ],
                                      )

                                    )
                                  ],
                                ),
                                joinLeaveButton(context),
                              ],
                            )
                          ],
                        ),
                        Container(
                          height: 20,
                        ),
                        calculateJoinedFriendsWidget(context, event)
                      ],
                    ),
                  ],
                )
            )
          ],
        )
    );
  }
  int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  calculateJoinedFriendsWidget(context, event) {
    final _eventsBloc = BlocProvider.of<EventsBloc>(context);
    return BlocBuilder(bloc: _eventsBloc, builder: (context, state){
        var selectedEvents = state.events['${event.value['user']}'];
        var selectedEvent = selectedEvents['${event.key}'];
        var party = selectedEvent['party'];
        var friends = party['friends'];
        if(friends == null){
          return Container();
        } else{
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Joined Friends',
                  style:
                  TextStyle(fontStyle: FontStyle.italic ,fontSize: 15)),
              Column(
                children: friends.entries.map<Widget>((friend) => Card(
                  child: Container(
                      padding: EdgeInsets.all(0),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: 80,
                        width: 300,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            /// This Container is the Friend Images
                            Container(
                                width: 60.0,
                                height: 60.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image:
                                        new NetworkImage(friend.value['userPhoto'])))),

                            /// Friend User Name
                            Text(
                              friend.value['userName'],
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      )),
                )).toList(),
              ),
            ],
          );
        }
      },);
  }

  joinLeaveButton(context) {
    final _eventsBloc = BlocProvider.of<EventsBloc>(context);
    return BlocBuilder(bloc: _eventsBloc, builder: (context, state){
      var selectedEvents = state.events['${event.value['user']}'];
      var selectedEvent = selectedEvents['${event.key}'];
      var party = selectedEvent['party'];
      var friends = party['friends'];
      final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
      AuthLoaded auth =  authBloc.currentState;
      if(friends == null){
        return FlatButton(
            onPressed: (){
              fireActions.joinEvent(event.key, event.value['user'], context);
            },
            padding: EdgeInsets.all(0),
            child: Row(
              children: <Widget>[
                Container(width: 10,),
                Container(
                    decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.all(Radius.circular(8))),
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.flag, color: Colors.white,),
                        Container(width: 5,),
                        Text('Join Event', style: TextStyle(color: Colors.white, fontSize: 15),),
                      ],
                    )

                ),
              ],
            )
        );
      } else{
        if(friends[auth.key] != null){
          return FlatButton(
              onPressed: (){
                fireActions.leaveEvent(event.key, event.value['user'], context);
              },
              padding: EdgeInsets.all(0),
              child: Row(
                children: <Widget>[
                  Container(width: 10,),
                  Container(
                      decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(8))),
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.redo, color: Colors.white,),
                          Container(width: 5,),
                          Text('Leave Event', style: TextStyle(color: Colors.white, fontSize: 15),),
                        ],
                      )

                  ),
                ],
              )
          );
        } else{
          return FlatButton(
              onPressed: (){
                fireActions.joinEvent(event.key, event.value['user'], context);
              },
              padding: EdgeInsets.all(0),
              child: Row(
                children: <Widget>[
                  Container(width: 10,),
                  Container(
                      decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.all(Radius.circular(8))),
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.flag, color: Colors.white,),
                          Container(width: 5,),
                          Text('Join Event', style: TextStyle(color: Colors.white, fontSize: 15),),
                        ],
                      )

                  ),
                ],
              )
          );
        }
      }
    },);
  }
}



