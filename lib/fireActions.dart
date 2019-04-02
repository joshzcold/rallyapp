


import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';
import 'package:rallyapp/blocs/auth/auth.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FireActions {
  var uuid = Uuid();

  newEventToDatabase(sTime, eTime, color, partyLimit, title, context)async{
    FirebaseDatabase database = await getFireBaseInstance();
    var user = await getFireBaseUser();
    final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
    AuthLoaded auth =  authBloc.currentState;

    var eventID = uuid.v4();
  database.reference().child('/user/${user.uid}/events/').update(<String, dynamic>{
    eventID:{
      'color': color,
      'end': eTime,
      'start': sTime,
      'party': {
        'partyLimit': partyLimit
      },
      'title': title,
      'user': auth.key,
      'userName': auth.value['userName'],
      'userPhoto': auth.value['userPhoto']

    }
  });
  }

  changeEventToDatabase(sTime, eTime, color, partyLimit, joinedFriends, title, key, context)async{
    FirebaseDatabase database = await getFireBaseInstance();
    var user = await getFireBaseUser();
    final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
    AuthLoaded auth =  authBloc.currentState;

    database.reference().child('/user/${user.uid}/events/$key').update(<String, dynamic>{
        'color': color,
        'end': eTime,
        'start': sTime,
        'party': {
          'partyLimit': partyLimit,
          'friends': joinedFriends
        },
        'title': title,
        'user': auth.key,
        'userName': auth.value['userName'],
        'userPhoto': auth.value['userPhoto']
    });
  }

  removeJoinedFriend(event, friend, context)async {
    FirebaseDatabase database = await getFireBaseInstance();
    var user = await getFireBaseUser();
    database.reference().child(
        '/user/${user.uid}/events/$event/party/friends/$friend').remove();
  }

  leaveEvent(event, friend, context)async {
    FirebaseDatabase database = await getFireBaseInstance();
    final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
    AuthLoaded auth =  authBloc.currentState;
    database.reference().child(
        '/user/$friend/events/$event/party/friends/${auth.key}').remove();
  }

  joinEvent(event, friend, context)async {
    FirebaseDatabase database = await getFireBaseInstance();
    var user = await getFireBaseUser();
    final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
    AuthLoaded auth =  authBloc.currentState;
    database.reference().child('/user/$friend/events/$event/party/friends/${user.uid}').update({
      'id': user.uid,
      'userEmail':auth.value['userEmail'],
      'userName':auth.value['userName'],
      'userPhoto':auth.value['userPhoto'],
    });
  }

  deleteEvent(event, context)async {
    FirebaseDatabase database = await getFireBaseInstance();
    var user = await getFireBaseUser();
    database.reference().child(
        '/user/${user.uid}/events/$event').remove();
  }

  acceptInvite(invite, context,) async{
    FirebaseDatabase database = await getFireBaseInstance();
    var user = await getFireBaseUser();
    final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
    AuthLoaded auth =  authBloc.currentState;

    // Add friend to user's friend list
    database.reference().child('/user/${user.uid}/friends/${invite.key}').update({
      'notify': "true",
      'userEmail': invite.value['userEmail'],
    });

    // Add user to friend's friend list
    database.reference().child('/user/${invite.key}/friends/${user.uid}').update({
      'notify': "true",
      'userEmail': auth.value['userEmail'],
    });

    // Remove invite from list
    database.reference().child('/user/${user.uid}/invites/${invite.key}').remove();
  }

  declineInvite(invite, context,) async{
    FirebaseDatabase database = await getFireBaseInstance();
    var user = await getFireBaseUser();

    // Remove invite from list
    database.reference().child('/user/${user.uid}/invites/${invite.key}').remove();
  }

  bool checkForRallyID(rallyID){
    FirebaseDatabase database = getFireBaseInstance();
    var items;
    var check;
    database.reference().child('rally/').once().then((snapshot) =>{
    items = snapshot.value
    }).then((something){
      // check if the generated RallyID is found within the snapshot of the rally
      // directory. Not the best way to check but since flutter doesn't currently
      // have a function like .exists() this is what works for now...
      items.containsKey(rallyID)? check = false: check = true;
    });
    if(check){
      return true;
    } else{
      return false;
    }

  }

}

getFireBaseUser() async{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseUser user = await _auth.currentUser();
  return user;
}

getFireBaseInstance() async{
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

  var database = FirebaseDatabase(app:app);
  return database;
}