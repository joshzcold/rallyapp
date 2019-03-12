import 'package:equatable/equatable.dart';

abstract class EventsState extends Equatable {
  EventsState([List props = const []]) : super(props);
}

class EventsLoading extends EventsState {
  @override
  String toString() => 'EventsLoading';
}

class EventsLoaded extends EventsState {
  final events;

  EventsLoaded([this.events = const []]) : super([events]);

  @override
  String toString() => 'EventsLoaded { events: $events }';
}

class EventsNotLoaded extends EventsState {
  @override
  String toString() => 'EventsNotLoaded';
}