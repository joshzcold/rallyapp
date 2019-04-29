


import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:rallyapp/blocs/auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:rallyapp/blocs/app/theme.dart';

class FireActions {
  var uuid = Uuid();

  newEventToDatabase(sTime, eTime, color, partyLimit, title, context)async{
    var result;
    FirebaseDatabase database = await getFireBaseInstance();
    var user = await getFireBaseUser();
    final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
    AuthLoaded auth =  authBloc.currentState;

    var eventID = uuid.v4();
    await database.reference().child('/user/${user.uid}/events/').once().then((snapshot) async{
      var events = snapshot.value;
      if(events != null){
        if(snapshot.value.length > 9){
          var items = snapshot.value;
          var listOfTimes = [];
          var sortedEvents = {};
          items.forEach((k, event) {
            listOfTimes.add(event['start']);
          });
          listOfTimes..sort();
          // after sorting, add events in order
          for(var time in listOfTimes){
            items.forEach((k,value){
              if(time == value['start']){
                print(DateTime.fromMillisecondsSinceEpoch(value['start']));
                sortedEvents.addAll({k:value});
              }
            });
          }
          List keysOfSort = sortedEvents.keys.toList();
          var kF = keysOfSort.first;
          await database.reference().child('user/${user.uid}/events/$kF').remove();
          await database.reference().child('user/${user.uid}/info').once().then((snapshot){
            var check = snapshot.value['deleteNotificationCheck'];
            if(check == null){
              result = "SHOW_DELETE";
              database.reference().child('user/${user.uid}/info').update({
                "deleteNotificationCheck":true
              });
            }
          });
        }
      }
    });
    await database.reference().child('/user/${user.uid}/events/').update(<String, dynamic>{
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
    return result;
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
    var partyLimit = 99999;
    var alreadyJoinedFriends = 0;
    final _themeBloc = BlocProvider.of<ThemeBloc>(context);
    ThemeLoaded theme = _themeBloc.currentState;

    await database.reference().child('/user/$friend/events/$event/party/').once().then((snapshot){
      if(snapshot.value['friends'] != null){
        alreadyJoinedFriends = snapshot.value['friends'].length;
      }
    });

    await database.reference().child('/user/$friend/events/$event/party/').once().then((snapshot){
      if(snapshot.value['partyLimit'] == ""){
        partyLimit = 0;
      } else{
        partyLimit = int.parse(snapshot.value['partyLimit']);
      }
    });

    if(partyLimit == 0 || alreadyJoinedFriends + 1 <= partyLimit ){
      database.reference().child('/user/$friend/events/$event/party/friends/${user.uid}').update({
        'id': user.uid,
        'userEmail':auth.value['userEmail'],
        'userName':auth.value['userName'],
        'userPhoto':auth.value['userPhoto'],
      });
    } else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            backgroundColor: theme.theme['card'],
            title: new Text('Party Already Full', style: TextStyle(color: theme.theme['textTitle']),),
            content: new Text('The party limit has already been reached and you cannot join the event, '
                'try asking your friend if this was a mistake',style: TextStyle(color: theme.theme['text'])),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close", style: TextStyle(color: theme.theme['colorPrimary']),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  deleteEvent(event, context)async {
    FirebaseDatabase database = await getFireBaseInstance();
    var user = await getFireBaseUser();
    database.reference().child(
        '/user/${user.uid}/events/$event').remove();
  }

  deleteAllEvents()async {
    FirebaseDatabase database = await getFireBaseInstance();
    var user = await getFireBaseUser();
    database.reference().child(
        '/user/${user.uid}/events/').remove();
  }

  deleteOldEvents()async{
    FirebaseDatabase database = await getFireBaseInstance();
    var user = await getFireBaseUser();
    database.reference().child('/user/${user.uid}/events/').once().then((snapshot){
      var items = snapshot.value;
      var compareTime = DateTime.now().millisecondsSinceEpoch;

      var listOfTimes = [];
      var deletedEvents = {};
      items.forEach((k, event) {
        listOfTimes.add(event['end']);
      });
      listOfTimes..sort();
      // after sorting, add events in order
      for(var time in listOfTimes){
        items.forEach((k,value){
          if(time == value['end'] && time < compareTime){
            print(DateTime.fromMillisecondsSinceEpoch(value['end']));
            deletedEvents.addAll({k:value});
          }
        });
      }
      deletedEvents.forEach((key, value){
        database.reference().child('user/${user.uid}/events/$key').remove();
      });
    });
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

  newUserName(username, context) async{
    FirebaseDatabase database = await getFireBaseInstance();
    var rallyID = generateRallyID(username);
    var items;
    await database.reference().child('rally/').once().then((snapshot) =>{
    items = snapshot.value
    }).then((something) async{
      // check if the generated RallyID is found within the snapshot of the rally
      // directory. Not the best way to check but since flutter doesn't currently
      // have a function like .exists() this is what works for now...
      items.containsKey(rallyID)? newUserName(username, context): await executeNewUserName(rallyID, username, context);
    });
  }

  executeNewUserName(rallyID, username, context) async {
    final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
    AuthLoaded auth =  authBloc.currentState;

    var previousRallyID = auth.value['rallyID'];

    FirebaseDatabase database = await getFireBaseInstance();
    var user = await getFireBaseUser();

    database.reference().child('rally/$rallyID').update({
      "userID": user.uid
    });

    database.reference().child('user/${user.uid}/info').update({
      "rallyID":rallyID,
      "userName": username,
    });

    database.reference().child('rally/$previousRallyID').remove();

    return rallyID;
  }

  generateRallyID(username){
    var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

    String randomString(int strlen) {
      Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
      String result = "";
      for (var i = 0; i < strlen; i++) {
        result += chars[rnd.nextInt(chars.length)];
      }
      return result;
    }

    var rallyID = '$username-${randomString(5)}';

    return rallyID;
  }

  declineInvite(invite, context,) async{
    FirebaseDatabase database = await getFireBaseInstance();
    var user = await getFireBaseUser();

    // Remove invite from list
    database.reference().child('/user/${user.uid}/invites/${invite.key}').remove();
  }

  sendInvite(friend, context,) async{
    FirebaseDatabase database = await getFireBaseInstance();
    var user = await getFireBaseUser();
    final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
    AuthLoaded auth =  authBloc.currentState;
    // Send Invite to Friend
    database.reference().child('/user/$friend/invites/${user.uid}').update({
      'rallyID':auth.value['rallyID'],
      'userEmail':auth.value['userEmail'],
      'userName':auth.value['userName'],
      'userPhoto':auth.value['userPhoto'],
    });
  }

  removeFriend(friend) async{
    FirebaseDatabase database = await getFireBaseInstance();
    var user = await getFireBaseUser();

    database.reference().child('/user/${user.uid}/friends/$friend').remove();
    database.reference().child('/user/$friend/friends/${user.uid}').remove();

  }

  updateNotifyOnFriend(friend, notifyKey, notifyValue) async{
    FirebaseDatabase database = await getFireBaseInstance();
    var user = await getFireBaseUser();

    database.reference().child('/user/${user.uid}/friends/$friend').update({
      notifyKey:notifyValue
    });
  }

  checkForRallyID(rallyID, context) async{
    final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
    AuthLoaded auth =  authBloc.currentState;
    var code;
    FirebaseDatabase database = await getFireBaseInstance();
    await database.reference().child('rally/').once().then((snapshot) async{
      if(snapshot.value.containsKey(rallyID) && rallyID != auth.value['rallyID']){
        print('found $rallyID in directory');
        await database.reference().child('rally/$rallyID').once().then((snapshot){
          code = snapshot.value['userID'];
        });
      } else if (rallyID == auth.value['rallyID']){
        print('rallyID is same as Users rallyID');
        code = "USER_RAL";
      } else{
        print('$rallyID not found in /rally');
        code = 'NOT_FOUND';
      }
    });
    return code;
  }

  uploadUserPhoto(photo, context) async{
    var user = await getFireBaseUser();
    FirebaseStorage storage = await getFireBaseStorageInstance();
    FirebaseDatabase database = await getFireBaseInstance();
    final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
    var metaDataUUID = uuid.v4();

    var storageTask = storage.ref().child('photos').child('${user.uid}').putFile(
      photo,
      StorageMetadata(
        contentLanguage: 'en',
        customMetadata: <String, String>{'photo-uid': metaDataUUID},
      ),
    ).onComplete.then((value) async{
      var url = await storage.ref().child('photos/${user.uid}').getDownloadURL();

      await database.reference().child('/user/${user.uid}/info').update({
        "userPhoto":url
      });

      await database.reference().child('/user/${user.uid}/events').once().then((snapshot){
        Map items = snapshot.value;
        items.forEach((key, value){
          database.reference().child('/user/${user.uid}/events/$key').update({
            "userPhoto":url
          });
        });
      });

      authBloc.dispatch(ReplaceAuthInfo("userPhoto", url));
    });
  }

  getUserPhotoURL() async{
    var user = await getFireBaseUser();
    FirebaseStorage storage = await getFireBaseStorageInstance();
    var url = await storage.ref().child('photos').child('${user.uid}').getDownloadURL();
    return url;
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
      storageBucket: 'gs://rallydev-40f78.appspot.com'
    ),
  );

  var database = FirebaseDatabase(app:app);
  return database;
}

getFireBaseStorageInstance() async{
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

  var storage = FirebaseStorage(app:app, storageBucket: 'gs://rallydev-40f78.appspot.com');
  return storage;
}