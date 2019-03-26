import 'package:flutter/material.dart';
import 'package:rallyapp/blocs/auth/auth.dart';
import 'package:rallyapp/blocs/friends/friends.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rallyapp/blocs/events/event.dart';

class FriendsScreen extends StatelessWidget {
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
                  var friendCardHeight = constraints.maxHeight/8;
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
                                              Container(
                                                  width: 100.0,
                                                  height: 100.0,
                                                  decoration: new BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: new DecorationImage(
                                                          fit: BoxFit.fill,
                                                          image: new NetworkImage(auth.value['userPhoto'])))),
                                              /// User Name
                                              Text('${auth.value['userName']}', style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30,
                                              ),),
                                            ],
                                          ),
                                          height: userCardHeight -10,
                                          width: userCardWidth,
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
                                child: ListView(
                                      children: state.friends.entries
                                          .map<Widget>((friend) => BlocBuilder(
                                        bloc: _eventsBloc,
                                        builder: (context, state){
                                          return _calculatePresentFriendEvents(friend, state.events[friend.key], friendCardHeight);
                                        },
                                      )).toList())
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
}

Widget _calculatePresentFriendEvents(friend, events, friendCardHeight) {
  var eventsPassedToday = {};
  DateTime currentTime = DateTime.now();
  events.forEach((k, event){
    if(event['start'] > currentTime.millisecondsSinceEpoch){
      print('${friend.key}: ${DateTime.fromMillisecondsSinceEpoch(event['start'])}');
      eventsPassedToday.addAll({k: event});
    }
  });
  if(eventsPassedToday.length > 0){
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
  } else{
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


