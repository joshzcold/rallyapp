import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:rallyapp/blocs/auth/auth.dart';
import 'package:rallyapp/fireActions.dart';
import 'package:rallyapp/screens/donateScreen.dart';
import 'package:rallyapp/widgets/changeUsername.dart';
import 'package:rallyapp/widgets/themeButton.dart';
import 'package:rallyapp/widgets/themeSelector.dart';
import 'package:rallyapp/blocs/app/theme.dart';
import 'package:url_launcher/url_launcher.dart';

Widget modal;

bool checkImageLoad;

class Settings extends StatefulWidget {
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  FireActions fireAction = new FireActions();

  @override
  void initState() {
    super.initState();
    modal = Container();
    checkImageLoad = true;
  }

  @override
  Widget build(BuildContext context) {
    ThemeBloc _themeBloc = BlocProvider.of<ThemeBloc>(context);
    ThemeLoaded theme = _themeBloc.currentState;

    AuthBloc _authBloc = BlocProvider.of<AuthBloc>(context);

    void openCamera() async {
      closeUploadPhotoModal();
      File picture = await ImagePicker.pickImage(
        source: ImageSource.camera,
      );
      File croppedFile = await ImageCropper.cropImage(
        sourcePath: picture.path,
        ratioX: 1.0,
        ratioY: 1.0,
        maxWidth: 512,
        maxHeight: 512,
        circleShape: true,
        toolbarColor: theme.theme['background'],
        statusBarColor: theme.theme['header'],
        toolbarWidgetColor: theme.theme['text'],
      );
      print('cropped Photo');
      try {
        fireAction.uploadUserPhoto(croppedFile, context);
        _showDialog(context, "Photo upload was good!", "You should see your new photo in your events and on your user card");
      } catch (e) {
        print(e);
        _showDialog(context, "ERROR PHOTO", "Photo upload failed. either the file was rejected or the database has a network issue");
      }
    }

    void openGallery() async {
      closeUploadPhotoModal();
      var picture = await ImagePicker.pickImage(
        source: ImageSource.gallery,
      );
      File croppedFile = await ImageCropper.cropImage(
          sourcePath: picture.path,
          ratioX: 1.0,
          ratioY: 1.0,
          maxWidth: 512,
          maxHeight: 512,
          circleShape: true,
          toolbarColor: theme.theme['background'],
          statusBarColor: theme.theme['header'],
          toolbarWidgetColor: theme.theme['text']);
      print('cropped Gallery');
      try {
        fireAction.uploadUserPhoto(croppedFile, context);
      } catch (e) {
        print(e);
      }
    }

    getUploadPhotoModal(theme) {
      setState(() {
        modal = LayoutBuilder(builder: (context, constraints) {
          var maxHeight = constraints.maxHeight;
          var maxWidth = constraints.maxWidth;
          var cardHeightMultiplier = 0.20;
          var cardWidthMultiplier = 0.50;

          if (maxWidth > maxHeight) {
            cardHeightMultiplier = 0.80;
            cardWidthMultiplier = 0.70;
          }
          return InkWell(
            onTap: () {
              closeUploadPhotoModal();
            },
            child: Container(
              height: maxHeight,
              width: maxWidth,
              decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.5)),
              alignment: Alignment.center,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    boxShadow: [
                      new BoxShadow(
                        color: theme.theme['shadow'],
                        blurRadius: 5.0,
                        offset: Offset(0.0, 0.0),
                      )
                    ],
                    color: theme.theme['background'],
                  ),
                  height: maxHeight * cardHeightMultiplier,
                  width: maxWidth * cardWidthMultiplier,
                  alignment: Alignment.center,
                  child: Container(
                    width: (maxWidth * cardWidthMultiplier) - 30,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            openGallery();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(
                                Icons.photo,
                                color: theme.theme['colorPrimary'],
                              ),
                              Text(
                                'Gallery',
                                style:
                                    TextStyle(color: theme.theme['textTitle']),
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            openCamera();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(
                                Icons.photo_camera,
                                color: theme.theme['colorPrimary'],
                              ),
                              Text(
                                'Camera',
                                style:
                                    TextStyle(color: theme.theme['textTitle']),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
            ),
          );
        });
      });
    }

    uploadPhotoButton(auth) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            height: 20,
          ),
          InkWell(
            onTap: () async {
              getUploadPhotoModal(theme);
            },
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 50,
                    backgroundImage: NetworkImage(auth.value['userPhoto']),
                  ),
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: Row(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              color: theme.theme['colorPrimary'],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                          padding: EdgeInsets.all(7.0),
                          child: Icon(
                            Icons.camera,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          )
        ],
      );
    }

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: theme.theme['background'],
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: theme.theme['headerText'],
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            'Settings',
            style: TextStyle(color: theme.theme['headerText']),
          ),
          backgroundColor: theme.theme['header'],
          actions: <Widget>[
            InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Donate()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 15,
                  ),
                  Text(
                    'Donate',
                    style: TextStyle(
                        color: theme.theme['headerText'],
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: 15,
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                // Send an email
                String now = DateTime.now().toString();
                String body = 'I found a bug, please fix: ';
                var url =
                    "mailto:rallydev@rallyup.app?subject=Contact-$now&body=$body";
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      // return object of type Dialog
                      return AlertDialog(
                        backgroundColor: theme.theme['card'],
                        title: new Text(
                          "Could not launch mail app",
                          style: TextStyle(color: theme.theme['textTitle']),
                        ),
                        content: new Text(
                          "Rally could not launch a valid mail app. " +
                              "If you have an issue or bug please email rallydev@rallyup.app thank you.",
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
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 15,
                  ),
                  Text(
                    'Contact Dev',
                    style: TextStyle(
                        color: theme.theme['headerText'],
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: 15,
                  )
                ],
              ),
            ),
          ],
        ),
        body: BlocBuilder(
          bloc: _authBloc,
          builder: (context, auth) {
            return LayoutBuilder(builder: (context, constraints) {
              return Container(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                child: Stack(
                  children: <Widget>[
                    ListView(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            uploadPhotoButton(auth),
                            FlatButton(
                              color: theme.theme['colorSecondary'],
                              onPressed: () {
                                setState(() {
                                  modal = changeUsername(
                                      context, closeThemeSelectorModal);
                                });
                              },
                              child: Text(
                                'Change Username',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        ),
                        themeButton(
                            context, constraints, getThemeSelectorModal),
                        Container(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            DeleteOldEventsButton(),
                          ],
                        ),
                        Container(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[DeleteAllEventsButton()],
                        ),
                        Container(
                          height: 30,
                        ),
                      ],
                    ),
                    AnimatedSwitcher(
                        // the duration can be adjusted to expand the friend events
                        // faster or slower.
                        duration: Duration(milliseconds: 300),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child: modal),
                  ],
                ),
              );
            });
          },
        ));
  }

  getThemeSelectorModal() {
    setState(() {
      modal = themeSelector(context, closeThemeSelectorModal);
    });
  }

  closeThemeSelectorModal() {
    setState(() {
      modal = Container();
    });
  }

  closeUploadPhotoModal() {
    setState(() {
      modal = Container();
    });
  }
}

class DeleteOldEventsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _themeBloc = BlocProvider.of<ThemeBloc>(context);
    ThemeLoaded theme = _themeBloc.currentState;

    return GestureDetector(
        onTap: () {
          _showDeleteOldEventsDialog(context, "Are you sure?",
              "Do you want to delete all events before the current time?");
        },
        child: Container(
            decoration: BoxDecoration(
                color: theme.theme['colorSecondary'],
                borderRadius: BorderRadius.all(Radius.circular(8))),
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Text(
                  'Delete Old Events',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                Container(
                  width: 20,
                ),
                Icon(
                  Icons.clear_all,
                  color: Colors.white,
                )
              ],
            )));
  }
}

class DeleteAllEventsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _themeBloc = BlocProvider.of<ThemeBloc>(context);
    ThemeLoaded theme = _themeBloc.currentState;
    return InkWell(
        onTap: () {
          _showDeleteAllEventsDialog(context, "Are you sure?",
              "do you want to delete all of your events on the calendar?");
        },
        child: Container(
            decoration: BoxDecoration(
                color: theme.theme['colorDanger'],
                borderRadius: BorderRadius.all(Radius.circular(8))),
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Text(
                  'Delete All Events',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                Container(
                  width: 20,
                ),
                Icon(
                  Icons.delete_forever,
                  color: Colors.white,
                )
              ],
            )));
  }
}

_showDeleteAllEventsDialog(context, title, content) {
  final _themeBloc = BlocProvider.of<ThemeBloc>(context);
  ThemeLoaded theme = _themeBloc.currentState;
  // flutter defined function
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
          content,
          style: TextStyle(color: theme.theme['textTitle']),
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text(
              "Yes",
              style: TextStyle(color: theme.theme['colorDanger']),
            ),
            onPressed: () {
              fireActions.deleteAllEvents();
              Navigator.pop(context);
            },
          ),
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text(
              "Close",
              style: TextStyle(color: theme.theme['colorSecondary']),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

_showDialog(context, title, content) {
  final _themeBloc = BlocProvider.of<ThemeBloc>(context);
  ThemeLoaded theme = _themeBloc.currentState;
  // flutter defined function
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
          content,
          style: TextStyle(color: theme.theme['textTitle']),
        ),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text(
              "Close",
              style: TextStyle(color: theme.theme['colorSecondary']),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

_showDeleteOldEventsDialog(context, title, content) {
  final _themeBloc = BlocProvider.of<ThemeBloc>(context);
  ThemeLoaded theme = _themeBloc.currentState;
  // flutter defined function
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
          content,
          style: TextStyle(color: theme.theme['textTitle']),
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text(
              "Yes",
              style: TextStyle(color: theme.theme['colorDanger']),
            ),
            onPressed: () {
              fireActions.deleteOldEvents();
              Navigator.pop(context);
            },
          ),
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text(
              "Close",
              style: TextStyle(color: theme.theme['colorSecondary']),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
