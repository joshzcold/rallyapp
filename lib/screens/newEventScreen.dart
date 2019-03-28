import 'package:flutter/material.dart';

class NewEvent extends StatefulWidget {
  @override
  NewEventState createState() => NewEventState();
}

var colorFire = '#a21a1c';
var colorGrass = '#0d865a';
var colorAqua = '#007bff';
var colorMetal = '#474744';
var colorRegal = '#4b1769';
var colorLemon = '#a6a124';
var colorGround = '#703f17';
var colorAutumn = '#964500';

class NewEventState extends State<NewEvent> {

  final TextEditingController _gameTitleController = TextEditingController();
  final TextEditingController _partyLimitController = TextEditingController();
  static DateTime currentTime = DateTime.now();
  static DateTime twoHours = DateTime.now().add(Duration(hours: 2));

  var startTimeText = '${currentTime.month}/${currentTime.day} - '
      '${currentTime.hour}:${currentTime.minute}';
  var startTime = currentTime;

  var endTimeText = '${twoHours.month}/${twoHours.day} - '
      '${twoHours.hour}:${twoHours.minute}';
  var endTime = DateTime.now().add(Duration(hours: 2));
  Widget colorWheel = Container();
  var colorSelection;
  @override
  Widget build(BuildContext context) {
    var maxWidth = MediaQuery.of(context).size.width;
    var maxHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text("New Event"),
        ),
        body: Container(
          width: maxWidth,
          height: maxHeight,
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Start Time:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                      ),
                      FlatButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            DateTime date;
                            Future<DateTime> selectedDate = showDatePicker(
                              context: context,
                              initialDate: startTime,
                              firstDate:
                              DateTime.now().subtract(Duration(days: 365)),
                              lastDate: DateTime.now().add(Duration(days: 365 * 2)),
                              builder: (BuildContext context, Widget child) {
                                return Theme(
                                  data: ThemeData.light(),
                                  child: child,
                                );
                              },
                            ).then((pickedDate) {
                              date = new DateTime(pickedDate.year, pickedDate.month,
                                  pickedDate.day);
                              Future<TimeOfDay> selectedTime = showTimePicker(
                                initialTime: TimeOfDay(
                                    hour: startTime.hour, minute: startTime.minute),
                                context: context,
                                builder: (BuildContext context, Widget child) {
                                  return Theme(
                                    data: ThemeData.light(),
                                    child: child,
                                  );
                                },
                              ).then((pickedTime) {
                                var minutes =
                                    pickedTime.minute + pickedTime.hour * 60;
                                var selectedDateTimeValues =
                                date.add(Duration(minutes: minutes));
                                print('$selectedDateTimeValues');
                                setState(() {
                                  startTimeText =
                                  '${selectedDateTimeValues.month}/${selectedDateTimeValues.day} - '
                                      '${selectedDateTimeValues.hour}:${selectedDateTimeValues.minute}';
                                  startTime = selectedDateTimeValues;
                                });
                              });
                            });
                          },
                          child: Container(
                            height: 50,
                            width: maxWidth * .80,
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: Color(0xFFdadce0), width: 1),
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            ),
                            child: Text(
                              '$startTimeText',
                              style: TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          )),
                      Container(
                        height: 20,
                      ),
                      Text('End Time:',
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 35)),
                      FlatButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            DateTime date;
                            Future<DateTime> selectedDate = showDatePicker(
                              context: context,
                              initialDate: endTime,
                              firstDate:
                              DateTime.now().subtract(Duration(days: 365)),
                              lastDate: DateTime.now().add(Duration(days: 365 * 2)),
                              builder: (BuildContext context, Widget child) {
                                return Theme(
                                  data: ThemeData.light(),
                                  child: child,
                                );
                              },
                            ).then((pickedDate) {
                              date = new DateTime(pickedDate.year, pickedDate.month,
                                  pickedDate.day);
                              Future<TimeOfDay> selectedTime = showTimePicker(
                                initialTime: TimeOfDay(
                                    hour: endTime.hour, minute: endTime.minute),
                                context: context,
                                builder: (BuildContext context, Widget child) {
                                  return Theme(
                                    data: ThemeData.light(),
                                    child: child,
                                  );
                                },
                              ).then((pickedTime) {
                                var minutes =
                                    pickedTime.minute + pickedTime.hour * 60;
                                var selectedDateTimeValues =
                                date.add(Duration(minutes: minutes));
                                print('$selectedDateTimeValues');
                                setState(() {
                                  endTimeText =
                                  '${selectedDateTimeValues.month}/${selectedDateTimeValues.day} - '
                                      '${selectedDateTimeValues.hour}:${selectedDateTimeValues.minute}';
                                  endTime = selectedDateTimeValues;
                                });
                              });
                            });
                          },
                          child: Container(
                            height: 50,
                            width: maxWidth * .80,
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: Color(0xFFdadce0), width: 1),
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            ),
                            child: Text(
                              '$endTimeText',
                              style: TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          )),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Game Title & Description',
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 35)),
                      Container(
                        width: maxWidth * .70,
                        child: TextField(
                          controller: _gameTitleController,
                          decoration: InputDecoration(
                            icon: Icon(Icons.videogame_asset),
                            hintText: 'Playing Halo with some Bros, chilling.',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Party Limit',
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 35)),
                      Container(
                        width: maxWidth * .20,
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: _partyLimitController,
                          decoration: new InputDecoration(
                            icon: Icon(Icons.group),
                            hintText: '0',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text('Color', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35)),
                      FlatButton(
                        onPressed: (){
                          _changeColorButton(maxHeight, maxWidth);
                        },
                        padding: EdgeInsets.all(0),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),

                    ],
                  )
                ],
              ),
              Positioned(
                child: AnimatedSwitcher(
                  // the duration can be adjusted to expand the friend events
                  // faster or slower.
                  duration: Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return SizeTransition(
                      sizeFactor: animation,
                      child: child,
                    );
                  },
                  child: colorWheel,
                ),
              )
            ],
          )
        ));
  }

     _changeColorButton(maxHeight, maxWidth){
    var farDown = maxHeight/4;
    var circleSize = maxWidth *.80;
    var colorSize = 50.0;
    var circleMargins = maxWidth *.10;
    var leftCenterOfCircle =(circleMargins + circleSize/2) - colorSize/2;
    var downCenterOfCircle = (circleSize/2 + farDown) - colorSize/2;
    var padding = 30;
    var cornerPadding = padding/2;
    setState(() {
      colorWheel = FlatButton(
        padding: EdgeInsets.all(0),
          onPressed: (){
            setState(() {
              colorWheel = Container();
            });
          },
          child: Container(
            height: maxHeight,
            width: maxWidth,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: farDown,
                  left: (maxWidth - maxWidth*.80)/2,
                  child: Container(
                    width: circleSize,
                    height: circleSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.grey[500],
                          blurRadius: 5.0,
                          offset: Offset(0.0, 0.0),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  height: colorSize,
                  width: colorSize,
                  top: farDown + padding,
                  left: leftCenterOfCircle,
                  child: FlatButton(
                    onPressed: (){
                      _changeColorButton(maxHeight, maxWidth);
                    },
                    padding: EdgeInsets.all(0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  height: colorSize,
                  width: colorSize,
                  top: ((farDown + circleSize)- colorSize) - padding,
                  left: leftCenterOfCircle,
                  child: FlatButton(
                    onPressed: (){
                      _changeColorButton(maxHeight, maxWidth);
                    },
                    padding: EdgeInsets.all(0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  height: colorSize,
                  width: colorSize,
                  top: downCenterOfCircle,
                  left: circleMargins + padding,
                  child: FlatButton(
                    onPressed: (){
                      _changeColorButton(maxHeight, maxWidth);
                    },
                    padding: EdgeInsets.all(0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  height: colorSize,
                  width: colorSize,
                  top: downCenterOfCircle,
                  right: circleMargins + padding,
                  child: FlatButton(
                    onPressed: (){
                      _changeColorButton(maxHeight, maxWidth);
                    },
                    padding: EdgeInsets.all(0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  height: colorSize,
                  width: colorSize,
                  top: (((farDown + circleSize/6) - colorSize/2) + colorSize/4) + cornerPadding,
                  left: (((circleMargins + circleSize/6) - colorSize/2) + colorSize/4) + cornerPadding,
                  child: FlatButton(
                    onPressed: (){
                      _changeColorButton(maxHeight, maxWidth);
                    },
                    padding: EdgeInsets.all(0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.yellowAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  height: colorSize,
                  width: colorSize,
                  top: ((((farDown + circleSize) - colorSize) - circleSize/6) + colorSize/4) - cornerPadding,
                  left: (((circleMargins + circleSize/6) - colorSize/2) + colorSize/4) + cornerPadding,
                  child: FlatButton(
                    onPressed: (){
                      _changeColorButton(maxHeight, maxWidth);
                    },
                    padding: EdgeInsets.all(0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  height: colorSize,
                  width: colorSize,
                  top: ((((farDown + circleSize) - colorSize) - circleSize/6) + colorSize/4) - cornerPadding,
                  right: (((circleMargins + circleSize/6) - colorSize/2) + colorSize/4) + cornerPadding,
                  child: FlatButton(
                    onPressed: (){
                      _changeColorButton(maxHeight, maxWidth);
                    },
                    padding: EdgeInsets.all(0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.brown,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  height: colorSize,
                  width: colorSize,
                  top: (((farDown + circleSize/6) - colorSize/2) + colorSize/4) + cornerPadding,
                  right: (((circleMargins + circleSize/6) - colorSize/2) + colorSize/4) + cornerPadding,
                  child: FlatButton(
                    onPressed: (){
                      _changeColorButton(maxHeight, maxWidth);
                    },
                    padding: EdgeInsets.all(0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
         );
    });
  }

  int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

