import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:rallyapp/blocs/auth/auth.dart';
import 'package:rallyapp/fireActions.dart';
import 'package:rallyapp/widgets/themeButton.dart';
import 'package:rallyapp/widgets/themeSelector.dart';
import 'package:rallyapp/blocs/app/theme.dart';
import 'package:rallyapp/widgets/uploadPhotoButton.dart';

Widget themeSelectorModal;
Widget photoUploadModal;
bool checkImageLoad;


class Settings extends StatefulWidget{
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings>{
  FireActions fireAction = new FireActions();


  @override
  void initState(){
    super.initState();
    themeSelectorModal = Container();
    photoUploadModal = Container();
    checkImageLoad = true;
  }

  @override
  Widget build(BuildContext context) {
    ThemeBloc _themeBloc = BlocProvider.of<ThemeBloc>(context);
    ThemeLoaded theme = _themeBloc.currentState;

    AuthBloc _authBloc = BlocProvider.of<AuthBloc>(context);

    void openCamera() async{
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
      try{
        fireAction.uploadUserPhoto(croppedFile, context);
      } catch(e){
        print(e);
      }

    }

    void openGallery() async{
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
          toolbarWidgetColor: theme.theme['text']
      );
      print('cropped Gallery');
      try{
        fireAction.uploadUserPhoto(croppedFile, context);
      } catch(e){
        print(e);
      }

    }

    getUploadPhotoModal(theme){
      setState(() {
        photoUploadModal = LayoutBuilder(builder: (context, constraints){
          var maxHeight = constraints.maxHeight;
          var maxWidth = constraints.maxWidth;
          var cardHeightMultiplier = 0.20;
          var cardWidthMultiplier = 0.50;

          if(maxWidth > maxHeight){
            cardHeightMultiplier = 0.80;
            cardWidthMultiplier = 0.70;
          }
          return InkWell(
            onTap: (){
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
                          onTap: (){
                            openGallery();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(Icons.photo, color: theme.theme['colorPrimary'],),
                              Text('Gallery', style: TextStyle(color: theme.theme['textTitle']),)
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            openCamera();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(Icons.photo_camera, color: theme.theme['colorPrimary'],),
                              Text('Camera', style: TextStyle(color: theme.theme['textTitle']),)
                            ],
                          ),
                        )
                      ],
                    ),
                  )
              ),
            ),
          );
        });
      });
    }

    uploadPhotoButton(auth){
      return Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(height: 20,),
          InkWell(
            onTap: () async{
              getUploadPhotoModal(theme);
            },
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: CircleAvatar(
                    backgroundColor: theme.theme['card'],
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
                          decoration: BoxDecoration(color: theme.theme['colorPrimary'], borderRadius: BorderRadius.all(Radius.circular(100))),
                          padding: EdgeInsets.all(7.0),
                          child: Icon(Icons.camera, color: Colors.white,),
                        ),
                      ],
                    )

                )
              ],
            ),
          )
        ],
      );
    }

    return Scaffold(
      backgroundColor: theme.theme['background'],
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back, color: theme.theme['headerText'],), onPressed: (){Navigator.pop(context);}),
        title: Text('Settings', style: TextStyle(color: theme.theme['headerText']),), backgroundColor: theme.theme['header'],),
      body: BlocBuilder(
        bloc: _authBloc,
        builder: (context, auth){
          return LayoutBuilder(builder: (context, constraints){
            return Container(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: Stack(
                children: <Widget>[
                  ListView(
                    children: <Widget>[
                      uploadPhotoButton(auth),
                      themeButton(context, constraints, getThemeSelectorModal),
                    ],
                  ),
                  AnimatedSwitcher(
                    // the duration can be adjusted to expand the friend events
                    // faster or slower.
                      duration: Duration(milliseconds: 300),
                      transitionBuilder: (Widget child, Animation<double>animation) {
                        return FadeTransition(opacity: animation,
                          child: child,
                        );
                      },
                      child: themeSelectorModal
                  ),
                  AnimatedSwitcher(
                    // the duration can be adjusted to expand the friend events
                    // faster or slower.
                      duration: Duration(milliseconds: 300),
                      transitionBuilder: (Widget child, Animation<double>animation) {
                        return FadeTransition(opacity: animation,
                          child: child,
                        );
                      },
                      child: photoUploadModal
                  ),
                ],
              ),
            );
          });
        },
      )
    );
  }

  getThemeSelectorModal() {
    setState(() {
      themeSelectorModal = themeSelector(context, closeThemeSelectorModal);
    });
  }

  closeThemeSelectorModal(){
    setState(() {
      themeSelectorModal = Container();
    });
  }

  closeUploadPhotoModal(){
    setState(() {
      photoUploadModal = Container();
    });
  }
}
