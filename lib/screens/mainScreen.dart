import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:rallyapp/model/stateModel.dart';

var stateModel = StateModel();

class MainScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return ScopedModel<StateModel>(
      model: StateModel(),
      child: ScopedModelDescendant<StateModel>(builder: (context, child, model) =>
       Scaffold(
        body: Center(
          child: Text('${model.currentIndex}'),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.group), title: Text('Friends')),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today), title: Text('Calendar')),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_view_day), title: Text('Events')),
          ],
          currentIndex: model.currentIndex,
          fixedColor: Colors.deepPurple,
          onTap: _setIndex,
        ),
      )),
    );
  }

  void _setIndex(int index) {
    print ('${stateModel.currentIndex}');
    print(index);
    stateModel.setPageIndex(index);
    print ('${stateModel.currentIndex}');
  }
}

