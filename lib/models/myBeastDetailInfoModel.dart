import "myBeastSimpleInfoModel.dart";

class MyBeastDetailInfoModel extends MyBeastSimpleInfoModel {
  int age;

  MyBeastDetailInfoModel({int id, String image, String name, int age, String description})
    : super(id: id, image: image, name: name, description: description)
  {
    this.age = age;
  }
}