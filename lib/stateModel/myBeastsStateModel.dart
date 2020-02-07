import "package:flutter/material.dart";
import "../dbActions/myBeastReader.dart";
import "../models/myBeastSimpleInfoModel.dart";

class MyBeastsStateModel with ChangeNotifier {
  List<MyBeastSimpleInfoModel> myBeastsSimpleInfo = List<MyBeastSimpleInfoModel>();
  
  MyBeastsStateModel(){
    MyBeastReader.getMyBeastsSimpleInfo().then((value){
      myBeastsSimpleInfo = value;
      notifyListeners();
    });
  }

  void addMyBeastSimpleInfo(MyBeastSimpleInfoModel myBeastSimpleInfo){
    myBeastsSimpleInfo.add(myBeastSimpleInfo);
    notifyListeners();
  }

  void updateMyBeastSimpleInfo(MyBeastSimpleInfoModel myBeastSimpleInfo){
    int index = myBeastsSimpleInfo.indexWhere((myBeast) => myBeast.id == myBeastSimpleInfo.id);

    myBeastsSimpleInfo[index] = myBeastSimpleInfo;
    notifyListeners();
  }

  void deleteMyBeastSimpleInfo(id){
    int index = myBeastsSimpleInfo.indexWhere((myBeast) => myBeast.id == id);
    myBeastsSimpleInfo.removeAt(index);
    notifyListeners();
  }
}