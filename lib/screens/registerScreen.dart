import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rallyapp/blocs/app/theme.dart';
import 'package:rallyapp/fireListener.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class RegisterPage extends StatefulWidget {
  final String title = 'Registration';
  @override
  State<StatefulWidget> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success;
  String _userEmail;
  @override
  Widget build(BuildContext context) {
    final _themeBloc = BlocProvider.of<ThemeBloc>(context);
    ThemeLoaded theme = _themeBloc.currentState;
    var maxWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar:  AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back, color: theme.theme['headerText'],), onPressed: (){Navigator.pop(context);}),
          title: Text('Register', style: TextStyle(color: theme.theme['headerText']),), backgroundColor: theme.theme['header'],),
        backgroundColor: theme.theme['background'],
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(height: MediaQuery.of(context).size.height/4,),
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
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            ),
                            hintText: 'Email',
                            hintStyle: TextStyle(color: theme.theme['text'])
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
                        obscureText: true,
                        style: TextStyle(color: theme.theme['text']),
                        controller: _passwordController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            ),
                            hintText: 'Password',
                            hintStyle: TextStyle(color: theme.theme['text'])
                        ),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                        },
                      ),
                    ),
                    Container(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                            onPressed: ()  {
                              _register();
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                color: theme.theme['colorPrimary'],
                              ),
                              child: Text('SUBMIT', style: TextStyle(color: Colors.white),),
                            )
                        ),

                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Example code for registration.
   _register() async {
    final FirebaseUser user = await _auth.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    ).catchError((error) => _showAlert(error.code, error.message, context));
    if (user != null) {
      user.sendEmailVerification();
      _showDialog(user.email, context);
    } else {
      _success = false;
    }
  }

  void _showDialog(email, context) {
    final _themeBloc = BlocProvider.of<ThemeBloc>(context);
    ThemeLoaded theme = _themeBloc.currentState;
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: theme.theme['card'],
          title: new Text("Email Verification", style: TextStyle(color: theme.theme['textTitle']),),
          content: new Text("Sent verification email to $email, please verify your account before signing in. Thank you for using Rally!",
            style: TextStyle(color: theme.theme['text']),),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        );
      },
    );
  }

  void _showAlert(title,text, context) {
    final _themeBloc = BlocProvider.of<ThemeBloc>(context);
    ThemeLoaded theme = _themeBloc.currentState;

    if(title == "ERROR_INVALID_EMAIL"){
      title = "Email Formatting Error";
      text = "It looks like you made a typo in your email "
          "make sure it has the format *****@***.***";
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            backgroundColor: theme.theme['card'],
            title: new Text(title, style: TextStyle(color: theme.theme['textTitle']),),
            content: new Text(text, style: TextStyle(color: theme.theme['text']),),
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
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            backgroundColor: theme.theme['card'],
            title: new Text(title, style: TextStyle(color: theme.theme['textTitle']),),
            content: new Text(text, style: TextStyle(color: theme.theme['text']),),
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
}