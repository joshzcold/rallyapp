import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:rallyapp/blocs/app/invite.dart';
import 'package:rallyapp/blocs/auth/auth.dart';
import 'package:rallyapp/blocs/friends/friends.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rallyapp/blocs/events/event.dart';
import 'package:rallyapp/fireActions.dart';
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
  Widget newFriendModal = Container();
  Widget newFriendErrorMessage = Container();
  TextEditingController newFriendTextController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final _friendsBloc = BlocProvider.of<FriendsBloc>(context);
    final _authBloc = BlocProvider.of<AuthBloc>(context);
    final _eventsBloc = BlocProvider.of<EventsBloc>(context);
    final _invitesBloc = BlocProvider.of<InviteBloc>(context);
    var maxPossibleWidth = MediaQuery.of(context).size.width;
    FireActions fireActions = new FireActions();
    AuthLoaded auth =  _authBloc.currentState;


    return Scaffold(
      bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 55,
            child: Row(
              children: <Widget>[
                FlatButton(
                    padding: EdgeInsets.all(0),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child:  Container(
                      width: maxPossibleWidth/2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.calendar_today, color: Colors.grey,),
                          Text('Calendar', style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),)
                        ],
                      ),
                    )),
                FlatButton(
                  padding: EdgeInsets.all(0),
                  onPressed: (){},
                  child: Container(
                      width: maxPossibleWidth/2,
                      child: LayoutBuilder(builder: (context, constraints){
                        return Stack(
                          children: <Widget>[
                            Center(
                              child: Column(
                                children: <Widget>[
                                  Icon(Icons.group, color: Colors.blue,),
                                  Text('Friends', style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),),
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                            ),
                            BlocBuilder(bloc: _invitesBloc, builder: (context, state){
                              if(state is InvitesLoaded && state.invites.length > 0){
                                return Positioned(
                                    top: constraints.maxHeight/4 - 5,
                                    left: constraints.maxWidth/2 + 5,
                                    child: Container(
                                        height: 15,
                                        width: 15,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.green
                                        ),
                                        child: Center(
                                          child:Text('${state.invites.length}', style:
                                          TextStyle(color: Colors.white, fontSize: 14),),
                                        )
                                    ));
                              } else{
                                return Container();
                              }
                            },),
                          ],
                        );
                      })

                  ),
                )
              ],
            ),
          )
      ),
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
                                Navigator.push(context, MaterialPageRoute(builder: (context) => NewFriend()));
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
                  var friendCardWidth = constraints.maxWidth * .90;
                  return Stack(
                    children: <Widget>[
                      /// EVERYTHING IN FRIENDS SCREEN
                  Container(
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


                          /// Show Invites if they exist
                          BlocBuilder(bloc: _invitesBloc, builder: (context, state){
                            if(state is InvitesLoaded && state.invites.length > 0){
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(width: 10,),
                                      Text('Friend Invites', style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                                      ),
                                    ],
                                  ),
                                  Column(
                                      children: state.invites.entries.map<Widget>((invite) =>
                                          Card(
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              height: 80,
                                              width: friendCardWidth,
                                              child: LayoutBuilder(builder: (context, constraints){
                                                return Container(
                                                  width: constraints.maxWidth,
                                                  height: constraints.maxHeight,
                                                  child: Row(
                                                    children: <Widget>[
                                                      /// Invite RallyID
                                                      Container(
                                                        width: constraints.maxWidth - 110,
                                                        child: Text(
                                                          invite.value['rallyID'],
                                                          style: TextStyle(fontSize: 20),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: (){
                                                          fireActions.acceptInvite(invite, context);
                                                        },
                                                        child: Container(
                                                          width: 50,
                                                          height: 30,
                                                          decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.all(Radius.circular(8))),
                                                          child:Icon(Icons.check, color: Colors.white,),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 10,
                                                      ),
                                                      InkWell(
                                                        onTap: (){
                                                          fireActions.declineInvite(invite, context);
                                                        },
                                                        child: Container(
                                                          width: 50,
                                                          height: 30,
                                                          decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(8))),
                                                          child:Icon(Icons.clear, color: Colors.white,),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }),
                                            ),
                                          )
                                      ).toList()
                                  ),
                                ],
                              );
                            } else{
                              return Container();
                            }
                          }),


                          /// Friends Label and the friends list
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(width: 10,),
                              Text('Friends',
                                style: TextStyle(
                                    fontSize: 20, fontStyle: FontStyle.italic),
                              )
                            ],
                          ),
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
                                                    width: friendCardWidth,
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
                                              friend, friendCardWidth);
                                        }
                                      },
                                    ))
                                        .toList());
                              }),
                        ],
                      )),
                  /// Modal that will show on top of friends screen
                  AnimatedSwitcher(
                    // the duration can be adjusted to expand the friend events
                    // faster or slower.
                      duration: Duration(milliseconds: 300),
                      transitionBuilder: (Widget child, Animation<double>animation) {
                        return FadeTransition(opacity: animation,
                          child: child,
                        );
                      },
                      child: newFriendModal
                  ),
                  AnimatedSwitcher(
                    // the duration can be adjusted to expand the friend events
                    // faster or slower.
                      duration: Duration(milliseconds: 100),
                      transitionBuilder: (Widget child, Animation<double>animation) {
                        return FadeTransition(opacity: animation,
                          child: child,
                        );
                      },
                      child: newFriendErrorMessage
                  ),
                    ],
                  );
                },
              );
            }
          }),
      floatingActionButton: Container(
        child: FloatingActionButton(
            onPressed: () {
              setState(() {
                newFriendModal = InkWell(
                  onTap: (){
                    setState(() {
                      newFriendModal = Container();
                    });
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.5)),
                    alignment: Alignment.center,
                    child: Container(
                        height: MediaQuery.of(context).size.height * .35,
                        width: MediaQuery.of(context).size.width * .95,
                        child: Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text('New Friend', style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 20
                                  ),),
                                ],
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Container(
                                    width: (MediaQuery.of(context).size.width * .95) * .80,
                                    child: TextField(
                                      controller: newFriendTextController,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(50)),
                                        ),
                                        hintText: 'User Name-#####',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('Your RallyID: ', style: TextStyle(color: Colors.grey),),
                                  Text('${auth.value['rallyID']}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),)
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  FlatButton(
                                      onPressed: () async{
                                      var code = await fireActions.checkForRallyID(newFriendTextController.text, context);
                                      print(code);
                                      if(code == "USER_RAL"){
                                        setState(() {
                                          setState(() {
                                            newFriendErrorMessage = AlertDialog(
                                              title: new Text("RallyID = Users RallyID"),
                                              content: new Column(
                                              mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                Text("You can't send a friend invite to yourself"),
                                                Icon(Icons.favorite_border)
                                              ],) ,
                                              actions: <Widget>[
                                                // usually buttons at the bottom of the dialog
                                                new FlatButton(
                                                  child: new Text("Close"),
                                                  onPressed: () {
                                                    setState((){
                                                      newFriendErrorMessage = Container();
                                                    });
                                                  },
                                                ),
                                              ],
                                            );
                                          });
                                        });
                                      } else if(code == "NOT_FOUND"){
                                        setState(() {
                                          newFriendErrorMessage = AlertDialog(
                                            title: new Text("RallyID Not Found"),
                                            content: new Text("Rally couldn't find that RallyID, double check and try again"),
                                            actions: <Widget>[
                                              // usually buttons at the bottom of the dialog
                                              new FlatButton(
                                                child: new Text("Close"),
                                                onPressed: () {
                                                  setState((){
                                                    newFriendErrorMessage = Container();
                                                  });
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                      } else {
                                        fireActions.sendInvite(code, context);
                                        setState(() {
                                          newFriendModal = Container();
                                          newFriendErrorMessage = AlertDialog(
                                            title: new Text("Friend Invite Sent!"),
                                            content: new Text("Once your friend has accept your invite you'll be able to see their events"),
                                            actions: <Widget>[
                                              // usually buttons at the bottom of the dialog
                                              new FlatButton(
                                                child: new Text("Close"),
                                                onPressed: () {
                                                  setState((){
                                                    newFriendErrorMessage = Container();
                                                  });
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                      }
                                      },
                                      padding: EdgeInsets.all(0),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                              decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.all(Radius.circular(8))),
                                              padding: EdgeInsets.all(10.0),
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(Icons.mail, color: Colors.white,),
                                                  Container(width: 5,),
                                                  Text('Submit', style: TextStyle(color: Colors.white, fontSize: 15),),
                                                ],
                                              )
                                          ),
                                        ],
                                      )
                                  ),
                                  Container(width: 10,)
                                ],
                              )
                            ],
                          ),
                        )
                      ),
                  ),
                );
              });
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
                Container(
                  color:Colors.grey[100],
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: eventsPassedToday.entries
                          .map<Widget>((event) =>
                          Column(
                            children: <Widget>[
                              // SPACER
                              Container(
                                height: 10,
                              ),
                              /// Each Event Card
                              ///

                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                  boxShadow: [
                                    new BoxShadow(
                                      color: Colors.grey[500],
                                      blurRadius: 5.0,
                                      offset: Offset(0.0, 0.0),
                                    )
                                  ],
                                  color: Color(_getColorFromHex(event.value['color'])),
                                ),
                                child: ClipPath(
                                clipper: CardCornerClipper(),
                                  child: Container(
                                    width: friendCardWidth * .95,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                      color: Colors.white,
                                    ),
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
                                                  /// RETURN TIME OF EVENT
                                                    children:
                                                    returnTimeInPrettyFormat(event)),
                                                Text(
                                                  '${event.value['title']}',
                                                  style: TextStyle(fontSize: 15),
                                                ),

                                                _joinedFriends(event)

                                              ],
                                            ))),
                                  ),
                                  )
                              ),
                              // SPACER
                              Container(
                                height: 10,
                              ),
                            ],
                          )).toList()),
                )
              ],
            );
        },
        );
        expanded[friend.key] = true;
      });
    }
  }


  Widget _joinedFriends(event) {
    if (event.value['party']['friends'] != null) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text('Joined Friends: '),
          Row(
            children: event.value['party']['friends'].entries
                .map<Widget>((friend) => CircleAvatar(
              radius: 10,
              backgroundImage: NetworkImage(friend
                  .value['userPhoto']),
            ),).toList()
          )
        ],
      );
    } else {
      return Container();
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
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      Container(
        width: 20,
      ),
      Text('$startHour$startMinute$indicator - $endHour$endMinute$indicator'),
    ];
  }

  Widget noFutureEventsFriendItem(friend, friendCardWidth) {
    return Card(
      child: FlatButton(
          padding: EdgeInsets.all(0),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => FriendDetails(friend: friend,)));
          },
          child: Container(
            padding: EdgeInsets.all(10),
            height: 80,
            width: friendCardWidth,
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

class CardCornerClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    var path = Path();

    // Draw a straight line from current point to the bottom left corner.
    path.lineTo(0.0, size.height);

    path.lineTo(size.width, size.height);

    path.lineTo(size.width, size.height * .40);

    path.lineTo(size.width *.90, 0.0);

    // Draw a straight line from current point to the top right corner.
    path.lineTo(0.0, 0.0);

    // Draws a straight line from current point to the first point of the path.
    // In this case (0, 0), since that's where the paths start by default.
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
