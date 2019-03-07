import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rallyapp/model/eventModel.dart';
import 'package:rallyapp/model/friendModel.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final friendModel = FriendModel();
final eventModel = EventModel();

Future<void> _setListeners() async{
  print('Settings Listeners');
  final FirebaseUser user = await _auth.currentUser();
  var uid = user.uid;
  print('userID: $uid');

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


  // Setting friends Info Listener
  database.reference().child('user/$uid/friends').once().then((DataSnapshot snapshot) {
    var values = new Map<String, dynamic>.from(snapshot.value);
    values.forEach((k, v) =>
    {
    // k represents each friend's uid pulled from the user's friend list
    // Settings Listener on friends info CHANGE
    database.reference().child('user/$k/info').onChildChanged.listen((event){
      print(' -- CHANGED -- friend info');
      print('friend id: $k');
      print('friends info that changed: ${event.snapshot.key}: ${event.snapshot.value}');
    }),

    // Setting Listener on friend's events detail CHANGE
    database.reference().child('user/$k/events').onChildChanged.listen((event) {
      print(' -- CHANGED -- friend info');
      print('friend id: $k');
      print('details of event changed: ${event.snapshot.key}: ${event.snapshot.value}');      }),

    // Setting Listener on friend's events ADD
    database.reference().child('user/$k/events').onChildAdded.listen((event) {
      print(' -- ADD -- friend event');
      print('friend id: $k');
      print('friends event added: ${event.snapshot.key}: ${event.snapshot.value}');      }),

    // Setting Listener on friend's event REMOVE
    database.reference().child('user/$k/events').onChildRemoved.listen((event) {
      print(' -- REMOVE -- friend info');
      print('friend id: $k');
      print('friends event removed: ${event.snapshot.key}: ${event.snapshot.value}');      }),
    });
  });


  // Setting Listener on User Info CHANGE
  database.reference().child('user/$uid/info').onChildChanged.listen((event){
    print(' -- CHANGE -- user info');
    print('user info changed: ${event.snapshot.key} ${event.snapshot.value}');
  });

  // Setting Listener on friend ADD
  database.reference().child('user/$uid/friends').onChildAdded.listen((event){
    print(' -- ADD -- friend ');
    print('friend added: ${event.snapshot.key} ${event.snapshot.value}');
    friendModel.add(event.snapshot.key, event.snapshot.value);
  });

  // Setting Listener on friend REMOVE
  database.reference().child('user/$uid/friends').onChildRemoved.listen((event){
    print(' -- REMOVE -- friend ');
    print('friend removed: ${event.snapshot.key} ${event.snapshot.value}');
  });

  // Setting Listener on User event CHANGE, effects the info details of that event
  database.reference().child('user/$uid/events').onChildChanged.listen((event){
    print(' -- CHANGE -- user events');
    print('event that was changed: ${event.snapshot.key}: ${event.snapshot.value}');
  });

  // Setting Listener on User event ADD
  database.reference().child('user/$uid/events').onChildAdded.listen((Event event){
    print(' -- ADD -- user events');
    print('event that was added: ${event.snapshot.key}: ${event.snapshot.value}');
  });

  // Setting Listener on User event REMOVE
  database.reference().child('user/$uid/events').onChildRemoved.listen((Event event){
    print(' -- REMOVE -- user events');
    print('event that was removed: ${event.snapshot.key}: ${event.snapshot.value}');
  });
}