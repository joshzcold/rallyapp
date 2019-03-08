import 'package:scoped_model/scoped_model.dart';

Map<dynamic, dynamic> friends = {};

class FriendModel extends Model{

  int get friendCount => friends.length;
  Map get friendList => friends;

  void add(key, value){
    friends.addAll({key: value});
    notifyListeners();
    print('Added friend to model: $key - $value');
  }

  void remove(key){
    friends.remove(key);
    notifyListeners();
    print('Removed friend to model: $key');
  }

  void replace(uid, key, value){
    print('what is _friends[uid]: ${friends[uid]}');
    friends[uid].update(key, (dynamic val) => value);
    notifyListeners();
    print('Replaced Info from friend to model: $key - $value');
    print('what is friends?: $friends');

  }

  void clear(){
    // clears friends for what ever reason
    friends.clear();
    notifyListeners();
    print('Cleared friends model');
  }
}