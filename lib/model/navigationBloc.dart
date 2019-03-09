import 'package:bloc/bloc.dart';

enum NavigationEvent {
  friends,
  calendar,
  somethingElse
}

class NavigationBloc extends Bloc<NavigationEvent, int> {
  @override
  int get initialState => 0;

  @override
  Stream<int> mapEventToState(int currentState, NavigationEvent event) async* {
    switch (event) {
      case NavigationEvent.friends:
        yield currentState = 0;
        break;
      case NavigationEvent.calendar:
        yield currentState = 1;
        break;
      case NavigationEvent.somethingElse:
        yield currentState = 2;
        break;
    }
  }
}