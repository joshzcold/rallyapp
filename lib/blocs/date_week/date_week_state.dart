import 'package:equatable/equatable.dart';

abstract class DateWeekState extends Equatable{
  DateWeekState([List props = const []]) : super(props);
}

class Week extends DateWeekState{
  final week;

  Week([this.week = const[]]) : super([week]);

  @override
  String toString() => 'Week{ week:$week }';
}
