import 'package:flutter/material.dart';


uploadPhotoButton(theme, auth){
  return Column(
    mainAxisSize: MainAxisSize.max,
    children: <Widget>[
      Container(height: 20,),
      Container(
        child: Stack(
          children: <Widget>[
            InkWell(
              onTap: (){

              },
              child: CircleAvatar(
                backgroundColor: theme.theme['card'],
                radius: 50,
                backgroundImage: NetworkImage(auth.value['userPhoto']),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: InkWell(
                  onTap: () {

                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(color: theme.theme['colorPrimary'], borderRadius: BorderRadius.all(Radius.circular(100))),
                        padding: EdgeInsets.all(10.0),
                        child: Icon(Icons.camera, color: Colors.white,),
                      ),
                    ],
                  )
              ),
            )
          ],
        ),
      )
    ],
  );
}