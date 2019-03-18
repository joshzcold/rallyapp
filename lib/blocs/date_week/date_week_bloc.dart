import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rallyapp/blocs/date_week/date_week.dart';

class DateWeekBloc extends Bloc<DateWeekEvent, DateWeekState>{

  @override
  DateWeekState get initialState => Week();

  @override
  Stream<DateWeekState> mapEventToState(DateWeekState currentState, DateWeekEvent event) async*{
    if(event is NextWeek){
      yield* _mapShiftToNextWeekState(currentState,event);
    } else if(event is AddDayToWeek){
      yield* _mapAddDayToWeekState(currentState,event);
    }
  }

  Stream<DateWeekState> _mapShiftToNextWeekState(DateWeekState currentState, NextWeek event) async*{
    print('_mapShiftToNextWeekState: $event');
  }

  Stream<DateWeekState> _mapAddDayToWeekState(DateWeekState currentState, AddDayToWeek event) async*{
    print('_mapAddDayToWeekState: $event');
  }
}