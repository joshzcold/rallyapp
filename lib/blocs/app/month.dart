import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class MonthBloc extends Bloc<MonthEvent, MonthState>{

  @override
  MonthState get initialState => Month(DateTime.now().month);

  @override
  Stream<MonthState> mapEventToState(MonthState currentState, MonthEvent event) async*{
    if(event is ChangeMonth){
      yield* _mapChangeMonthToState(currentState,event);
    }
  }

  Stream<MonthState>_mapChangeMonthToState(currentState ,event) async*{
    yield Month(event.month);
  }

}


abstract class MonthEvent extends Equatable{
  MonthEvent([List props = const []]) : super(props);
}

class ChangeMonth extends MonthEvent{
  int month;


  ChangeMonth(this.month) : super([month]);

  @override
  String toString() => 'MonthEvent { month: $month}';
}



abstract class MonthState extends Equatable {
  MonthState([List props = const []]) : super(props);
}

class Month extends MonthState {
  final month;

  Month([this.month = const []]) : super([month]);
  @override
  String toString() => 'Month{month: $month}';
}
