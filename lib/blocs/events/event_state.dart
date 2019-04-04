import 'package:equatable/equatable.dart';

abstract class EventsState extends Equatable {
  EventsState([List props = const []]) : super(props);
}


class EventsLoaded extends EventsState {
  final Map events;

  EventsLoaded(this.events) : super([events]);

  @override
  String toString() => 'EventsLoaded { events: $events }';
}
