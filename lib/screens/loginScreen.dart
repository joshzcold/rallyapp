import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rallyapp/fireListener.dart';


final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

class SignInPage extends StatelessWidget{

  void signInWithEmailAndPassword(context) async {
    final FirebaseUser user = await _auth.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    ).catchError((error) =>
      _showAlert(error.code, error.message, context)
    );
    if (user != null && user.isEmailVerified) {
      setListeners(context);
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      if(!user.isEmailVerified){ _showAlert("Email Verification","Account email is not verified, "
          "a new verification email has been sent to ${user.email}", context);}
      user.sendEmailVerification();
    }
  }

  void signInWithGoogle(context) async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn().catchError((error) => _showAlert(error.code, error.message, context));
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user = await _auth.signInWithCredential(credential).catchError((error) => _showAlert(error.code, error.message, context));
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    if (user != null) {
      setListeners(context);
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      // Throw Errors Here!!
    }
  }

  void _showAlert(title,text, context) {
    // TODO process title for erro codes then make the title and message for friendly
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(text),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var maxWidth = MediaQuery.of(context).size.width;
    var maxHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: ListView(
        children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(height: 100,),
            Form(
              key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: maxWidth * .80,
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                            ),
                            hintText: 'Email',
                          ),
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                          },
                        ),
                      ),
                      Container(
                        height: 10,
                      ),
                      Container(
                        width: maxWidth * .80,
                        child: TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                            ),
                            hintText: 'Password',
                          ),
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                          },
                        ),
                      ),
                      Container(height: 10,),
                      Container(
                        alignment: Alignment.center,
                        child: RaisedButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              signInWithEmailAndPassword(context);
                            }
                          },
                          child: const Text('SIGN IN'),
                        ),
                      ),
                    ],
                  ),
                ),

            Container(
              height: 30,
            ),
            Container(
              alignment: Alignment.center,
              child: RaisedButton(
                onPressed: ()  {
                  Navigator.pushReplacementNamed(context, '/register');
                },
                child: const Text('SIGN UP'),
              ),
            ),
            Container(height: 10,),
            Container(
              alignment: Alignment.center,
              child: RaisedButton(
                onPressed: (){
                  signInWithGoogle(context);
                },
                child: const Text('SIGN IN WITH GOOGLE'),
              ),
            ),
          ],
        ),
        ],
      )
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
  }

}



