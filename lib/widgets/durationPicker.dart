import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rallyapp/blocs/app/theme.dart';

List duration = [
  '30','1','1.5','2','2.5','3','3.5','4','4.5','5','5.5','6','6.5','7','7.5','8','8.5','9',
];

List inc = [
  'min','hr','hrs','hrs','hrs','hrs','hrs','hrs','hrs','hrs','hrs','hrs','hrs','hrs','hrs','hrs','hrs','hrs',
];

class DurationPicker extends StatefulWidget{
  const DurationPicker({
    this.callback
  });

  final callback;

  @override
  DurationPickerState createState() => DurationPickerState();
}

class DurationPickerState extends State<DurationPicker>{


  @override
  Widget build(BuildContext context) {
    final _themeBloc = BlocProvider.of<ThemeBloc>(context);
    ThemeLoaded theme = _themeBloc.currentState;

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
            color: theme.theme['background'],
            width: MediaQuery.of(context).size.width *.80,
            height: MediaQuery.of(context).size.height *.80,
            child: ListView.builder(
                itemCount: duration.length
                ,itemBuilder: (context, index){
              return InkWell(
                  onTap: (){
                    widget.callback(duration[index],inc[index],context);
                  },
                  child: Card(
                    color: theme.theme['card'],
                    child: ListTile(
                      leading: Icon(Icons.access_time, color: theme.theme['solidIconDark'],),
                      title: Text(duration[index], style: TextStyle(color: theme.theme['text']),),
                      trailing: Text(inc[index], style: TextStyle(color: theme.theme['text']),),
                    ),
                  )
              );
            })
        ),
      ),
    );
  }
}
