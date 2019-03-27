import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:rallyapp/blocs/auth/auth.dart';
import 'package:rallyapp/blocs/friends/friends.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rallyapp/blocs/events/event.dart';
import 'package:rallyapp/screens/friendEventScreen.dart';
import 'package:rallyapp/screens/friendDetailsScreen.dart';
import 'package:rallyapp/screens/newFriendScreen.dart';
import 'package:rallyapp/screens/settingsScreen.dart';

class FriendsScreen extends StatefulWidget {
  @override
  FriendsScreenState createState() => FriendsScreenState();
}

class FriendsScreenState extends State<FriendsScreen> {
  var expanded = {};
  var friendCardHeight = 110.0;
  var eventsSection = {};

  @override
  Widget build(BuildContext context) {
    final _friendsBloc = BlocProvider.of<FriendsBloc>(context);
    final _authBloc = BlocProvider.of<AuthBloc>(context);
    final _eventsBloc = BlocProvider.of<EventsBloc>(context);

    return Scaffold(
      body: BlocBuilder(
          bloc: _friendsBloc,
          builder: (BuildContext context, state) {
            /// NO FRIENDS ARE LOADED
            if (state is FriendsLoading) {
              print('FriendsLoading...');
              return Center(
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const ListTile(
                        leading: Icon(Icons.insert_emoticon),
                        title: Text('NO FRIENDS'),
                        subtitle: Text(
                            'Try sending your rallyID to your friends using Rally'),
                      ),
                      ButtonTheme.bar(
                        // make buttons use the appropriate styles for cards
                        child: ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              child: const Text('ADD FRIEND'),
                              onPressed: () {
                                /* ... */
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );

              /// FRIENDS ARE LOADED
            } else if (state is FriendsLoaded) {
              state.friends.forEach((k, friend) {
                if (eventsSection[k] != Container()) {
                  if (eventsSection[k] == null) {
                    eventsSection[k] = Container();
                    expanded[k] = false;
                  }
                }
              });
              print('FriendsLoaded: ${state.friends.entries}');
              return LayoutBuilder(
                builder: (context, constraints) {
                  var userCardWidth = constraints.maxWidth * .80;
                  var userCardHeight = constraints.maxHeight / 4;
                  var friendCardWidth = constraints.maxWidth * .95;
                  return Container(
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,

                      /// THIS MAKES THE WHOLE PAGE SCROLLABLE
                      child: ListView(
                        children: <Widget>[
                          BlocBuilder(
                              bloc: _authBloc,
                              builder: (context, auth) {
                                /// User Card
                                return userCard(
                                    userCardHeight, userCardWidth, auth);
                              }),
                          /// Spacer
                          Container(
                            height: 50,
                          ),
                          /// Friends Label and the friends list
                          Container(
                              height: 30,
                              width: friendCardWidth,
                              child: Text(
                                'Friends',
                                style: TextStyle(
                                    fontSize: 20, fontStyle: FontStyle.italic),
                              )),
                          LayoutBuilder(
                              builder: (context, friendViewConstraints) {
                            return Column(
                                /// FRIENDS LIST BUILDER
                                children: state.friends.entries
                                    .map<Widget>((friend) => BlocBuilder(
                                          bloc: _eventsBloc,
                                          builder: (context, state) {
                                            var events = state.events[friend.key];
                                            var eventsPassedToday = {};

                                            DateTime currentTime = DateTime.now();
                                            if (events != null) {
                                              // forEach to find events passed today
                                              events.forEach((k, event) {
                                                if (event['end'] >
                                                    currentTime.millisecondsSinceEpoch) {
                                                  eventsPassedToday.addAll({k: event});
                                                }
                                              });
                                              // after sorting, add events in order
                                            }
                                            // set those events to the sorted events.
                                            if (eventsPassedToday.length > 0) {
                                              /// EVENTS IN FUTURE
                                              return Stack(
                                                children: <Widget>[
                                                  Card(
                                                      child: Container(
                                                    child: Column(
                                                      children: <Widget>[
                                                        FlatButton(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            onPressed: () {
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => FriendDetails(friend: friend,)));
                                                            },
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                              height: 80,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: <
                                                                    Widget>[
                                                                  /// This Container is the Friend Images
                                                                  CircleAvatar(
                                                                    radius: 30,
                                                                    backgroundImage:
                                                                        NetworkImage(
                                                                            friend.value['userPhoto']),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                  ),

                                                                  /// Friend User Name
                                                                  Text(
                                                                    friend.value[
                                                                        'userName'],
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            20),
                                                                  ),

                                                                  /// Friend RallyID
                                                                  Text(
                                                                    friend.value[
                                                                        'rallyID'],
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            20),
                                                                  )
                                                                ],
                                                              ),
                                                            )),
                                                        AnimatedSwitcher(
                                                          // the duration can be adjusted to expand the friend events
                                                          // faster or slower.
                                                          duration: Duration(
                                                              milliseconds:
                                                                  300),
                                                          transitionBuilder:
                                                              (Widget child,
                                                                  Animation<
                                                                          double>
                                                                      animation) {
                                                            return SizeTransition(
                                                              sizeFactor:
                                                                  animation,
                                                              child: child,
                                                            );
                                                          },
                                                          child: eventsSection[friend.key],
                                                        ),
                                                        Container(
                                                          height: 30,
                                                          width:
                                                              friendCardWidth,
                                                          child: FlatButton(
                                                              child: Center(
                                                                child: Icon(Icons
                                                                    .keyboard_arrow_down),
                                                              ),
                                                              onPressed: () {
                                                                toggleFriendEventsExpand(
                                                                    friend,
                                                                    friendCardWidth,
                                                                    eventsPassedToday,
                                                                    friendViewConstraints,
                                                                    _eventsBloc);
                                                              }),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                                  Positioned(
                                                    top: 4,
                                                    right: 0,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors
                                                              .green[700]),
                                                      width: 29,
                                                      child: Text(
                                                        "${eventsPassedToday.length}",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18.0),
                                                      ),
                                                      alignment:
                                                          FractionalOffset(
                                                              0.5, 0.5),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            } else {
                                              /// NO EVENTS IN FUTURE
                                              return noFutureEventsFriendItem(
                                                  friend);
                                            }
                                          },
                                        ))
                                    .toList());
                          }),
                        ],
                      ));
                },
              );
            }
          }),
      floatingActionButton: Container(
        child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NewFriend()));
            },
            backgroundColor: Colors.blue,
            child: Icon(Icons.group_add)),
      ),
    );
  }

  void toggleFriendEventsExpand(
      friend, friendCardWidth, eventsPassedToday, friendViewConstraints, _eventsBloc) {
    if (expanded[friend.key]) {
      setState(() {
        friendCardHeight = 140;
        eventsSection[friend.key] = Container();
        expanded[friend.key] = false;
      });
    } else {
      ///SetState for events processed on each friend card
      setState(() {
        friendCardHeight = friendViewConstraints.maxHeight;

        eventsSection[friend.key] = BlocBuilder(
          bloc: _eventsBloc, builder: (context, state){
          var events = state.events[friend.key];
          var eventsPassedToday = {};
          var sortedEvents = {};
          var listOfTimes = [];

          DateTime currentTime = DateTime.now();
          if (events != null) {
            // forEach to find events passed today
            events.forEach((k, event) {
              if (event['end'] >
                  currentTime.millisecondsSinceEpoch) {
                eventsPassedToday.addAll({k: event});
                listOfTimes.add(event['start']);
              }
            });
            listOfTimes..sort();
            // after sorting, add events in order
            for(var time in listOfTimes){
              eventsPassedToday.forEach((k,value){
                if(time == value['start']){
                  sortedEvents.addAll({k:value});
                }
              });
            }
          }
            eventsPassedToday = sortedEvents;
            return Column(
              children: <Widget>[
                Container(
                  height: 30,
                  width: friendCardWidth,
                  child: FlatButton(
                      child: Center(
                        child: Icon(Icons.keyboard_arrow_up),
                      ),
                      onPressed: () {
                        toggleFriendEventsExpand(friend, friendCardWidth,
                            eventsPassedToday, friendViewConstraints, _eventsBloc);
                      }),
                ),
                Column(
                    mainAxisSize: MainAxisSize.min,
                    children: eventsPassedToday.entries
                        .map<Widget>((event) => Container(
                      height: 100,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: BorderDirectional(
                              top: BorderSide(
                                  color: Color(_getColorFromHex(
                                      event.value['color'])),
                                  width: 20))),
                      child: FlatButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => FriendEvent(event: event,)));
                          },
                          child: Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                      children:
                                      returnTimeInPrettyFormat(event)),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      /// Friend User Name
                                      Text(
                                        'Title: ${event.value['title']}',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ],
                              ))),
                    ))
                        .toList())
              ],
            );
        },
        );
        expanded[friend.key] = true;
      });
    }
  }

  // Didn't want to do this function, but all our color values are in hex format
  int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  Widget userCard(userCardHeight, userCardWidth, auth) {
    return Card(
        child: Container(
            height: userCardHeight,
            width: userCardWidth,
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: IconButton(
                    color: Colors.grey,
                      icon: Icon(Icons.settings),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
                      }),
                  top: 0,
                  right: 0,
                ),
                Positioned(
                  top: userCardHeight/5,
                  left: userCardWidth/8,
                  width: userCardWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      /// User Photo
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: userCardHeight / 4,
                        backgroundImage: NetworkImage(auth.value['userPhoto']),
                      ),

                      /// User Name
                      Text(
                        '${auth.value['userName']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                ),

                /// User RallyID
                Positioned(
                  child: Center(
                      child: Text(
                    'Rally ID: ${auth.value['rallyID']}',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 20,
                    ),
                  )),
                  bottom: 10,
                  width: userCardWidth,
                )
              ],
            )));
  }

  returnTimeInPrettyFormat(event) {
    var startTime = DateTime.fromMillisecondsSinceEpoch(event.value['start']);
    var startDay = startTime.day.toString();
    var startMonth = startTime.month.toString();
    var startHour = startTime.hour.toString();
    var startMinute = ':' + startTime.minute.toString();

    var endTime = DateTime.fromMillisecondsSinceEpoch(event.value['end']);
//    var endMonth = endTime.month.toString();
    var endHour = endTime.hour.toString();
    var endMinute = ':' + endTime.minute.toString();
    var indicator = "AM";
    if (startTime.hour * 60 + startTime.minute > 720) {
      indicator = "PM";
    }

    switch (startHour) {
      case "0":
        startHour = "12";
        indicator = "AM";
        break;
      case "13":
        startHour = "1";
        indicator = "PM";
        break;
      case "14":
        startHour = "2";
        indicator = "PM";
        break;
      case "15":
        startHour = "3";
        indicator = "PM";
        break;
      case "16":
        startHour = "4";
        indicator = "PM";
        break;
      case "17":
        startHour = "5";
        indicator = "PM";
        break;
      case "18":
        startHour = "6";
        indicator = "PM";
        break;
      case "19":
        startHour = "7";
        indicator = "PM";
        break;
      case "20":
        startHour = "8";
        indicator = "PM";
        break;
      case "21":
        startHour = "9";
        indicator = "PM";
        break;
      case "22":
        startHour = "10";
        indicator = "PM";
        break;
      case "23":
        startHour = "11";
        indicator = "PM";
        break;
      case "24":
        startHour = "12";
        indicator = "AM";
        break;
    }

    switch (endHour) {
      case "13":
        endHour = "1";
        indicator = "PM";
        break;
      case "14":
        endHour = "2";
        indicator = "PM";
        break;
      case "15":
        endHour = "3";
        indicator = "PM";
        break;
      case "16":
        endHour = "4";
        indicator = "PM";
        break;
      case "17":
        endHour = "5";
        indicator = "PM";
        break;
      case "18":
        endHour = "6";
        indicator = "PM";
        break;
      case "19":
        endHour = "7";
        indicator = "PM";
        break;
      case "20":
        endHour = "8";
        indicator = "PM";
        break;
      case "21":
        endHour = "9";
        indicator = "PM";
        break;
      case "22":
        endHour = "10";
        indicator = "PM";
        break;
      case "23":
        endHour = "11";
        indicator = "PM";
        break;
      case "24":
        endHour = "12";
        indicator = "PM";
        break;
    }

    if (startMinute == ":0") {
      startMinute = "";
    }
    if (endMinute == ":0") {
      endMinute = "";
    }

    return [
      Text(
        '$startMonth/$startDay',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
          'From: $startHour$startMinute$indicator To: $endHour$endMinute$indicator')
    ];
  }

  Widget noFutureEventsFriendItem(friend) {
    return Card(
      child: FlatButton(
          padding: EdgeInsets.all(0),
          onPressed: () {
            print('touched: $friend');
          },
          child: Container(
            padding: EdgeInsets.all(10),
            height: 80,
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

                /// Friend RallyID
                Text(
                  friend.value['rallyID'],
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
          )),
    );
  }
}
