import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rallyapp/blocs/eventModel.dart';
import 'package:rallyapp/blocs/friendModel.dart';
import 'package:rallyapp/blocs/authModel.dart';
import 'package:rallyapp/blocs/navigationBloc.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final friendModel = FriendModel();
final eventModel = EventModel();
final authModel = AuthModel();
//final stateModel = StateModel();


Future setListeners() async{
//  await stateModel.toggleLoading();
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

//  // Grabbing user data
//  await database.reference().child('user/$uid/info').once().then((snapshot) =>{
//  authModel.setUser(snapshot.value)
//  });
//
//
//  // Setting Listener on User Info CHANGE
//  database.reference().child('user/$uid/info').onChildChanged.listen((event){
//    print(' -- CHANGE -- user info');
//    print('user info changed: ${event.snapshot.key} ${event.snapshot.value}');
//    authModel.replaceValue(event.snapshot.key, event.snapshot.value);
//  });
//
//
//  // Setting Listener on User event CHANGE, effects the info details of that event
//  database.reference().child('user/$uid/events').onChildChanged.listen((event){
//    print(' -- CHANGE -- user events');
//    eventModel.replace(event.snapshot.key, event.snapshot.value);
//  });
//
//  // Setting Listener on User event ADD
//  database.reference().child('user/$uid/events').onChildAdded.listen((Event event) async{
//    print(' -- ADD -- user events');
//    await eventModel.add(event.snapshot.key, event.snapshot.value);
//  });
//
//  // Setting Listener on User event REMOVE
//  database.reference().child('user/$uid/events').onChildRemoved.listen((Event event){
//    print(' -- REMOVE -- user events');
//    eventModel.remove(event.snapshot.key);
//  });
//  //////////////////////////////////////////////////////////////////////////////
//  //////////////////////////////////////////////////////////////////////////////
//  //////////////////////////////////////////////////////////////////////////////
//
//
//  // Setting Listener on friend REMOVE
//  // TODO turn off listeners on removed friend's details
//  database.reference().child('user/$uid/friends').onChildRemoved.listen((event){
//    print(' -- REMOVE -- friend ');
//    friendModel.remove(event.snapshot.key);
//  });
//
//
//  ////////////////////////////////////////////////////////////////////////////
//  //////// FRIEND RELATED LISTENERS
//  ////////////////////////////////////////////////////////////////////////////
//
//    database.reference().child('user/$uid/friends').onChildAdded.listen((event) async{
//    var friendID = event.snapshot.key;
//    print('friendID ============ $friendID');
//    print(' -- ADD -- friend ');
//
//    // GRAB friend info
//    await database.reference().child('user/$friendID/info').once().then((snapshot){
//      print('Grabbing friend Info: ${snapshot.value}');
//      friendModel.add(friendID,snapshot.value);
//    });
//    // Settings Listener on friends info CHANGE
//    database.reference().child('user/$friendID/info').onChildChanged.listen((event){
//      print(' -- CHANGED -- friend info');
//      friendModel.replace(friendID,event.snapshot.key,event.snapshot.value);
//    });
//    // Setting Listener on friend's events detail CHANGE
//    database.reference().child('user/$friendID/events').onChildChanged.listen((event) {
//      print(' -- CHANGED -- friend event');
//      eventModel.replace(event.snapshot.key, event.snapshot.value);
//    });
//    // Setting Listener on friend's events ADD
//    database.reference().child('user/$friendID/events').onChildAdded.listen((event){
//      print(' -- ADD -- friend event');
//      eventModel.add(event.snapshot.key, event.snapshot.value);
//    });
//    // Setting Listener on friend's event REMOVE
//    database.reference().child('user/$friendID/events').onChildRemoved.listen((event) {
//      print(' -- REMOVE -- friend event');
//      eventModel.remove(event.snapshot.key);
//    });
//  });
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
}