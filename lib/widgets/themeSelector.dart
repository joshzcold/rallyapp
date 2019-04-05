import 'package:flutter/material.dart';

themeSelector(context, closeThemeSelectorModal){
  return LayoutBuilder(builder: (context, constraints){
    var maxHeight = constraints.maxHeight;
    var maxWidth = constraints.maxWidth;
    var cardHeightMultiplier = 0.60;
    var cardWidthMultiplier = 0.95;

    if(maxWidth > maxHeight){
      cardHeightMultiplier = 0.80;
      cardWidthMultiplier = 0.70;
    }
    return InkWell(
      onTap: (){
        closeThemeSelectorModal();
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
                color: Colors.grey[500],
                blurRadius: 5.0,
                offset: Offset(0.0, 0.0),
              )
            ],
            color: Colors.white,
          ),
            height: maxHeight * cardHeightMultiplier,
            width: maxWidth * cardWidthMultiplier,
            alignment: Alignment.center,
            child: Container(
              width: (maxWidth * cardWidthMultiplier) - 30,
              child: ListView(
                children: <Widget>[
                  /// THE CARDS INSIDE THE CARD
                  Container(height: 20,),
                  lightThemeCard(maxWidth, cardWidthMultiplier),
                  Container(height: 10,),
                  darkThemeCard(maxWidth, cardWidthMultiplier),
                  Container(height: 10,),
                  amoLEDThemeCard(maxWidth, cardWidthMultiplier),
                  Container(height: 10,),
                  blueThemeCard(maxWidth, cardWidthMultiplier),
                  Container(height: 10,),
                  redThemeCard(maxWidth, cardWidthMultiplier),
                  Container(height: 10,),
                  greenThemeCard(maxWidth, cardWidthMultiplier),
                  Container(height: 10,),
                  pinkThemeCard(maxWidth, cardWidthMultiplier),
                  Container(height: 20,),
                ],
              ),
            )
        ),
      ),
    );
  });
}

lightThemeCard(maxWidth, cardWidthMultiplier) {
  return /// LIGHT THEME
    InkWell(
      onTap: (){

      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          /// Background Color
          color: Colors.white,
          border: Border.all(color: Colors.grey)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[

            /// Header font color, label
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8.0))
              ),
              height: 50,
              width: (maxWidth * cardWidthMultiplier) - 30,
              child: Row(
                children: <Widget>[
                  Container(width: 30,),
                  Text('Light',
                    style: TextStyle(color: Colors.grey, fontSize: 20,
                        fontWeight: FontWeight.bold),)
                ],
              ),
            ),

            Container(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ///Colored Circles
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange
                  ),
                ),
              ],
            ),
            Container(height: 10,)
          ],
        ),
      ),
    );
}

darkThemeCard(maxWidth, cardWidthMultiplier) {
  return /// DARK THEME
    InkWell(
      onTap: (){

      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          border: Border.all(color: Colors.grey[700]),
          /// Background Color
          color: Colors.grey[700],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[

            /// Header font color, label
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8.0))
              ),
              height: 50,
              width: (maxWidth * cardWidthMultiplier) - 30,
              child: Row(
                children: <Widget>[
                  Container(width: 30,),
                  Text('Dark',
                    style: TextStyle(color: Colors.white, fontSize: 20,
                        fontWeight: FontWeight.bold),)
                ],
              ),
            ),

            Container(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ///Colored Circles
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange
                  ),
                ),
              ],
            ),
            Container(height: 10,)
          ],
        ),
      ),
    );
}

amoLEDThemeCard(maxWidth, cardWidthMultiplier) {
  return /// AmoLED THEME
    InkWell(
      onTap: (){

      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          border: Border.all(color: Colors.black),
          /// Background Color
          color: Colors.black,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[

            /// Header font color, label
            Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8.0))
              ),
              height: 50,
              width: (maxWidth * cardWidthMultiplier) - 30,
              child: Row(
                children: <Widget>[
                  Container(width: 30,),
                  Text('AMOLED',
                    style: TextStyle(color: Colors.white, fontSize: 20,
                        fontWeight: FontWeight.bold),)
                ],
              ),
            ),

            Container(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ///Colored Circles
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange
                  ),
                ),
              ],
            ),
            Container(height: 10,)
          ],
        ),
      ),
    );
}

blueThemeCard(maxWidth, cardWidthMultiplier) {
  return /// BLUE THEME
    InkWell(
      onTap: (){

      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          border: Border.all(color: Colors.blue),
          /// Background Color
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[

            /// Header font color, label
            Container(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8.0))
              ),
              height: 50,
              width: (maxWidth * cardWidthMultiplier) - 30,
              child: Row(
                children: <Widget>[
                  Container(width: 30,),
                  Text('Blue',
                    style: TextStyle(color: Colors.white, fontSize: 20,
                        fontWeight: FontWeight.bold),)
                ],
              ),
            ),

            Container(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ///Colored Circles
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange
                  ),
                ),
              ],
            ),
            Container(height: 10,)
          ],
        ),
      ),
    );
}

redThemeCard(maxWidth, cardWidthMultiplier) {
  return /// RED THEME
    InkWell(
      onTap: (){

      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          border: Border.all(color: Colors.red),
          /// Background Color
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[

            /// Header font color, label
            Container(
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8.0))
              ),
              height: 50,
              width: (maxWidth * cardWidthMultiplier) - 30,
              child: Row(
                children: <Widget>[
                  Container(width: 30,),
                  Text('Red',
                    style: TextStyle(color: Colors.white, fontSize: 20,
                        fontWeight: FontWeight.bold),)
                ],
              ),
            ),

            Container(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ///Colored Circles
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange
                  ),
                ),
              ],
            ),
            Container(height: 10,)
          ],
        ),
      ),
    );
}

greenThemeCard(maxWidth, cardWidthMultiplier) {
  return /// GREEN THEME
    InkWell(
      onTap: (){

      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          border: Border.all(color: Colors.green),
          /// Background Color
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[

            /// Header font color, label
            Container(
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8.0))
              ),
              height: 50,
              width: (maxWidth * cardWidthMultiplier) - 30,
              child: Row(
                children: <Widget>[
                  Container(width: 30,),
                  Text('Green',
                    style: TextStyle(color: Colors.white, fontSize: 20,
                        fontWeight: FontWeight.bold),)
                ],
              ),
            ),

            Container(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ///Colored Circles
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange
                  ),
                ),
              ],
            ),
            Container(height: 10,)
          ],
        ),
      ),
    );
}

pinkThemeCard(maxWidth, cardWidthMultiplier) {
  return /// PINK THEME
    InkWell(
      onTap: (){

      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          border: Border.all(color: Colors.pink),
          /// Background Color
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[

            /// Header font color, label
            Container(
              decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8.0))
              ),
              height: 50,
              width: (maxWidth * cardWidthMultiplier) - 30,
              child: Row(
                children: <Widget>[
                  Container(width: 30,),
                  Text('Pink',
                    style: TextStyle(color: Colors.white, fontSize: 20,
                        fontWeight: FontWeight.bold),)
                ],
              ),
            ),

            Container(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ///Colored Circles
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange
                  ),
                ),
              ],
            ),
            Container(height: 10,)
          ],
        ),
      ),
    );
}