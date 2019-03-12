import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rallyapp/blocs/events/event.dart';
import 'package:rallyapp/blocs/friends/friends.dart';
import 'package:rallyapp/blocs/auth/auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;



Future setListeners(BuildContext context) async{
  final friendBloc = BlocProvider.of<FriendsBloc>(context);
  final authBloc = BlocProvider.of<AuthBloc>(context);
  final eventBloc = BlocProvider.of<EventsBloc>(context);

  print('======================= Settings Listeners =======================');
  final FirebaseUser user = await _auth.currentUser();
  var uid = user.uid;

  final FirebaseApp app = await FirebaseApp.configure(
    name: 'rallydev',
    // TODO get actual settings for IOS here
    options: Platform.isIOS
        ? const FirebaseOptions(
      googleAppID: 'NULL',
      gcmSenderID: 'NULL',
      databaseURL: 'NULL',
    )
        : const FirebaseOptions(
      googleAppID: '1:871930822313:android:4f038984403403c9',
      apiKey: 'AIzaSyAa-7LsEyLudV4qbOrKk_lKE65nAybmDNw ',
      databaseURL: 'https://rallydev-40f78.firebaseio.com/',
    ),
  );

  final FirebaseDatabase database = FirebaseDatabase(app:app);

  //////////////////////////////////////////////////////////////////////////////
  /////// USER RELATED LISTENERS
  //////////////////////////////////////////////////////////////////////////////

  // Grabbing user data
  database.reference().child('user/$uid/info').once().then((snapshot) =>{
  authBloc.dispatch(AddAuth(uid,snapshot.value))
  });

  // Setting Listener on User Info CHANGE
  database.reference().child('user/$uid/info').onChildChanged.listen((event){
    print(' -- CHANGE -- user info');
    print('user info changed: ${event.snapshot.key} ${event.snapshot.value}');
    authBloc.dispatch(ReplaceAuthInfo(uid, event.snapshot.key, event.snapshot.value));
  });

  // Setting Listener on User event CHANGE, effects the info details of that event
  database.reference().child('user/$uid/events').onChildChanged.listen((event){
    print(' -- CHANGE -- user events');
    eventBloc.dispatch(ReplaceEventInfo(event.snapshot.key, event.snapshot.value, uid));
  });

  // Setting Listener on User event ADD
  database.reference().child('user/$uid/events').onChildAdded.listen((Event event) async{
    print(' -- ADD -- user events');
    eventBloc.dispatch(AddEvents(uid, event.snapshot.key, event.snapshot.value));
  });

  // Setting Listener on User event REMOVE
  database.reference().child('user/$uid/events').onChildRemoved.listen((Event event){
    print(' -- REMOVE -- user events');
    eventBloc.dispatch(RemoveEvents(uid, event.snapshot.key));
  });
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

  ////////////////////////////////////////////////////////////////////////////
  //////// FRIEND RELATED LISTENERS
  ////////////////////////////////////////////////////////////////////////////

  // Storing each friends database subscriptions in a Map so they can be turned
  // off later when the friend is removed.
  var subscriptions = {};

  // Iterate through friends set listener on friend ADD event.
  database.reference().child('user/$uid/friends').onChildAdded.listen((event){
    var i = 0;
    var friendID = event.snapshot.key;
    subscriptions[friendID] = {};
    print('friendID ============ $friendID');
    print(' -- ADD -- friend ');

    // GRAB friend info
   database.reference().child('user/$friendID/info').once().then((snapshot){
      print('Grabbing friend Info: ${snapshot.value}');
      friendBloc.dispatch(AddFriends(friendID, snapshot.value));
    });
    // Settings Listener on friends info CHANGE
    subscriptions[friendID][i++] = database.reference().child('user/$friendID/info').onChildChanged.listen((event){
      print(' -- CHANGED -- friend info');
      friendBloc.dispatch(ReplaceFriendInfo(event.snapshot.key, event.snapshot.value, friendID));
    });
    // Setting Listener on friend's events detail CHANGE
    subscriptions[friendID][i++] = database.reference().child('user/$friendID/events').onChildChanged.listen((event) {
      print(' -- CHANGED -- friend event');
      eventBloc.dispatch(ReplaceEventInfo(event.snapshot.key, event.snapshot.value, friendID));
    });
    // Setting Listener on friend's events ADD
    subscriptions[friendID][i++] = database.reference().child('user/$friendID/events').onChildAdded.listen((event){
      print(' -- ADD -- friend event');
      eventBloc.dispatch(AddEvents(friendID, event.snapshot.key, event.snapshot.value));
    });
    // Setting Listener on friend's event REMOVE
    subscriptions[friendID][i++] = database.reference().child('user/$friendID/events').onChildRemoved.listen((event) {
      print(' -- REMOVE -- friend event');
      eventBloc.dispatch(RemoveEvents(friendID, event.snapshot.key));
      i++;
    });

    // Setting Listener on friend REMOVE
    database.reference().child('user/$uid/friends').onChildRemoved.listen((event){
      print(' -- REMOVE -- friend ');
      var friendID = event.snapshot.key;
      friendBloc.dispatch(RemoveFriends(event.snapshot.key));

      // Turning off listeners for removed friend...
      var data = subscriptions[friendID];
      data.forEach((key, value) => {
        value.cancel()
      });
    });
  });
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
}