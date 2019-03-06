import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

main() {
  runApp(
    MaterialApp(
      title: 'Rally',
      home: SignInPage(),
    ),
  );
}

class SignInPage extends StatefulWidget {
  final String title = 'Sign In';
  @override
  State<StatefulWidget> createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),

        body: Builder(builder: (BuildContext context) {
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                  },
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  alignment: Alignment.center,
                  child: RaisedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _signInWithEmailAndPassword();
                      }
                    },
                    child: const Text('SIGN IN'),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: RaisedButton(
                    onPressed: _signInWithGoogle,
                    child: const Text('SIGN IN WITH GOOGLE'),
                  ),
                ),
              ],
            ),
          );
        }),
      );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signInWithEmailAndPassword() async {
    final FirebaseUser user = await _auth.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (user != null) {
      _setListeners();
    } else {
      // Throw Errors Here!!
    }
  }

  void _signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user = await _auth.signInWithCredential(credential);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
      if (user != null) {
        _setListeners();
      } else {
        // Throw Errors Here!!
      }
  }
}


Future<void> _setListeners() async{
  print('Settings Listeners');
  final FirebaseUser user = await _auth.currentUser();
  var uid = user.uid;
  print('userID: $uid');

  final FirebaseApp app = await FirebaseApp.configure(
    name: 'rallydev',
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









