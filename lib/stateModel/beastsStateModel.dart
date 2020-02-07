import "package:flutter/material.dart";
import "../dbActions/beastReader.dart";
import "../models/beastSimpleInfoModel.dart";

class BeastsStateModel with ChangeNotifier {
  List<BeastSimpleInfoModel> beastsSimpleInfo = List<BeastSimpleInfoModel>();
  
  BeastsStateModel(){
    BeastReader.getBeastsSimpleInfo().then((value){
      beastsSimpleInfo = value;
      notifyListeners();
    });
  }
}