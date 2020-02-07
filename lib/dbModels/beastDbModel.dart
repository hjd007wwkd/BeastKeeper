class BeastDbModel {
  final int id;
  final String imageName;
  final String name;
  final int age;
  final String description;
  final int like;

  BeastDbModel({this.id, this.imageName, this.name, this.age, this.description, this.like});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "imageName": imageName,
      "name": name,
      "age": age,
      "description": description,
      "like": like
    };
  }
}