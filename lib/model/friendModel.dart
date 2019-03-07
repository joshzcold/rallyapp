import 'package:scoped_model/scoped_model.dart';

class FriendModel extends Model{
  final _friends = [];

  int get friendCount => _friends.length;

  void add(key, value){
    _friends[key].add(value);
    notifyListeners();
    print('Added friend to model: $key - $value');
  }

  void remove(key){
    _friends[key].remove();
    notifyListeners();
    print('Removed friend to model: $key');
  }

  void replace(key, value){
    // remove the specific friend
    _friends[key].remove(value);
    // replace it with new friend..
    // if they change their username for example
    _friends[key].add(value);
    notifyListeners();
    print('Replaced Info from friend to model: $key - $value');

  }

  void clear(){
    // clears friends for what ever reason
    _friends.clear();
    notifyListeners();
    print('Cleared friends model');
  }
}