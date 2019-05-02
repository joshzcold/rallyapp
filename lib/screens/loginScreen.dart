import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rallyapp/blocs/app/theme.dart';
import 'package:rallyapp/fireListener.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

class SignInPage extends StatelessWidget {
  void signInWithEmailAndPassword(context) async {
    final FirebaseUser user = await _auth
        .signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        )
        .catchError((error) => _showAlert(error.code, error.message, context));
    if (user != null && user.isEmailVerified) {
      setListeners(context);
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      if (!user.isEmailVerified) {
        _showAlert(
            "Email Verification",
            "Account email is not verified, "
            "a new verification email has been sent to ${user.email}",
            context);
      }
      user.sendEmailVerification();
    }
  }

  void signInWithGoogle(context) async {
    final GoogleSignInAccount googleUser = await _googleSignIn
        .signIn()
        .catchError((error) => _showAlert(error.code, error.message, context));
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user = await _auth
        .signInWithCredential(credential)
        .catchError((error) => _showAlert(error.code, error.message, context));
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

  void _showAlert(title, text, context) {
    final _themeBloc = BlocProvider.of<ThemeBloc>(context);
    ThemeLoaded theme = _themeBloc.currentState;

    if (title == "ERROR_INVALID_EMAIL") {
      title = "Email Formatting Error";
      text = "It looks like you made a typo in your email "
          "make sure it has the format *****@***.***";
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            backgroundColor: theme.theme['card'],
            title: new Text(
              title,
              style: TextStyle(color: theme.theme['textTitle']),
            ),
            content: new Text(
              text,
              style: TextStyle(color: theme.theme['text']),
            ),
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
    } else if (title == "ERROR_WRONG_PASSWORD" ||
        title == "ERROR_USER_NOT_FOUND") {
      title = "Incorrect Username or Password";
      text = "Please try again or try the forgotten password feature to "
          "recover your account";

      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            backgroundColor: theme.theme['card'],
            title: new Text(
              title,
              style: TextStyle(color: theme.theme['textTitle']),
            ),
            content: new Text(
              text,
              style: TextStyle(color: theme.theme['text']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Forgotten Password"),
                onPressed: () {
                  Navigator.of(context).pop();
                  forgottenPasswordDialog(context);
                },
              ),
              FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            backgroundColor: theme.theme['card'],
            title: new Text(
              title,
              style: TextStyle(color: theme.theme['textTitle']),
            ),
            content: new Text(
              text,
              style: TextStyle(color: theme.theme['text']),
            ),
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
  }

  void forgottenPasswordDialog(
    context,
  ) {
    final _themeBloc = BlocProvider.of<ThemeBloc>(context);
    ThemeLoaded theme = _themeBloc.currentState;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: theme.theme['card'],
          title: new Text(
            "Forgotten Password",
            style: TextStyle(color: theme.theme['textTitle']),
          ),
          content: Text(
            _emailController.text,
            style: TextStyle(color: theme.theme['text']),
          ),
          actions: <Widget>[
            FlatButton(
              child: new Text(
                "Close",
                style: TextStyle(color: theme.theme['text']),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Send Reset Email"),
              onPressed: () async {
                await _auth
                    .sendPasswordResetEmail(email: _emailController.text)
                    .catchError((error) {
                  _showAlert(error.code, error.message, context);
                }).then((_) {
                  Navigator.of(context).pop();
                  _showAlert(
                      'Reset email sent',
                      "You should recieve an email soon if you do not recieve an email "
                      "please try again or contact the developers for assistance, thank you.",
                      context);
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _themeBloc = BlocProvider.of<ThemeBloc>(context);
    ThemeLoaded theme = _themeBloc.currentState;
    var maxWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: theme.theme['background'],
        body: SingleChildScrollView(
            child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/rallyFlagBlue.png',
                scale: 2,
              ),
              Text(
                'R A L L Y',
                style: TextStyle(
                    color: theme.theme['textTitle'],
                    fontWeight: FontWeight.bold,
                    fontSize: 42),
              ),
              Container(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: maxWidth * .80,
                      child: TextFormField(
                        style: TextStyle(color: theme.theme['text']),
                        controller: _emailController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            hintText: 'Email',
                            hintStyle: TextStyle(color: theme.theme['text'])),
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
                        obscureText: true,
                        style: TextStyle(color: theme.theme['text']),
                        controller: _passwordController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            hintText: 'Password',
                            hintStyle: TextStyle(color: theme.theme['text'])),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/register');
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                color: theme.theme['colorSecondary'],
                              ),
                              child: Text(
                                'SIGN UP',
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                        FlatButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                signInWithEmailAndPassword(context);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                color: theme.theme['colorPrimary'],
                              ),
                              child: Text(
                                'SIGN IN',
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: 10,
              ),
              FlatButton(
                  onPressed: () {
                    signInWithGoogle(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: theme.theme['colorPrimary'],
                    ),
                    child: Text(
                      'SIGN IN WITH GOOGLE',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
            ],
          ),
        )));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
  }
}
