import 'package:flutter/material.dart';
import 'package:rallyapp/blocs/auth/auth.dart';
import 'package:rallyapp/blocs/friends/friends.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rallyapp/blocs/events/event.dart';

class FriendsScreen extends StatefulWidget{

  @override
  FriendsScreenState createState() => FriendsScreenState();
}

class FriendsScreenState extends State<FriendsScreen> {
  var expanded = false;
  var friendCardHeight = 110.0;
  Widget eventsSection = Container();

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
              return  Center(
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const ListTile(
                        leading: Icon(Icons.insert_emoticon),
                        title: Text('NO FRIENDS'),
                        subtitle: Text('Try sending your rallyID to your friends using Rally'),
                      ),
                      ButtonTheme.bar( // make buttons use the appropriate styles for cards
                        child: ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              child: const Text('ADD FRIEND'),
                              onPressed: () { /* ... */ },
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
              print('FriendsLoaded: ${state.friends.entries}');
              return LayoutBuilder(
                builder: (context, constraints){
                  var userCardWidth = constraints.maxWidth * .80;
                  var userCardHeight = constraints.maxHeight /4;
                  var friendCardWidth = constraints.maxWidth *.95;
                  return Container(
                    height: constraints.maxHeight,
                      width: constraints.maxWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          BlocBuilder(bloc: _authBloc, builder: (context, auth){
                            /// User Card
                            return Card(
                                child: Container(
                                    height: userCardHeight,
                                    width: userCardWidth,
                                    child: Stack(
                                      children: <Widget>[
                                        Positioned(
                                          child: IconButton(icon: Icon(Icons.settings), onPressed: (){
                                            print('SETTINGS');
                                          }),
                                          top: 0,
                                          right: 0,
                                        ),
                                        Positioned(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              /// User Photo
                                              CircleAvatar(
                                                backgroundColor: Colors.white,
                                                radius: userCardHeight /4,
                                                backgroundImage: NetworkImage(auth.value['userPhoto']),
                                              ),
                                              /// User Name
                                              Text('${auth.value['userName']}', style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30,
                                              ),),
                                            ],
                                          ),
                                        ),
                                        /// User RallyID
                                        Positioned(
                                          child: Center(
                                              child: Text('Rally ID: ${auth.value['rallyID']}', style: TextStyle(
                                                color: Colors.grey[700],
                                                fontSize: 20,
                                              ),)
                                          ),
                                          bottom: 10,
                                          width: userCardWidth,
                                        )
                                      ],
                                    )
                                )
                            );
                          }),

                          /// Friends Label and the friends list
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 30,
                                width: friendCardWidth,
                                child:
                                Text('Friends', style:
                                  TextStyle(
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic),)
                                ),
                              Container(
                                height: 400,
                                width: friendCardWidth,
                                alignment: Alignment(0.5, 0.5),
                                child: LayoutBuilder(builder: (context, friendViewConstraints){
                                  return ListView(
                                      children: state.friends.entries
                                          .map<Widget>((friend) => BlocBuilder(
                                        bloc: _eventsBloc,
                                        builder: (context, state){
                                          var events = state.events[friend.key];
                                          var eventsPassedToday = {};
                                          DateTime currentTime = DateTime.now();
                                          if(events != null){
                                            events.forEach((k, event){
                                              if(event['start'] > currentTime.millisecondsSinceEpoch){
                                                print('${friend.key}: ${DateTime.fromMillisecondsSinceEpoch(event['start'])}');
                                                eventsPassedToday.addAll({k: event});
                                              }
                                            });
                                          }
                                          if(eventsPassedToday.length > 0){
                                            /// This return is if there are events passed DateTime now
                                            /// for this friend.
                                            return Card(
                                                child: AnimatedContainer(
                                                  duration: Duration(milliseconds: 300),
                                                  height: friendCardHeight,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      FlatButton(
                                                          padding: EdgeInsets.all(0),
                                                          onPressed: (){
                                                            print('touched: $friend');
                                                          },
                                                          child: Container(
                                                            padding: EdgeInsets.all(10),
                                                            height: 80,
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: <Widget>[
                                                                /// This Container is the Friend Images
                                                              CircleAvatar(
                                                              radius: 30,
                                                              backgroundImage: NetworkImage(friend.value['userPhoto']),
                                                                backgroundColor: Colors.white,
                                                            ),
                                                                /// Friend User Name
                                                                Text(friend.value['userName'], style: TextStyle(
                                                                    fontSize: 20
                                                                ),),
                                                                /// Friend RallyID
                                                                Text(friend.value['rallyID'], style: TextStyle(
                                                                    fontSize: 20
                                                                ),)
                                                              ],
                                                            ),
                                                          )),
                                                      AnimatedSwitcher(
                                                        duration: Duration(seconds: 2),
                                                        transitionBuilder: (Widget child, Animation<double> animation){
                                                          return ScaleTransition(child: child, scale: animation);
                                                        },
                                                        child: eventsSection,
                                                      ),
                                                      Container(
                                                        height: 30,
                                                        width: friendCardWidth,
                                                        child: FlatButton(
                                                          child: Center(
                                                            child: Icon(Icons.keyboard_arrow_down),
                                                          ),
                                                            onPressed: (){
                                                            toggleFriendEventsExpand(friend, friendCardWidth, eventsPassedToday, friendViewConstraints);
                                                        }),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                            );
                                          } else{
                                            /// No Events passed DateTime Now
                                            return Card(
                                              child: FlatButton(
                                                  padding: EdgeInsets.all(0),
                                                  onPressed: (){
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
                                                                    image: new NetworkImage(
                                                                        friend.value['userPhoto'])))),
                                                        /// Friend User Name
                                                        Text(friend.value['userName'], style: TextStyle(
                                                            fontSize: 20
                                                        ),),
                                                        /// Friend RallyID
                                                        Text(friend.value['rallyID'], style: TextStyle(
                                                            fontSize: 20
                                                        ),)
                                                      ],
                                                    ),
                                                  )),
                                            );
                                          }
                                        },
                                      )).toList());
                                }),
                              )
                            ],
                          )
                        ],
                      )
                  );
                },
              );
            }
          }),
      floatingActionButton: Container(
        child: FloatingActionButton(
            onPressed: (){},
            backgroundColor: Colors.blue,
            child: Icon(Icons.group_add)
        ),
      ),
    );
  }

  Widget _calculatePresentFriendEvents(friend, events, friendCardHeight) {
    var eventsPassedToday = {};
    DateTime currentTime = DateTime.now();
    if(events != null){
      events.forEach((k, event){
        if(event['start'] > currentTime.millisecondsSinceEpoch){
          print('${friend.key}: ${DateTime.fromMillisecondsSinceEpoch(event['start'])}');
          eventsPassedToday.addAll({k: event});
        }
      });
    }
    if(eventsPassedToday.length > 0){
      Widget eventsSection = Container();

      var eventSectionHeight = eventsPassedToday.length * 20;
      /// This return is if there are events passed DateTime now
      /// for this friend.
      return Card(
          child: Column(
            children: <Widget>[
              FlatButton(
                  padding: EdgeInsets.all(0),
                  onPressed: (){
                    print('touched: $friend');
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    height: friendCardHeight,
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
                                    image: new NetworkImage(
                                        friend.value['userPhoto'])))),
                        /// Friend User Name
                        Text(friend.value['userName'], style: TextStyle(
                            fontSize: 20
                        ),),
                        /// Friend RallyID
                        Text(friend.value['rallyID'], style: TextStyle(
                            fontSize: 20
                        ),)
                      ],
                    ),
                  )),
              AnimatedSwitcher(
                duration: Duration(seconds: 1),
                transitionBuilder: (Widget child, Animation<double> animation){
                  return ScaleTransition(child: child, scale: animation);
                },
                child: eventsSection,
              ),
              IconButton(
                padding: EdgeInsets.all(0),
                  icon: Icon(Icons.keyboard_arrow_down), onPressed: (){
                ///SetState for events processed on each friend card
                setState((){
                  friendCardHeight = eventsPassedToday.length * 20.0;

                  eventsSection = ListView(
                      children: eventsPassedToday.entries.map<Widget>((event) =>
                          Card(
                            child: FlatButton(
                                padding: EdgeInsets.all(0),
                                onPressed: (){
                                  print('touched: $friend');
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  height: friendCardHeight,
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
                                                  image: new NetworkImage(
                                                      friend.value['userPhoto'])))),
                                      /// Friend User Name
                                      Text(friend.value['userName'], style: TextStyle(
                                          fontSize: 20
                                      ),),
                                      /// Friend RallyID
                                      Text(friend.value['rallyID'], style: TextStyle(
                                          fontSize: 20
                                      ),)
                                    ],
                                  ),
                                )),
                          )
                      ).toList());
                });
              }),
            ],
          )
      );
    } else{
      /// No Events passed DateTime Now
      return Card(
        child: FlatButton(
            padding: EdgeInsets.all(0),
            onPressed: (){
              print('touched: $friend');
            },
            child: Container(
              padding: EdgeInsets.all(10),
              height: friendCardHeight,
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
                              image: new NetworkImage(
                                  friend.value['userPhoto'])))),
                  /// Friend User Name
                  Text(friend.value['userName'], style: TextStyle(
                      fontSize: 20
                  ),),
                  /// Friend RallyID
                  Text(friend.value['rallyID'], style: TextStyle(
                      fontSize: 20
                  ),)
                ],
              ),
            )),
      );
    }
  }

  void toggleFriendEventsExpand(friend, friendCardWidth, eventsPassedToday, friendViewConstraints) {
    if(expanded){
      setState(() {
        friendCardHeight = 140;
        eventsSection = Container();
        expanded = false;
      });
    } else{
      ///SetState for events processed on each friend card
      setState((){
        friendCardHeight = friendViewConstraints.maxHeight;

        eventsSection = Container(
          alignment: Alignment(0.5, 0.5),
          width: friendCardWidth,
          color: Colors.grey,
          height: eventsPassedToday.length * 120.0,
          child: Container(
            width: friendCardWidth * .95,
            child: ListView(
                children: eventsPassedToday.entries.map<Widget>((event) =>
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.red, width: 5.0)
                      ),
                      child: FlatButton(
                          padding: EdgeInsets.all(0),
                          onPressed: (){
                            print('touched: $friend');
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[

                                /// Friend User Name
                                Text(friend.value['userName'], style: TextStyle(
                                    fontSize: 20
                                ),),
                                /// Friend RallyID
                                Text(friend.value['rallyID'], style: TextStyle(
                                    fontSize: 20
                                ),)
                              ],
                            ),
                          )),
                    )
                ).toList()),),
        );
        expanded = true;
      });
    }
  }
}




