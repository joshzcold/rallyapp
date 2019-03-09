
class EventModel{
  Map<dynamic, dynamic> _events = {};

  int get eventCount => _events.length;

  void add(key, value){
    _events.addAll({key:value});
    print('Adding event to model: $key - $value');
  }

  void remove(key){
    _events.remove(key);
    print('Removing event $key');
  }

  void replace(key, value) {
    // remove the specific event
    _events.update(key, (dynamic val) => value);
    print('Replacing event details to model: $key - $value');
  }

  void clear(){
    // clears events for what ever reason
    _events.clear();
  }
}