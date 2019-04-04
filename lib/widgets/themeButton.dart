import 'package:flutter/material.dart';

List header = [
  'Jun',
  '12',
  '13',
  '14',
  '15',
  '16',
  '17',
  '18',
];
List rows = [1,2,3,4,5];

themeButton(context, constraints, getThemeSelectorModal){
  return Column(
    mainAxisSize: MainAxisSize.max,
    children: <Widget>[
      Container(height: 50,),
      Text('Theme', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
      Text(':Light:'),
      Container(height: 10,),
      InkWell(
        onTap: (){
          getThemeSelectorModal();
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
            color: Colors.white,
          ),
          height: 300,
          width: constraints.maxWidth * .90,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              /// TOP HEADER IN THEME BUTTON
              Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
                        color: Colors.white,
                      ),
                      height: 50,
                      width: constraints.maxWidth * .90,
                      child: Row(
                          children: header.map<Widget>((column)=>
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                        color: Color(0xFFdadce0),
                                        width: 1),
                                    bottom: BorderSide(
                                        color: Color(0xFFdadce0),
                                        width: 1),),
                                ),
                                height: 50,
                                width: (constraints.maxWidth *.90)/8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:calculateDayStyle(column),
                                ),
                              )
                          ).toList()
                      ),
                    )
                  ]
              ),
              /// GRID IN THEME BUTTON
              Stack(
                children: <Widget>[
                  Row(
                      children: <Widget>[
                        Container(
                          height: 200,
                          width: constraints.maxWidth *.90,
                          child: Stack(
                            children: <Widget>[
                              Row(
                                  children: header
                                      .map((columns) =>
                                      Expanded(
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      right: BorderSide(
                                                          color: Color(0xFFdadce0),
                                                          width: 1))),
                                              child: Column(
                                                  children: rows
                                                      .map((hour) =>
                                                      Expanded(
                                                          child: Container(
                                                              decoration: BoxDecoration(
                                                                  border: Border(
                                                                      bottom: BorderSide(
                                                                          color: Color(
                                                                              0xFFdadce0),
                                                                          width: 1))),
                                                              child: Row(
                                                                children: <Widget>[
                                                                  Container()
                                                                ],
                                                              ))))
                                                      .toList()))))
                                      .toList()),
                            ],
                          ),
                        )
                      ]
                  ),
                  /// ADD EVENT BUTTON
                  Positioned(
                      right: 10,
                      bottom: 10,
                      child:
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                            boxShadow: [
                              new BoxShadow(
                                color: Colors.grey[500],
                                blurRadius: 2.0,
                                offset: Offset(0.5, 0.0),
                              )
                            ]
                        ),
                        child: Center(
                          child: Icon(Icons.add, color: Colors.white,),
                        ),
                      )
                  )
                ],
              ),

              /// BOTTOM NAVIGATION IN THEME BUTTON
              Container(
                height: 50,
                width: constraints.maxWidth*.90,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: (constraints.maxWidth*.90)/2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.calendar_today, color: Colors.grey,),
                          Text('Calendar', style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),)
                        ],
                      ),
                    ),
                    Container(
                        width: (constraints.maxWidth*.90)/2,
                        child: LayoutBuilder(builder: (context, constraints){
                          return Stack(
                            children: <Widget>[
                              Center(
                                child: Column(
                                  children: <Widget>[
                                    Icon(Icons.group, color: Colors.blue,),
                                    Text('Friends', style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                ),
                              ),
                              Positioned(
                                  top: 5,
                                  left: constraints.maxWidth/2 + 5,
                                  child: Container(
                                      height: 15,
                                      width: 15,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.green
                                      ),
                                      child: Center(
                                        child:Text('3', style:
                                        TextStyle(color: Colors.white, fontSize: 14),),
                                      )
                                  ))
                            ],
                          );
                        })

                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      )
    ],
  );
}

List<Widget> calculateDayStyle(column) {
  if(column == '16'){
    return [
      Text('$column', style: TextStyle(color: Colors.blue),),
      Text('T', style: TextStyle(color: Colors.blue, fontSize: 8),),
    ];
  }
  else if(column == '12'){
    return [
      Text('$column', style: TextStyle(color: Colors.grey),),
      Text('S', style: TextStyle(color: Colors.grey, fontSize: 8),),
    ];
  }
  else if(column == '13'){
    return [
      Text('$column', style: TextStyle(color: Colors.grey),),
      Text('M', style: TextStyle(color: Colors.grey, fontSize: 8),),
    ];
  }
  else if(column == '14'){
    return [
      Text('$column', style: TextStyle(color: Colors.grey),),
      Text('T', style: TextStyle(color: Colors.grey, fontSize: 8),),
    ];
  }
  else if(column == '15'){
    return [
      Text('$column', style: TextStyle(color: Colors.grey),),
      Text('W', style: TextStyle(color: Colors.grey, fontSize: 8),),
    ];
  }
  else if(column == '17'){
    return [
      Text('$column', style: TextStyle(color: Colors.grey),),
      Text('F', style: TextStyle(color: Colors.grey, fontSize: 8),),
    ];
  }
  else if(column == '18'){
    return [
      Text('$column', style: TextStyle(color: Colors.grey),),
      Text('S', style: TextStyle(color: Colors.grey, fontSize: 8),),
    ];
  } else {
    return [
      Text('$column', style: TextStyle(color: Colors.grey),),
    ];
  }

}