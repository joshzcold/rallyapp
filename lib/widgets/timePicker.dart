import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    _controller = ScrollController(initialScrollOffset: 0);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){

      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.5)),
        child:  Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.height *.60,
            height: MediaQuery.of(context).size.height *.60,
            child: Card(
                child: ListView.builder(
                    itemCount: time.length
                    ,itemBuilder: (context, index){
                  return SwipeButton(

                  );
                })
            )
        ),
      ),
    );
  }
}
