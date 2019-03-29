


import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';
import 'package:rallyapp/blocs/auth/auth.dart';

class FireActions {
  var uuid = Uuid();
  var authBloc = AuthBloc();

  newEventToDatabase(sTime, eTime, color, partyLimit, title)async{
    var database = await getFireBaseInstance();
    var user = await getFireBaseUser();
    var authUser = authBloc.getAuthUser();
    var eventID = uuid.v4();
  database.reference().child('/user/${user.uid}/events/').set(<String, dynamic>{
    eventID:{
      'color': color,
      'end': eTime,
      'start': sTime,
      'party': {
        'partyLimit': partyLimit
      },
      'title': title,
      'user': user.uid,

    }
  });
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