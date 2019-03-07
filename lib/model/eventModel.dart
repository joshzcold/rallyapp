import 'package:scoped_model/scoped_model.dart';

class EventModel extends Model{
  Map<dynamic, dynamic> _events = {};

  int get eventCount => _events.length;

  void add(key, value){
    _events.addAll({key:value});
    print('Adding event to model: $key - $value');
    notifyListeners();
  }

  void remove(key){
    _events.remove(key);
    notifyListeners();
    print('Removing event $key');
    notifyListeners();
  }

  void replace(key, value) {
    // remove the specific event
    _events.update(key, (dynamic val) => value);
    print('Replacing event details to model: $key - $value');
    notifyListeners();
  }

  void clear(){
    // clears events for what ever reason
    _events.clear();
    notifyListeners();
  }
}