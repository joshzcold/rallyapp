import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rallyapp/blocs/app/theme.dart';
import 'package:rallyapp/widgets/durationPicker.dart';
import 'package:rallyapp/widgets/swipButton.dart';

List time = [
  '12','1','2','3','4','5','6','7','8','9','10','11',
  '12','1','2','3','4','5','6','7','8','9','10','11',
];

List amPm = [
  'AM','AM','AM','AM','AM','AM','AM','AM','AM','AM','AM','AM',
  'PM','PM','PM','PM','PM','PM','PM','PM','PM','PM','PM','PM',
];

List timeInc = [
  ':00',':15',':30',':45',
];

class TimePicker extends StatefulWidget{
  const TimePicker({
    this.callback
  });

  final callback;


  @override
  TimePickerState createState() => TimePickerState();
}

class TimePickerState extends State<TimePicker>{
  ScrollController _controller;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final _themeBloc = BlocProvider.of<ThemeBloc>(context);
    ThemeLoaded theme = _themeBloc.currentState;

    _controller = ScrollController(initialScrollOffset: calculateInitialScrollDownByCurrentTime(60.0 * 24));

    return InkWell(
      onTap: (){
        Navigator.pop(context);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.5)),
        child:  Container(
            width: MediaQuery.of(context).size.width *.80,
            height: MediaQuery.of(context).size.height *.80,
            child: Card(
              color: theme.theme['background'],
                child: ListView.builder(
                  controller: _controller,
                    itemCount: time.length
                    ,itemBuilder: (context, index){
                  return SwipeButton(
                    height: 60.0,
                    leftContent: Card(
                      color: theme.theme['card'],
                      child: ListTile(
                        title: Text(time[index], style: TextStyle(fontSize: 20, color: theme.theme['text']),),
                        trailing: Text(amPm[index], style: TextStyle(fontSize: 14, color: theme.theme['text']),),
                      )
                    ),
                    rightContent: Card(
                      color: theme.theme['card'],
                      child: ListTile(
                        leading: Icon(Icons.timelapse, size: 25, color: theme.theme['solidIconDark'],),
                          title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: timeInc.map<Widget>((item){
                                return InkWell(
                                  onTap: (){
                                    widget.callback(time[index]+item+amPm[index], context);
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(color: theme.theme['colorPrimary'], borderRadius: BorderRadius.all(Radius.circular(8))),
                                      padding: EdgeInsets.all(10.0),
                                      child: Text(item, style: TextStyle(color: Colors.white),)
                                  ),
                                );
                              }).toList()
                          )
                      ),
                    )
                  );
                })
            )
        ),
      ),
    );
  }
}


double calculateInitialScrollDownByCurrentTime(constraints) {
  var sTime = DateTime.now();
  double height = constraints;
  double hour = height / 24;
  var hoursFromMidnight = (sTime.hour * 60 + sTime.minute) / 60;
  double distanceDown = hoursFromMidnight * hour;
  return distanceDown;
}