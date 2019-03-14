import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:date_utils/date_utils.dart';

var currentHour = new DateTime.now().hour;

List<int> timeHour = [
  24,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23
];
List<int> days = [1,2,3,4,5,6,7];

class Week extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    print('$currentHour');
    return SingleChildScrollView(
      child:Table(
        children: timeHour.map((hour) => TableRow(
            children: days.map((day) => Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(width: 0.5, color: Colors.grey),
                  left: BorderSide(width: 0.5, color: Colors.grey),
                  right: BorderSide(width: 0.5, color: Colors.grey),
                  bottom: BorderSide(width: 0.5, color: Colors.grey),
                )
              ),
              height: 60,
              child: Center(
                child: Text('$hour'),
              ),
            )).toList()
        )).toList(),
      ),
    ) ;

  }
}