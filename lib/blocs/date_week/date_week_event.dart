import 'package:equatable/equatable.dart';

abstract class DateWeekEvent extends Equatable{
  DateWeekEvent([List props = const []]) : super(props);
}

class AddDayToWeek extends DateWeekEvent{
  final List<dynamic> weekRange;

  AddDayToWeek(this.weekRange): super([weekRange]);
}

class NextWeek extends DateWeekEvent{
  final List<dynamic> weekRange;

  NextWeek(this.weekRange): super([weekRange]);
}