import 'package:equatable/equatable.dart';
import 'package:date_utils/date_utils.dart';

abstract class DateWeekState extends Equatable{
  DateWeekState([List props = const []]) : super(props);
}

class Week extends DateWeekState{
  final week;

  Week([this.week = const[]]) : super([week]);

  @override
  String toString() => 'Week{ week:$week }';
}

class TodayWeek extends DateWeekState{
  final week;

  TodayWeek([this.week = const[]]) : super([week]);

  @override
  String toString() => 'TodayWeek{ week:$week }';
}
