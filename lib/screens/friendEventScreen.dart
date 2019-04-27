import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rallyapp/blocs/app/theme.dart';
import 'package:rallyapp/blocs/auth/auth.dart';
import 'package:rallyapp/blocs/events/event.dart';
import 'package:rallyapp/fireActions.dart';


FireActions fireActions = new FireActions();

class FriendEvent extends StatelessWidget {
  final String eventKey;
  final Map eventValue;

  const FriendEvent({
    @required this.eventKey,
    @required this.eventValue,
  });


  @override
  Widget build(BuildContext context) {
    var party = eventValue['party'];
    var partyLimit = party['partyLimit'];
    final _themeBloc = BlocProvider.of<ThemeBloc>(context);
    ThemeLoaded theme = _themeBloc.currentState;

    var maxWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: theme.theme['background'],
        appBar: AppBar(
          centerTitle: true,
          title:Text(eventValue['userName'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          backgroundColor: Color(_getColorFromHex(eventValue['color'])),
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
                              backgroundColor: Color(_getColorFromHex(eventValue['color'])),
                              radius: 30,
                              backgroundImage: NetworkImage(eventValue['userPhoto']),
                            ),
                            Container(
                              height: 20,
                            ),
                            Text(
                              'Event Time',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: theme.theme['textTitle']),
                            ),
                              Container(height: 10,),
                              Container(
                                padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    border:
                                    Border.all(color: theme.theme['border'], width: 1),
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    color: theme.theme['card']
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: returnTimeInPrettyFormat(eventValue, theme)
                                  )
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
                                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: theme.theme['textTitle'])),
                                  ],
                                )
                              ],
                            ),
                            Container(height: 10,),
                            Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: theme.theme['card'],
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                  border: Border.all(
                                      color: theme.theme['border'],
                                      width: 1)
                              ),
                              width: maxWidth/1.2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(eventValue['title'], style: TextStyle(color: theme.theme['text']),),
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
                                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: theme.theme['textTitle'])),
                                    Container(
                                      width: maxWidth * .20,
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons.group, color: Colors.grey),
                                          Container(width: 10,),
                                          Text(partyLimit, style: TextStyle(color: theme.theme['text']),)
                                        ],
                                      )

                                    )
                                  ],
                                ),
                                joinLeaveButton(context, theme),
                              ],
                            )
                          ],
                        ),
                        Container(
                          height: 20,
                        ),
                        calculateJoinedFriendsWidget(context, eventValue, theme)
                      ],
                    ),
                  ],
                )
            )
          ],
        )
    );
  }

  returnTimeInPrettyFormat(event,theme) {
    var sTime = DateTime.fromMillisecondsSinceEpoch(event['start']);
    var startTimeText = sTime.hour.toString();

    var eTime = DateTime.fromMillisecondsSinceEpoch(event['end']);
    var endTimeText = eTime.hour.toString();

    var sTimeInc;
    var eTimeInc;

    var sTimeMinuteText = sTime.minute.toString();
    var eTimeMinuteText = eTime.minute.toString();

    if(sTime.minute <10){
      sTimeMinuteText = "0"+(sTime.minute).toString();
    }

    if(eTime.minute <10){
      eTimeMinuteText = "0"+(eTime.minute).toString();
    }

    if(sTime.hour >= 12){
      sTimeInc = "PM";
      if(sTime.hour == 12){
        startTimeText = "12";
      } else{
        startTimeText = (sTime.hour - 12).toString();
      }
    } else{
      if(sTime.hour == 0){
        startTimeText = "12";
      }
      sTimeInc = "AM";
    }

    if(eTime.hour >= 12){
      eTimeInc = "PM";
      if(eTime.hour == 12){
        endTimeText = "12";
      } else{
        endTimeText = (eTime.hour - 12).toString();
      }
    } else{
      if(eTime.hour == 0){
        endTimeText = "12";
      }
      eTimeInc = "AM";
    }

    return [
      Icon(Icons.access_time, color: theme.theme['solidIconDark'],),
      Container(
        width: 10,
      ),
      Text(
        '${calculateWeekDayAbbrv(sTime.weekday)}  ${sTime.month}/${sTime.day}',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.theme['text'],
        ),
      ),
      Container(
        width: 10,
      ),
      Text('$startTimeText:$sTimeMinuteText $sTimeInc- $endTimeText:$eTimeMinuteText $eTimeInc', style: TextStyle(color: theme.theme['text']),),
    ];
  }

  calculateWeekDayAbbrv(int weekday) {
    var result = "";
    switch (weekday) {
      case 1:
        result = "M";
        break;
      case 2:
        result = "T";
        break;
      case 3:
        result = "W";
        break;
      case 4:
        result = "T";
        break;
      case 5:
        result = "F";
        break;
      case 6:
        result = "S";
        break;
      case 7:
        result = "S";
        break;
    }
    return result;
  }

  int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  calculateJoinedFriendsWidget(context, event, theme) {
    final _eventsBloc = BlocProvider.of<EventsBloc>(context);
    return BlocBuilder(bloc: _eventsBloc, builder: (context, state){
        var selectedEvents = state.events['${eventValue['user']}'];
        var selectedEvent = selectedEvents['${eventKey}'];
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
                  TextStyle(fontStyle: FontStyle.italic ,fontSize: 15, color: theme.theme['text'])),
              Column(
                children: friends.entries.map<Widget>((friend) => Card(
                  color: theme.theme['card'],
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
                            CircleAvatar(
                              backgroundColor: theme.theme['card'],
                              radius: 30,
                              backgroundImage: NetworkImage(friend.value['userPhoto']),
                            ),
                            Container(width: 5,),
                            /// Friend User Name
                            Flexible(
                              child: new Container(
                                padding: new EdgeInsets.only(right: 13.0),
                                child: new Text(
                                  friend.value[
                                  'userName'],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 20, color: theme.theme['textTitle']),
                                ),
                              ),
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

  joinLeaveButton(context, theme) {
    final _eventsBloc = BlocProvider.of<EventsBloc>(context);
    return BlocBuilder(bloc: _eventsBloc, builder: (context, state){
      var selectedEvents = state.events['${eventValue['user']}'];
      var selectedEvent = selectedEvents['$eventKey'];
      var party = selectedEvent['party'];
      var friends = party['friends'];
      final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
      AuthLoaded auth =  authBloc.currentState;
      if(friends == null){
        return FlatButton(
            onPressed: (){
              fireActions.joinEvent(eventKey, eventValue['user'], context);
            },
            padding: EdgeInsets.all(0),
            child: Row(
              children: <Widget>[
                Container(width: 10,),
                Container(
                    decoration: BoxDecoration(color: theme.theme['colorAttention'], borderRadius: BorderRadius.all(Radius.circular(8))),
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
                fireActions.leaveEvent(eventKey, eventValue['user'], context);
              },
              padding: EdgeInsets.all(0),
              child: Row(
                children: <Widget>[
                  Container(width: 10,),
                  Container(
                      decoration: BoxDecoration(color: theme.theme['colorSecondary'], borderRadius: BorderRadius.all(Radius.circular(8))),
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
                fireActions.joinEvent(eventKey, eventValue['user'], context);
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



