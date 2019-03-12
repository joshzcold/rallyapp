import 'package:bloc/bloc.dart';

enum NavigationEvent {
  friends,
  calendar,
}

class NavigationBloc extends Bloc<NavigationEvent, int> {
  @override
  int get initialState => 1;

  @override
  Stream<int> mapEventToState(int currentState, NavigationEvent event) async* {
    switch (event) {
      case NavigationEvent.friends:
        yield currentState = 0;
        break;
      case NavigationEvent.calendar:
        yield currentState = 1;
        break;
    }
  }
}