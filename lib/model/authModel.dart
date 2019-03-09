
var userRally ={};

class AuthModel{

  void setUser(user){
    userRally = user;
    print('user has been set to $userRally');
  }

  void clearUser(){
    userRally.clear();
    print('user has been cleared');
  }

  void replaceValue(key, value){
    userRally.update(key, (dynamic val) => value);
    print('change this info in user: $key : $value');
    print('what is user? : $userRally');
  }
}