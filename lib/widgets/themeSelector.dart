import 'package:flutter/material.dart';

themeSelector(context, closeThemeSelectorModal){
  return LayoutBuilder(builder: (context, constraints){
    var maxHeight = constraints.maxHeight;
    var maxWidth = constraints.maxWidth;
    var cardHeightMultiplier = 0.35;
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
            height: 300,
            width: maxWidth * cardWidthMultiplier,
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[

                ],
              ),
            )
        ),
      ),
    );
  });
}