import 'package:bloc/bloc.dart';

enum CalendarIndexEvent {
  week,
  month,
  agenda,
  upcoming,
  friends,
  menu,
  settings,
}

class CalendarIndexBloc extends Bloc<CalendarIndexEvent, int> {
  @override
  int get initialState => 0;

  @override
  Stream<int> mapEventToState(int currentState, CalendarIndexEvent event) async* {
    switch (event) {
      case CalendarIndexEvent.week:
        yield currentState = 0;
        break;
      case CalendarIndexEvent.month:
        yield currentState = 1;
        break;
      case CalendarIndexEvent.agenda:
        yield currentState = 2;
        break;
      case CalendarIndexEvent.upcoming:
        yield currentState = 3;
        break;
      case CalendarIndexEvent.friends:
        yield currentState = 4;
        break;
      case CalendarIndexEvent.menu:
        yield currentState = 5;
        break;
      case CalendarIndexEvent.settings:
        yield currentState = 6;
        break;
    }
  }
}