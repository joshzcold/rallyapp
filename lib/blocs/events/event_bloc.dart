import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rallyapp/blocs/events/event.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState>{

  @override
  EventsState get initialState => EventsLoading();

  @override
  Stream<EventsState> mapEventToState(EventsState currentState, EventsEvent event) async*{
    if(event is AddEvents){
      yield* _mapAddEventsToState(currentState,event);
    } else if(event is RemoveEvents){
      yield* _mapRemoveEventsToState(currentState, event);
    } else if(event is ReplaceEventInfo){
      yield* _mapReplaceFriendDetailToState(currentState, event);
    } else if(event is ClearEvents){
      yield* _mapClearEventsToState(currentState);
    }
  }

  Stream<EventsState>_mapAddEventsToState(currentState ,event) async*{
    if(currentState is EventsLoading){
      currentState = {};
      currentState[event.uid] = {};
    } else if(currentState is EventsLoaded){
      currentState = currentState.events;
      if(currentState[event.uid] == null){
        currentState[event.uid] = {};
      }
    }
    final updatedEvents = Map.of(currentState);
    updatedEvents[event.uid].addAll({event.key: event.value});
    yield EventsLoaded(updatedEvents);
  }

  Stream<EventsState>_mapRemoveEventsToState(currentState ,event) async*{
    if(currentState is EventsLoading){
      currentState = {};
    } else if(currentState is EventsLoaded){
      currentState = currentState.events;
    }
    final updatedEvents = Map.of(currentState);
    updatedEvents[event.uid].remove(event.key);
    yield EventsLoaded(updatedEvents);
  }

  Stream<EventsState>_mapReplaceFriendDetailToState(currentState ,event) async*{
    if(currentState is EventsLoading){
      currentState = {};
    } else if(currentState is EventsLoaded){
      currentState = currentState.events;
    }
    final updatedEvents = Map.of(currentState);
    updatedEvents[event.uid].update(event.key, (dynamic val) => event.value);
    yield EventsLoaded(updatedEvents);
  }

  Stream<EventsState>_mapClearEventsToState(currentState) async*{
    currentState = {};
    yield EventsLoading();
  }
}
