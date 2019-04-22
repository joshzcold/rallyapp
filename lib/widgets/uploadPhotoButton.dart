import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


uploadPhotoButton(theme, auth, getUploadPhotoModal){
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
