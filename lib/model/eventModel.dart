import 'package:scoped_model/scoped_model.dart';

class EventModel extends Model{
  final _events = [];

  int get eventCount => _events.length;

  void add(key, value){
    _events[key].add(value);
    notifyListeners();
    print('Adding event to model: $key - $value');
  }

  void remove(key){
    _events[key].remove();
    notifyListeners();
    print('Added removing event $key');
  }

  void replace(key, value){
    // remove the specific event
    print('Replacing event details to model BEFORE: $key - $value');
    _events[key].remove(value);
    // replace it with new event
    _events[key].add(value);
    notifyListeners();
    print('Replacing event details to model AFTER: ${_events[key]}');

  }

  void clear(){
    // clears events for what ever reason
    _events.clear();
    notifyListeners();
  }
}