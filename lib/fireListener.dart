import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rallyapp/blocs/app/invite.dart';
import 'package:rallyapp/blocs/app/notifyBloc.dart';
import 'package:rallyapp/blocs/app/theme.dart';

import 'package:rallyapp/blocs/events/event.dart';
import 'package:rallyapp/blocs/friends/friends.dart';
import 'package:rallyapp/blocs/auth/auth.dart';
import 'package:rallyapp/calendar/calendarScreen.dart';
import 'package:rallyapp/main.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;



 setListeners(BuildContext context) async{
   final friendBloc = BlocProvider.of<FriendsBloc>(context);
  final authBloc = BlocProvider.of<AuthBloc>(context);
  final eventBloc = BlocProvider.of<EventsBloc>(context);
  final inviteBloc = BlocProvider.of<InviteBloc>(context);
  final notifyBloc = BlocProvider.of<NotifyBloc>(context);

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
  final FirebaseStorage storage = FirebaseStorage(storageBucket: "gs://rallydev-40f78.appspot.com");

  generateRallyID(){
    var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

    String randomString(int strlen) {
      Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
      String result = "";
      for (var i = 0; i < strlen; i++) {
        result += chars[rnd.nextInt(chars.length)];
      }
      return result;
    }

    var rallyID = '${user.email == null? "RallyUser": user.email.split('@')[0]}-${randomString(5)}';

    return rallyID;
  }

  /// This will get executed by the conditional check at the bottom to make sure the user exists
   /// before setting listeners.
  setUserFriendListeners() async{
    print('Setting Listeners ======================================================');
    //////////////////////////////////////////////////////////////////////////////
    /////// USER RELATED LISTENERS
    //////////////////////////////////////////////////////////////////////////////

    // Grabbing user data
    database.reference().child('user/$uid/info').once().then((snapshot) async{
      var check = snapshot.value['userPhoto'];
      if( check == null){
        var userInfo = Map.of(snapshot.value);
        var url = await storage.ref().child('photos/default').getDownloadURL();
        userInfo['userPhoto'] = url;
        authBloc.dispatch(AddAuth(uid,userInfo));
      } else{
        authBloc.dispatch(AddAuth(uid,snapshot.value));
      }
    }).catchError((error) => print(error));

    // Setting Listener on User Info CHANGE
    database.reference().child('user/$uid/info').onChildChanged.listen((event){
      print(' -- CHANGE -- user info');
      print('user info changed: ${event.snapshot.key} ${event.snapshot.value}');
      authBloc.dispatch(ReplaceAuthInfo(event.snapshot.key, event.snapshot.value));
    });

    // Setting Listener on Users Friends List CHANGE
    database.reference().child('user/$uid/friends').onChildChanged.listen((event){
      print(' -- CHANGE -- friend list item notify');
      notifyBloc.dispatch(ChangeNotify(event.snapshot.key, event.snapshot.value));
    });

    // Setting Listener on Users Friends List CHANGE
    database.reference().child('user/$uid/friends').onChildAdded.listen((event){
      print(' -- ADD -- friend list item notify');
      notifyBloc.dispatch(AddNotify(event.snapshot.key, event.snapshot.value));
    });

    // Setting Listener on User event CHANGE, effects the info details of that event
    database.reference().child('user/$uid/events').onChildChanged.listen((event){
      NotifysLoaded currentNotify = notifyBloc.currentState;
      EventsLoaded currentEvents = eventBloc.currentState;
      var usersEventsBefore = currentEvents.events[uid];
      var eventBefore = usersEventsBefore[event.snapshot.key];
      var a = eventBefore['party'];
      if( a != null){
        var partyBefore = eventBefore['party']['friends'];
        var partyAfter = event.snapshot.value['party']['friends'];
        if(partyBefore == null){partyBefore = {};}
        if(partyAfter == null){ partyAfter = {};}
        if(partyBefore.length < partyAfter.length){
          var foundFriend;
          partyAfter.forEach((key, value){
            if(!partyBefore.containsKey(key)){
              foundFriend = value;
            }
          });
          var eventTitle = event.snapshot.value['title'];
          var startTime = DateTime.fromMillisecondsSinceEpoch(event.snapshot.value['start']);
          var endTime = DateTime.fromMillisecondsSinceEpoch(event.snapshot.value['end']);

          var friendNotifyStatus = currentNotify.notify[foundFriend['id']];

          if(friendNotifyStatus['notifyJoined'] == true || friendNotifyStatus['notifyJoined'] == null){
            _showNotification('${foundFriend['userName']} has joined your event! @$startTime - $endTime','$eventTitle',"joinedFriend,"+event.snapshot.key.toString()+',$uid');
          }
        }
      }

      print(' -- CHANGE -- user events');
      eventBloc.dispatch(ReplaceEventInfo(event.snapshot.key, event.snapshot.value, uid));
    });

    // Setting Listener on User event ADD
    database.reference().child('user/$uid/events').onChildAdded.listen((Event event)  {
      print(' -- ADD -- user events');
      eventBloc.dispatch(AddEvents(uid, event.snapshot.key, event.snapshot.value));
    });

    // Setting Listener on User event REMOVE
    database.reference().child('user/$uid/events').onChildRemoved.listen((Event event){
      print(' -- REMOVE -- user events');
      eventBloc.dispatch(RemoveEvents(uid, event.snapshot.key));
    });

    database.reference().child('user/$uid/invites').onChildAdded.listen((Event event){
      var inviteUser = event.snapshot.value;

      _showNotification('Friend invite from ${inviteUser['userName']}','Rally ID: ${inviteUser['rallyID']}',"friendInvite,"+event.snapshot.key.toString()+',$uid');
      print(' -- ADD -- user invite');
      inviteBloc.dispatch(AddInvite(event.snapshot.key, event.snapshot.value));
    });

    database.reference().child('user/$uid/invites').onChildRemoved.listen((Event event){
      print(' -- REMOVE -- user invite');
      inviteBloc.dispatch(RemoveInvite(event.snapshot.key));
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
      database.reference().child('user/$friendID/info').once().then((snapshot) async{
        print('Grabbing friend Info: ${snapshot.value}');
        var check = snapshot.value['userPhoto'];
        if( check == null){
          var userInfo = Map.of(snapshot.value);
          var url = await storage.ref().child('photos/default').getDownloadURL();
          userInfo['userPhoto'] = url;
          friendBloc.dispatch(AddFriends(friendID, userInfo));
        } else{
          friendBloc.dispatch(AddFriends(friendID, snapshot.value));
        }
      }).catchError((error) => print(error));

      // Settings Listener on friends info CHANGE
      subscriptions[friendID][i++] = database.reference().child('user/$friendID/info').onChildChanged.listen((event){
        print(' -- CHANGED -- friend info');
        friendBloc.dispatch(ReplaceFriendInfo(event.snapshot.key, event.snapshot.value, friendID));
      });

      //       Grabbing friend event data
      database.reference().child('user/$friendID/events').once().then((snapshot){
        print(' -- ADD -- friend event');
        if(snapshot.value != null){
          snapshot.value.forEach((key, value){
            eventBloc.dispatch(AddEvents(friendID, key, value));
          });
        }
      }).catchError((error) => print(error));;

      // Setting Listener on friend's events detail CHANGE
      subscriptions[friendID][i++] = database.reference().child('user/$friendID/events').onChildChanged.listen((event) {
        NotifysLoaded currentNotify = notifyBloc.currentState;
        EventsLoaded currentEvents = eventBloc.currentState;
       var friendsEvents = currentEvents.events[friendID];
         if(friendsEvents == null || !friendsEvents.containsKey(event.snapshot.key)){
           print('Sending Notification Friend Event ADD');
           var eventValue = event.snapshot.value;
           var friendUserName = eventValue['userName'];
           var startTime = DateTime.fromMillisecondsSinceEpoch(eventValue['start']);
           var endTime = DateTime.fromMillisecondsSinceEpoch(eventValue['end']);
           var eventTitle = eventValue['title'];
           var friendPhoto = eventValue['userPhoto'];
           var userID = eventValue['user'];


           var friendNotifyStatus = currentNotify.notify[friendID];

           if(friendNotifyStatus['notifyEvent'] == true || friendNotifyStatus['notifyEvent'] == null) {
             _showNotification(
                 'New event from $friendUserName! @$startTime - $endTime',
                 '$eventTitle',
                 "friendEvent," + event.snapshot.key.toString() + ',$userID');
           }
         }

        print(' -- CHANGED -- friend event');
        eventBloc.dispatch(ReplaceEventInfo(event.snapshot.key, event.snapshot.value, friendID));
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
        friendBloc.dispatch(RemoveFriends(friendID));
        eventBloc.dispatch(RemoveAllEventsFromFriend(friendID));

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


  void createInitialUserData(rallyID) {
    print('Creating Initial Data ====================================================');

     database.reference().child('rally/$rallyID').set({
      "userID": user.uid,
      "userName": user.displayName,
    });
     database.reference().child('user/$uid/info').set({
      "rallyID": rallyID,
      "userEmail": user.email,
      "userName": user.email == null? "RallyUser" : user.email.split('@')[0],
      "userPhoto": user.photoUrl,
    }).then((something) => setUserFriendListeners());
    
  }

  // generateRallyID only sends back a random value combined with a username.
  void getRallyID() {
    var rallyID =  generateRallyID();
    var items;
     database.reference().child('rally/').once().then((snapshot) =>{
      items = snapshot.value
    }).then((something){
      // check if the generated RallyID is found within the snapshot of the rally
       // directory. Not the best way to check but since flutter doesn't currently
       // have a function like .exists() this is what works for now...
      items.containsKey(rallyID)? getRallyID(): createInitialUserData(rallyID);
     }).catchError((error) => print(error));
  }

  /// BIG OLE Check to make sure the user has data before setting listeners
  database.reference().child('user/$uid/info').once().then((snapshot) {
    snapshot.value == null? getRallyID() : setUserFriendListeners();
  }).catchError((error) => print(error));

}

Future<void> _showNotification(title, body, payload) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'rallyupapp', 'rally-notification', 'notifications from rally up. Events, Invites, Alerts',
      importance: Importance.Max, priority: Priority.High);
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, title, body, platformChannelSpecifics,
      payload: payload);
}

