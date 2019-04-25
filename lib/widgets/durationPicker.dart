import 'package:flutter/material.dart';

List duration = [
  '30','1','1.5','2','2.5','3','3.5','4','4.5','5','5.5','6','6.5','7','7.5','8','8.5','9',
];

List inc = [
  'min','hr','hrs','hrs','hrs','hrs','hrs','hrs','hrs','hrs','hrs','hrs','hrs','hrs','hrs','hrs','hrs','hrs',
];


returnDurationPicker(context, closeCallBack){
  return InkWell(
    child: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.5)),
      child:  Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width *.80,
          height: MediaQuery.of(context).size.height *.80,
          child: ListView.builder(
              itemCount: duration.length
              ,itemBuilder: (context, index){
            return InkWell(
              onTap: (){
                closeCallBack(duration[index],context);
              },
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.access_time),
                  title: Text(duration[index]),
                  trailing: Text(inc[index]),
                ),
              )
            );
          })
      ),
    ),
  );
}