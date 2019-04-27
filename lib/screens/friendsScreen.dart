
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rallyapp/blocs/app/invite.dart';
import 'package:rallyapp/blocs/app/theme.dart';
import 'package:rallyapp/blocs/auth/auth.dart';
import 'package:rallyapp/blocs/friends/friends.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rallyapp/blocs/events/event.dart';
import 'package:rallyapp/fireActions.dart';
import 'package:rallyapp/screens/friendEventScreen.dart';
import 'package:rallyapp/screens/friendDetailsScreen.dart';
import 'package:rallyapp/screens/settingsScreen.dart';

TextEditingController newFriendTextController;
Widget newFriendModal;
Widget newFriendErrorMessage;
Map expanded;
Map eventsSection;

class FriendsScreen extends StatefulWidget {
  @override
  FriendsScreenState createState() => FriendsScreenState();
}

class FriendsScreenState extends State<FriendsScreen> {

  @override
  void initState(){
    super.initState();
    newFriendTextController = TextEditingController();
    newFriendModal = Container();
    newFriendErrorMessage = Container();
    expanded = {};
    eventsSection = {};
  }

  var friendCardHeight = 110.0;
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _friendsBloc = BlocProvider.of<FriendsBloc>(context);
    final _authBloc = BlocProvider.of<AuthBloc>(context);
    final _eventsBloc = BlocProvider.of<EventsBloc>(context);
    final _invitesBloc = BlocProvider.of<InviteBloc>(context);
    var maxPossibleWidth = MediaQuery.of(context).size.width;
    FireActions fireActions = new FireActions();
    AuthLoaded auth =  _authBloc.currentState;
    final key = new GlobalKey<ScaffoldState>();

    final _themeBloc = BlocProvider.of<ThemeBloc>(context);
    ThemeLoaded theme = _themeBloc.currentState;

    return Scaffold(
      backgroundColor: theme.theme['background'],
      resizeToAvoidBottomPadding: false,
      key: key,
      bottomNavigationBar: friendsBottomAppBar(maxPossibleWidth, context, _invitesBloc, theme),
      body: BlocBuilder(
          bloc: _friendsBloc,
          builder: (BuildContext context, state) {
              state.friends.forEach((k, friend) {
                if (eventsSection[k] != Container()) {
                  if (eventsSection[k] == null) {
                    eventsSection[k] = Container();
                    expanded[k] = false;
                  }
                }
              });
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
                                    userCardHeight, userCardWidth, auth, theme);
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
                                      Text('Friend Invites', style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic, color: theme.theme['text']),
                                      ),
                                    ],
                                  ),
                                  Column(
                                      children: state.invites.entries.map<Widget>((invite) =>
                                          Card(
                                            child: Container(
                                              color: theme.theme['card'],
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
                                                          style: TextStyle(fontSize: 20, color: theme.theme['textTitle']),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: (){
                                                          fireActions.acceptInvite(invite, context);
                                                        },
                                                        child: Container(
                                                          width: 50,
                                                          height: 30,
                                                          decoration: BoxDecoration(color: theme.theme['colorSuccess'], borderRadius: BorderRadius.all(Radius.circular(8))),
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
                                                          decoration: BoxDecoration(color: theme.theme['colorSecondary'], borderRadius: BorderRadius.all(Radius.circular(8))),
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

                          BlocBuilder(bloc: _friendsBloc, builder: (context, friends){
                            if(friends.friends.length > 0 ){
                              return  Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(width: 10,),
                                  Text('Friends',
                                    style: TextStyle(
                                        fontSize: 20, fontStyle: FontStyle.italic, color: theme.theme['text']),
                                  )
                                ],
                              );
                            } else{
                              return Center(
                                child: Card(
                                  color: theme.theme['card'],
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                       ListTile(
                                        leading: Icon(Icons.insert_emoticon, color: theme.theme['solidIconLight']),
                                        title: Text('NO FRIENDS', style: TextStyle(color: theme.theme['text']),),
                                        subtitle: Text(
                                            'Try sending your rallyID to your friends using Rally', style: TextStyle(color: theme.theme['text']),),
                                      ),
                                      ButtonTheme.bar(
                                        // make buttons use the appropriate styles for cards
                                        child: ButtonBar(
                                          children: <Widget>[
                                            FlatButton(
                                              child:  Text('ADD FRIEND', style: TextStyle(color: theme.theme['colorPrimary']),),
                                              onPressed: () {
                                                setState(() {
                                                  newFriendModal = getNewFriendModal(auth, theme);
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          }),
                          /// Friends Label and the friends list
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
                                                  color: theme.theme['card'],
                                                  child: Container(
                                                    width: friendCardWidth,
                                                    child: Column(
                                                      children: <Widget>[
                                                        InkWell(
                                                            onTap: () {
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
                                                                    .start,
                                                                children: <
                                                                    Widget>[
                                                                  /// This Container is the Friend Images
                                                                  CircleAvatar(
                                                                    radius: 30,
                                                                    backgroundImage:
                                                                    NetworkImage(
                                                                        friend.value['userPhoto']),
                                                                    backgroundColor:
                                                                    theme.theme['card']
                                                                  ),

                                                                  Container(
                                                                    width: 10,
                                                                  ),
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
                                                                child: Icon(Icons.keyboard_arrow_down, color: theme.theme['solidIconLight'],),
                                                              ),
                                                              onPressed: () {
                                                                toggleFriendEventsExpand(
                                                                    friend,
                                                                    friendCardWidth,
                                                                    eventsPassedToday,
                                                                    friendViewConstraints,
                                                                    _eventsBloc,
                                                                theme);
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
                                                      color: theme.theme['colorSuccess']),
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
                                              friend, friendCardWidth, theme);
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
          }),
      floatingActionButton: Container(
        child: FloatingActionButton(
            onPressed: () {
              setState(() {
                newFriendModal = getNewFriendModal(auth, theme);
              });
            },
            backgroundColor: theme.theme['colorPrimary'],
            child: Icon(Icons.group_add)),
      ),
    );
  }

  void toggleFriendEventsExpand(
      friend, friendCardWidth, eventsPassedToday, friendViewConstraints, _eventsBloc, theme) {
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
                        child: Icon(Icons.keyboard_arrow_up, color: theme.theme['solidIconLight'],),
                      ),
                      onPressed: () {
                        toggleFriendEventsExpand(friend, friendCardWidth,
                            eventsPassedToday, friendViewConstraints, _eventsBloc, theme);
                      }),
                ),
                Container(
                  color:theme.theme['cardListBackground'],
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
                                      color: theme.theme['shadow'],
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
                                      color: theme.theme['card'],
                                    ),
                                    child: FlatButton(
                                        padding: EdgeInsets.all(0),
                                        onPressed: () {
                                          List key = event.key.toString().split(',');
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => FriendEvent(eventKey: key[0], eventValue: event.value,)));
                                        },
                                        child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                  /// RETURN TIME OF EVENT
                                                    children:
                                                    returnTimeInPrettyFormat(event, theme)),
                                                Text(
                                                  '${event.value['title']}',
                                                  style: TextStyle(fontSize: 15, color: theme.theme['text']),
                                                ),

                                                _joinedFriends(event, theme)

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


  Widget _joinedFriends(event, theme) {
    if (event.value['party']['friends'] != null) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text('Joined Friends: ', style: TextStyle(color: theme.theme['text']),),
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

  Widget userCard(userCardHeight, userCardWidth, auth, theme) {
    return Card(
      color: theme.theme['card'],
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      /// User Photo
                      CircleAvatar(
                        backgroundColor: theme.theme['card'],
                        radius: userCardHeight / 4,
                        backgroundImage: NetworkImage(auth.value['userPhoto']),
                      ),
                      Container(width: 10,),
                      /// User Name
                      Expanded(
                        child: Text(
                          '${auth.value['userName']}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: theme.theme['textTitle']
                          ),
                        ),
                      )
                    ],
                  ),
                Container(height: 10,),
                Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        /// User RallyID
                        Expanded(
                          child: Text(
                            'Rally ID: ${auth.value['rallyID']}',
                            style: TextStyle(
                              color: theme.theme['text'],
                              fontSize: 20,
                            ),
                          ),
                        )
                      ],
                    )
                )


              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child:IconButton(
                  color: theme.theme['solidIconDark'],
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
                  }),
            )
          ],
        )
        );
  }

  returnTimeInPrettyFormat(event,theme) {
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
          color: theme.theme['textTitle']
        ),
      ),
      Container(
        width: 20,
      ),
      Text('$startHour$startMinute$indicator - $endHour$endMinute$indicator',
      style: TextStyle(
        color: theme.theme['text']
      ),),
    ];
  }

  Widget noFutureEventsFriendItem(friend, friendCardWidth, theme) {
    return Card(
      color: theme.theme['card'],
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                /// This Container is the Friend Images
                CircleAvatar(
                  backgroundColor: theme.theme['card'],
                  radius: 30,
                  backgroundImage: NetworkImage(friend.value['userPhoto']),
                ),
                Container(
                  width: 10,
                ),
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
    );
  }

  Widget getNewFriendModal(auth, theme) {
    return LayoutBuilder(builder: (context, constraints){
      var maxHeight = constraints.maxHeight;
      var maxWidth = constraints.maxWidth;
      var cardHeightMultiplier = 0.35;
      var cardWidthMultiplier = 0.95;

      if(maxWidth > maxHeight){
        cardHeightMultiplier = 0.80;
        cardWidthMultiplier = 0.70;
      }
      return InkWell(
        onTap: (){
          setState(() {
            newFriendModal = Container();
          });
        },
        child: Container(
          height: maxHeight,
          width: maxWidth,
          decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.5)),
          alignment: Alignment.center,
          child: Container(
              height: 300,
              width: maxWidth * cardWidthMultiplier,
              child: Card(
                color: theme.theme['card'],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('New Friend', style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20,
                          color: theme.theme['textTitle']
                        ),),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            border: Border.all(color: theme.theme['border']),
                            color: theme.theme['card']
                          ),
                          width: (maxWidth * cardWidthMultiplier) * .80,
                          child: TextFormField(
                            autocorrect: false,
                            autovalidate: false,
                            style: TextStyle(color: theme.theme['text']),
                            cursorColor: theme.theme['textTitle'],
                            key: _formKey,
                            controller: newFriendTextController,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: theme.theme['text']),
                              hintText: 'User Name-#####',
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(width: 10,),
                        Text('Your RallyID: ', style: TextStyle(color: theme.theme['text']),),
                        Expanded(
                          child:Text('${auth.value['rallyID']}', style: TextStyle(fontWeight: FontWeight.bold, color: theme.theme['text']),)
                        ),
                        Container(width: 10,),
                      ],
                    ),
                    Container(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FlatButton(
                            onPressed: () {
                              Clipboard.setData(new ClipboardData(text:auth.value['rallyID']));
                              Scaffold.of(context).showSnackBar(new SnackBar(
                                  content: new Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text('Copied RallyID: ${auth.value['rallyID']}'),
                                      ),
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
                        FlatButton(
                            onPressed: () async{
                              var code = await fireActions.checkForRallyID(newFriendTextController.text, context);
                              print(code);
                              getAlertFromCode(code, theme);
                            },
                            padding: EdgeInsets.all(0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    decoration: BoxDecoration(color: theme.theme['colorPrimary'], borderRadius: BorderRadius.all(Radius.circular(8))),
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
                      ],
                    ),
                    Container(height: 10,)
                  ],
                ),
              )
          ),
        ),
      );
    });
  }

  void getAlertFromCode(code, theme) {
    if(code == "USER_RAL"){
      showDialog(
          context: context,
          builder: (context){
            return  AlertDialog(
              backgroundColor: theme.theme['card'],
              title: new Text("RallyID = Users RallyID",style: TextStyle(color: theme.theme['text']),),
              content: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("You can't send a friend invite to yourself", style: TextStyle(color: theme.theme['text']),),
                  Icon(Icons.favorite_border, color: theme.theme['colorPrimary'],)
                ],) ,
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Close",style: TextStyle(color: theme.theme['text']),),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    } else if(code == "NOT_FOUND"){
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              backgroundColor: theme.theme['card'],
              title: new Text("RallyID Not Found",style: TextStyle(color: theme.theme['text']),),
              content: new Text("Rally couldn't find RallyID: ${newFriendTextController.text} in the directory, double check and try again",
                style: TextStyle(color: theme.theme['text']),),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Close",style: TextStyle(color: theme.theme['text']),),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    } else {
      fireActions.sendInvite(code, context);
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              backgroundColor: theme.theme['card'],
              title: new Text("Friend Invite Sent!",style: TextStyle(color: theme.theme['text']),),
              content: new Text("Once your friend has accepted your invite you'll be able to see their events",style: TextStyle(color: theme.theme['text']),),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Close"),
                  onPressed: () {
                    setState((){
                      newFriendModal = Container();
                      Navigator.of(context).pop();
                    });
                  },
                ),
              ],
            );
          }
      );
    }
  }
}

friendsBottomAppBar(maxPossibleWidth, context, _invitesBloc, theme) {
  return BottomAppBar(
      child: Container(
        height: 55,
        color: theme.theme['footer'],
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
                      Icon(Icons.calendar_today, color: theme.theme['solidIconDark'],),
                      Text('Calendar', style: TextStyle(fontSize: 14, color: theme.theme['text'], fontWeight: FontWeight.w500),)
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
                              Icon(Icons.group, color: theme.theme['colorPrimary'],),
                              Text('Friends', style: TextStyle(fontSize: 14, color: theme.theme['text'], fontWeight: FontWeight.w500),),
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
                                        color: theme.theme['colorSuccess']
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
  );
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