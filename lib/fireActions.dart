


import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
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