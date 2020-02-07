class MyBeastDbModel {
  final int id;
  final String image;
  final String name;
  final int age;
  final String description;

  MyBeastDbModel({this.id, this.image, this.name, this.age, this.description});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "image": image,
      "name": name,
      "age": age,
      "description": description,
    };
  }
}