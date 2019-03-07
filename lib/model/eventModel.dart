import 'package:scoped_model/scoped_model.dart';

class EventModel extends Model{
  final _events = [];

  int get eventCount => _events.length;

  void add(events){
    _events.add(events);
    notifyListeners();
  }

  void remove(key){
    _events.remove(key);
    notifyListeners();
  }

  void replace(key, event){
    // remove the specific event
    _events.remove(key);
    // replace it with new event
    _events.add(event);
    notifyListeners();
  }

  void clear(){
    // clears events for what ever reason
    _events.clear();
    notifyListeners();
  }
}