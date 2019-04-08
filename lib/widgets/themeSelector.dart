import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rallyapp/blocs/app/theme.dart';
import 'package:rallyapp/blocs/app/theme.dart';

themeSelector(context, closeThemeSelectorModal){
  ThemeBloc _themeBloc = BlocProvider.of<ThemeBloc>(context);
  ThemeLoaded theme  = _themeBloc.currentState;
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
              child: ListView(
                children: <Widget>[
                  /// THE CARDS INSIDE THE CARD
                  Container(height: 20,),
                  lightThemeCard(maxWidth, cardWidthMultiplier, _themeBloc, closeThemeSelectorModal),
                  Container(height: 10,),
                  darkThemeCard(maxWidth, cardWidthMultiplier, _themeBloc, closeThemeSelectorModal),
                  Container(height: 10,),
                  darkBlueThemeCard(maxWidth, cardWidthMultiplier, _themeBloc, closeThemeSelectorModal),
                  Container(height: 10,),
                  amoLEDThemeCard(maxWidth, cardWidthMultiplier, _themeBloc, closeThemeSelectorModal),
                  Container(height: 10,),
                  blueThemeCard(maxWidth, cardWidthMultiplier, _themeBloc, closeThemeSelectorModal),
                  Container(height: 10,),
                  redThemeCard(maxWidth, cardWidthMultiplier, _themeBloc, closeThemeSelectorModal),
                  Container(height: 10,),
                  greenThemeCard(maxWidth, cardWidthMultiplier, _themeBloc, closeThemeSelectorModal),
                  Container(height: 10,),
                  pinkThemeCard(maxWidth, cardWidthMultiplier, _themeBloc, closeThemeSelectorModal),
                  Container(height: 20,),
                ],
              ),
            )
        ),
      ),
    );
  });
}

lightThemeCard(maxWidth, cardWidthMultiplier, ThemeBloc _themeBloc, closeThemeSelectorModal) {
  return /// LIGHT THEME
    InkWell(
      onTap: (){
        _themeBloc.dispatch(ChangeTheme("light"));
        closeThemeSelectorModal();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          /// Background Color
          color: lightTheme['background'],
          border: Border.all(color: lightTheme['border'])
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[

            /// Header font color, label
            Container(
              decoration: BoxDecoration(
                  color: lightTheme['header'],
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8.0))
              ),
              height: 50,
              width: (maxWidth * cardWidthMultiplier) - 30,
              child: Row(
                children: <Widget>[
                  Container(width: 30,),
                  Text('Light',
                    style: TextStyle(color: lightTheme['headerText'], fontSize: 20,
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
                      color: lightTheme['colorPrimary']
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: lightTheme['colorSecondary']
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: lightTheme['colorSuccess']
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: lightTheme['colorAttention']
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

darkThemeCard(maxWidth, cardWidthMultiplier, _themeBloc, closeThemeSelectorModal) {
  return /// DARK THEME
    InkWell(
      onTap: (){
        _themeBloc.dispatch(ChangeTheme("dark"));
        closeThemeSelectorModal();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          border: Border.all(color: darkTheme['header']),
          /// Background Color
          color: darkTheme['background'],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[

            /// Header font color, label
            Container(
              decoration: BoxDecoration(
                  color: darkTheme['header'],
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8.0))
              ),
              height: 50,
              width: (maxWidth * cardWidthMultiplier) - 30,
              child: Row(
                children: <Widget>[
                  Container(width: 30,),
                  Text('Dark',
                    style: TextStyle(color: darkTheme['headerText'], fontSize: 20,
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
                      color: darkTheme['colorPrimary']
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: darkTheme['colorSecondary']
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: darkTheme['colorSuccess']
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: darkTheme['colorAttention']
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

darkBlueThemeCard(double maxWidth, double cardWidthMultiplier, ThemeBloc themeBloc, closeThemeSelectorModal) {
  return /// DARK BLUE THEME
    InkWell(
      onTap: (){
        themeBloc.dispatch(ChangeTheme("darkBlue"));
        closeThemeSelectorModal();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          border: Border.all(color: darkBlueTheme['header']),
          /// Background Color
          color: darkBlueTheme['background'],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[

            /// Header font color, label
            Container(
              decoration: BoxDecoration(
                  color: darkBlueTheme['header'],
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8.0))
              ),
              height: 50,
              width: (maxWidth * cardWidthMultiplier) - 30,
              child: Row(
                children: <Widget>[
                  Container(width: 30,),
                  Text('Dark Blue',
                    style: TextStyle(color: darkBlueTheme['headerText'], fontSize: 20,
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
                      color: darkBlueTheme['colorPrimary']
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: darkBlueTheme['colorSecondary']
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: darkBlueTheme['colorSuccess']
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: darkBlueTheme['colorAttention']
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

amoLEDThemeCard(maxWidth, cardWidthMultiplier, _themeBloc, closeThemeSelectorModal) {
  return /// AmoLED THEME
    InkWell(
      onTap: (){
        _themeBloc.dispatch(ChangeTheme("amoled"));
        closeThemeSelectorModal();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          border: Border.all(color: amoLEDTheme['header']),
          /// Background Color
          color: amoLEDTheme['background'],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[

            /// Header font color, label
            Container(
              decoration: BoxDecoration(
                  color: amoLEDTheme['header'],
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8.0))
              ),
              height: 50,
              width: (maxWidth * cardWidthMultiplier) - 30,
              child: Row(
                children: <Widget>[
                  Container(width: 30,),
                  Text('AMOLED',
                    style: TextStyle(color: amoLEDTheme['headerText'], fontSize: 20,
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
                      color: amoLEDTheme['colorPrimary']
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: amoLEDTheme['colorSecondary']
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: amoLEDTheme['colorSuccess']
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: amoLEDTheme['colorAttention']
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

blueThemeCard(maxWidth, cardWidthMultiplier, _themeBloc, closeThemeSelectorModal) {
  return /// BLUE THEME
    InkWell(
      onTap: (){
        _themeBloc.dispatch(ChangeTheme("blue"));
        closeThemeSelectorModal();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          border: Border.all(color: blueTheme['header']),
          /// Background Color
          color: blueTheme['background'],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[

            /// Header font color, label
            Container(
              decoration: BoxDecoration(
                  color: blueTheme['header'],
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8.0))
              ),
              height: 50,
              width: (maxWidth * cardWidthMultiplier) - 30,
              child: Row(
                children: <Widget>[
                  Container(width: 30,),
                  Text('Blue',
                    style: TextStyle(color: blueTheme['headerText'], fontSize: 20,
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
                      color: blueTheme['colorPrimary']
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: blueTheme['colorSecondary']
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: blueTheme['colorSuccess']
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: blueTheme['colorAttention']
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

redThemeCard(maxWidth, cardWidthMultiplier, _themeBloc, closeThemeSelectorModal) {
  return /// RED THEME
    InkWell(
      onTap: (){
        _themeBloc.dispatch(ChangeTheme("red"));
        closeThemeSelectorModal();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          border: Border.all(color: redTheme['header']),
          /// Background Color
          color: redTheme['background'],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[

            /// Header font color, label
            Container(
              decoration: BoxDecoration(
                  color: redTheme['header'],
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8.0))
              ),
              height: 50,
              width: (maxWidth * cardWidthMultiplier) - 30,
              child: Row(
                children: <Widget>[
                  Container(width: 30,),
                  Text('Red',
                    style: TextStyle(color: redTheme['headerText'], fontSize: 20,
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
                      color: redTheme['colorPrimary']
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: redTheme['colorSecondary']
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: redTheme['colorSuccess']
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: redTheme['colorAttention']
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

greenThemeCard(maxWidth, cardWidthMultiplier, _themeBloc, closeThemeSelectorModal) {
  return /// GREEN THEME
    InkWell(
      onTap: (){
        _themeBloc.dispatch(ChangeTheme("green"));
        closeThemeSelectorModal();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          border: Border.all(color: greenTheme['header']),
          /// Background Color
          color: greenTheme['background'],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[

            /// Header font color, label
            Container(
              decoration: BoxDecoration(
                  color: greenTheme['header'],
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8.0))
              ),
              height: 50,
              width: (maxWidth * cardWidthMultiplier) - 30,
              child: Row(
                children: <Widget>[
                  Container(width: 30,),
                  Text('Green',
                    style: TextStyle(color: greenTheme['headerText'], fontSize: 20,
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
                      color: greenTheme['colorPrimary']
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: greenTheme['colorSecondary']
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: greenTheme['colorSuccess']
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: greenTheme['colorAttention']
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

pinkThemeCard(maxWidth, cardWidthMultiplier, _themeBloc, closeThemeSelectorModal) {
  return /// PINK THEME
    InkWell(
      onTap: (){
        _themeBloc.dispatch(ChangeTheme("pink"));
        closeThemeSelectorModal();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          border: Border.all(color: pinkTheme['header']),
          /// Background Color
          color: pinkTheme['background'],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[

            /// Header font color, label
            Container(
              decoration: BoxDecoration(
                  color: pinkTheme['header'],
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8.0))
              ),
              height: 50,
              width: (maxWidth * cardWidthMultiplier) - 30,
              child: Row(
                children: <Widget>[
                  Container(width: 30,),
                  Text('Pink',
                    style: TextStyle(color: pinkTheme['headerText'], fontSize: 20,
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
                      color: pinkTheme['colorPrimary']
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: pinkTheme['colorSecondary']
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: pinkTheme['colorSuccess']
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: pinkTheme['colorAttention']
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