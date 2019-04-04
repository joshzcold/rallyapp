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
                  Container(height: 20,),

                  /// THE CARDS INSIDE THE CARD

                  /// LIGHT THEME
                  InkWell(
                    onTap: (){

                    },
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
                        /// Background Color
                        color: Colors.white,
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
                  ),
                ],
              ),
            )
        ),
      ),
    );
  });
}