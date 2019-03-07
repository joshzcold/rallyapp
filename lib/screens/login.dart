import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:rallyapp/model/authModel.dart';
import 'package:rallyapp/listener.dart';


final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

class SignInPage extends StatelessWidget{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign in"),
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
                      _signInWithEmailAndPassword(context);
                    }
                  },
                  child: const Text('SIGN IN'),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: RaisedButton(
                  onPressed: _signInWithGoogle(context),
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
  }


   _signInWithEmailAndPassword(BuildContext context) async {
    var authModel = ScopedModel.of<AuthModel>(context);

    final FirebaseUser user = await _auth.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (user != null) {
      authModel.setUser(user);
      setListeners();
      Navigator.pushReplacementNamed(context, 'calendar');
    } else {
      // Throw Errors Here!!
    }
  }

   _signInWithGoogle(BuildContext context) async {
    var authModel = ScopedModel.of<AuthModel>(context);

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
      authModel.setUser(user);
      setListeners();
      Navigator.pushReplacementNamed(context, 'calendar');
    } else {
      // Throw Errors Here!!
    }
  }

}