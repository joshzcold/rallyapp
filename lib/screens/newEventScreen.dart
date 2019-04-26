import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rallyapp/blocs/app/theme.dart';
import 'package:rallyapp/fireActions.dart';
import 'package:after_layout/after_layout.dart';
import 'package:rallyapp/widgets/durationPicker.dart';
import 'package:rallyapp/widgets/durationPicker.dart' as prefix0;
import 'package:rallyapp/widgets/timePicker.dart';

class NewEvent extends StatefulWidget {
  @override
  NewEventState createState() => NewEventState();
}
FireActions fireActions = new FireActions();

var colorFire = '#a21a1c';
var colorGrass = '#0d865a';
var colorAqua = '#007bff';
var colorMetal = '#474744';
var colorRegal = '#4b1769';
var colorLemon = '#a6a124';
var colorGround = '#703f17';
var colorAutumn = '#964500';

class NewEventState extends State<NewEvent>  with AfterLayoutMixin<NewEvent> {

  var colorSelection = colorAqua;

  final TextEditingController _gameTitleController = TextEditingController();
  final TextEditingController _partyLimitController = TextEditingController();
  static DateTime currentTime = DateTime.now();
  static DateTime twoHours = DateTime.now().add(Duration(hours: 2));

  var startTimeText = '$currentTime';
  var startTime = currentTime;

  var endTimeText = '$twoHours';
  var endTime = DateTime.now().add(Duration(hours: 2));

  var selectedDate;
  var selectedStartTime;
  var selectedDuration;

  Widget colorWheel = Container();
  Widget currentDataHandler = Container();

  @override
  Widget build(BuildContext context) {
    final _themeBloc = BlocProvider.of<ThemeBloc>(context);
    ThemeLoaded theme = _themeBloc.currentState;
    var maxWidth = MediaQuery.of(context).size.width;
    var maxHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: theme.theme['background'],
        appBar: AppBar(
          title: Text("New Event", style: TextStyle(color: Colors.white),),
          backgroundColor: Color(_getColorFromHex(colorSelection)),
          actions: <Widget>[
            FlatButton(
                onPressed: (){
                  fireActions.newEventToDatabase(
                      startTime.millisecondsSinceEpoch, endTime.millisecondsSinceEpoch,
                      colorSelection,
                      _partyLimitController.text,
                      _gameTitleController.text,
                      context
                  );
                  Navigator.pop(context);
                },
                padding: EdgeInsets.all(0),
                child: Row(
                  children: <Widget>[
                    Container(width: 10,),
                    Container(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.save, color: Colors.white,),
                            Container(width: 5,),
                            Text('Save', style: TextStyle(color: Colors.white, fontSize: 15),),
                          ],
                        )

                    ),
                  ],
                )
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Event Title',
                                style:
                                TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: theme.theme['textTitle'])),
                            Container(
                              width: maxWidth * .70,
                              child: TextFormField(
                                style: TextStyle(color: theme.theme['text']),
                                textAlign: TextAlign.start,
                                controller: _gameTitleController,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.videogame_asset, color: theme.theme['solidIconDark'],),
                                  hintStyle: TextStyle(color: theme.theme['text']),
                                  hintText: 'Playing Halo with some Bros, chilling.',
                                ),
                              ),
                            ),

                            Container(
                              height: 20,
                              width: 1,
                            ),

                            Text('Party Limit',
                                style:
                                TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: theme.theme['textTitle'])),
                            Container(
                              width: maxWidth * .20,
                              child: TextFormField(
                                style: TextStyle(color: theme.theme['text']),
                                textAlign: TextAlign.center,
                                controller: _partyLimitController,
                                decoration: new InputDecoration(
                                  icon: Icon(Icons.group, color: theme.theme['solidIconDark'],),
                                  hintStyle: TextStyle(color: theme.theme['text']),
                                  hintText: '0',
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            )
                          ],
                        ),

                        Row(
                          children: <Widget>[
                            Container(
                              width: maxWidth/1.5,
                            ),
                            FlatButton(
                                onPressed: (){
                                  _changeColorButton(maxHeight, maxWidth, theme);
                                },
                                padding: EdgeInsets.all(0),
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.brush, size: 30, color: theme.theme['solidIconDark'],),
                                    Container(width: 10,),
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: Color(_getColorFromHex(colorSelection)),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          ],
                        ),
                        Container(
                          height: 30,
                        ),
                      ],
                    ),
              ],
            ),
            AnimatedSwitcher(
                // the duration can be adjusted to expand the friend events
                // faster or slower.
                duration: Duration(milliseconds: 100),
                transitionBuilder:
                    (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: colorWheel,
              ),
            AnimatedSwitcher(
                // the duration can be adjusted to expand the friend events
                // faster or slower.
                duration: Duration(milliseconds: 100),
                transitionBuilder:
                    (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: currentDataHandler,
              ),
          ],
        )
        );
  }

  @override
  void afterFirstLayout(BuildContext context) async{
    // Calling the same function "after layout" to resolve the issue.
    var date = await getDateFromDatePicker();
    print('selectedDate = $date');
    setState(() {
      selectedDate = date;
      currentDataHandler = TimePicker( callback: switchToDurationFromTimePicker,);
    });

  }

  switchToDurationFromTimePicker(startTime, context){
    print('selectedStartTime = $startTime');
    setState(() {
      selectedStartTime = startTime;
      currentDataHandler = returnDurationPicker(context, closeDataHandlerCallBack);
    });
  }

  closeDataHandlerCallBack(duration, context){
    print('selectedDuration = $duration');
    setState(() {
      selectedDuration = duration;
      currentDataHandler = Container();
    });
  }

  getDateFromDatePicker() {
    Future<DateTime> selectedDate = showDatePicker(
      context: context,
      initialDate: startTime,
      firstDate:
      DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365 * 2)),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );
    return selectedDate;
  }

  getTimeFromTimePicker() {
    Future<DateTime> selectedDate = showDatePicker(
      context: context,
      initialDate: startTime,
      firstDate:
      DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365 * 2)),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );
    return selectedDate;
  }
  getDurationFromPicker() {
    Future<DateTime> selectedDate = showDatePicker(
      context: context,
      initialDate: startTime,
      firstDate:
      DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365 * 2)),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );
    return selectedDate;
  }

     _changeColorButton(maxHeight, maxWidth, theme){
    if(maxWidth > maxHeight){
      maxWidth = maxWidth/2;
    }
    var farDown = 50.0;
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
                      color: theme.theme['card'],
                      boxShadow: [
                        new BoxShadow(
                          color: theme.theme['shadow'],
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
                      setState(() {
                        colorSelection = colorAqua;
                        colorWheel = Container();
                      });
                    },
                    padding: EdgeInsets.all(0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(_getColorFromHex(colorAqua)),
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
                      setState(() {
                        colorSelection = colorAutumn;
                        colorWheel = Container();
                      });                    },
                    padding: EdgeInsets.all(0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(_getColorFromHex(colorAutumn)),
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
                      setState(() {
                        colorSelection = colorGrass;
                        colorWheel = Container();
                      });                    },
                    padding: EdgeInsets.all(0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(_getColorFromHex(colorGrass)),
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
                      setState(() {
                        colorSelection = colorGround;
                        colorWheel = Container();
                      });                    },
                    padding: EdgeInsets.all(0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(_getColorFromHex(colorGround)),
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
                      setState(() {
                        colorSelection = colorMetal;
                        colorWheel = Container();
                      });                    },
                    padding: EdgeInsets.all(0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(_getColorFromHex(colorMetal)),
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
                      setState(() {
                        colorSelection = colorLemon;
                        colorWheel = Container();
                      });                    },
                    padding: EdgeInsets.all(0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(_getColorFromHex(colorLemon)),
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
                      setState(() {
                        colorSelection = colorRegal;
                        colorWheel = Container();
                      });                    },
                    padding: EdgeInsets.all(0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(_getColorFromHex(colorRegal)),
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
                      setState(() {
                        colorSelection = colorFire;
                        colorWheel = Container();
                      });                    },
                    padding: EdgeInsets.all(0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(_getColorFromHex(colorFire)),
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

