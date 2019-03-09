
Map<dynamic, dynamic> friends = {};

class FriendModel{

  int get friendCount => friends.length;
  Map get friendList => friends;


  void add(key, value){
    friends.addAll({key: value});
    print('Added friend to model: $key - $value');
  }

  void remove(key){
    friends.remove(key);
    print('Removed friend to model: $key');
  }

  void replace(uid, key, value){
    print('what is _friends[uid]: ${friends[uid]}');
    friends[uid].update(key, (dynamic val) => value);
    print('Replaced Info from friend to model: $key - $value');
    print('what is friends?: $friends');

  }

  void clear(){
    // clears friends for what ever reason
    friends.clear();
    print('Cleared friends model');
  }
}
