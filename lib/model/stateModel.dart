
import 'package:scoped_model/scoped_model.dart';

var isLoading = false;
var pageIndex = 1;

class StateModel extends Model{

  int get currentIndex => pageIndex;

  Future<void> toggleLoading() async{
    isLoading = !isLoading;
    notifyListeners();
  }

  void setPageIndex(index){
    pageIndex = index;
    notifyListeners();
  }

}