import "beastSimpleInfoModel.dart";

class BeastDetailInfoModel extends BeastSimpleInfoModel {
  int age;
  String description;
  bool like;

  BeastDetailInfoModel({int id, String imageName, String name, int age, String description, bool like})
    : super(id: id, imageName: imageName, name: name)
  {
    this.age = age;
    this.description = description;
    this.like = like;
  }
}