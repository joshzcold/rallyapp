import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rallyapp/blocs/events/event.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState>{

  @override
  EventsState get initialState => EventsLoaded({});

  @override
  Stream<EventsState> mapEventToState(EventsState currentState, EventsEvent event) async*{
    if(event is AddEvents){
      yield* _mapAddEventsToState(currentState,event);
    } else if(event is RemoveEvents){
      yield* _mapRemoveEventsToState(currentState, event);
    } else if(event is ReplaceEventInfo){
      yield* _mapReplaceEventToState(currentState, event);
    } else if (event is RemoveAllEventsFromFriend){
      yield* _mapRemoveAllEventsFromFriends(currentState, event);
    }
  }

  Stream<EventsState>_mapAddEventsToState(currentState ,event) async*{
    final updatedEvents = Map.of(currentState.events);
    if(updatedEvents[event.uid] == null){
      updatedEvents[event.uid] = {};
    }
    updatedEvents[event.uid].addAll({event.key: event.value});
    yield EventsLoaded(updatedEvents);
  }

  Stream<EventsState>_mapRemoveEventsToState(currentState ,event) async*{
    final updatedEvents = Map.of(currentState.events);
    updatedEvents[event.uid].remove(event.key);
    yield EventsLoaded(updatedEvents);
  }

  Stream<EventsState>_mapRemoveAllEventsFromFriends(currentState ,event) async*{
    final updatedEvents = Map.of(currentState.events);
    updatedEvents.remove(event.uid);
    yield EventsLoaded(updatedEvents);
  }

  Stream<EventsState>_mapReplaceEventToState(currentState ,event) async*{
    final updatedEvents = Map.of(currentState.events);
    if(updatedEvents[event.uid] == null){updatedEvents[event.uid] = {};}
    updatedEvents[event.uid].remove(event.key);
    updatedEvents[event.uid].addAll({event.key: event.value});
    yield EventsLoaded(updatedEvents);
  }

}
