import "package:sqflite/sqflite.dart";
import "dbFactory.dart";
import "../dbModels/myBeastDbModel.dart";
import "../models/myBeastDetailInfoModel.dart";

class MyBeastWriter{
  static Future<int> insertMyBeast(MyBeastDetailInfoModel myBeast) async {
    final Database db = await getDatabase();

    MyBeastDbModel myBeastDbModel = MyBeastDbModel(
      id: myBeast.id,
      image: myBeast.image,
      name: myBeast.name,
      age: myBeast.age,
      description: myBeast.description
    );

    return await db.insert(
      "MyBeasts",
      myBeastDbModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> updateMyBeast(MyBeastDetailInfoModel myBeast) async {
    final db = await getDatabase();

    MyBeastDbModel myBeastDbModel = MyBeastDbModel(
      id: myBeast.id,
      image: myBeast.image,
      name: myBeast.name,
      age: myBeast.age,
      description: myBeast.description
    );

    await db.update(
      "MyBeasts",
      myBeastDbModel.toMap(),
      where: "id = ?",
      whereArgs: [myBeastDbModel.id],
    );
  }

  static Future<void> deleteMyBeast(int id) async {
    final db = await getDatabase();

    await db.delete(
      "Events",
      where: "beastId = ? AND type = ?",
      whereArgs: [id, "Regular"],
    );

    await db.delete(
      "MyBeasts",
      where: "id = ?",
      whereArgs: [id],
    );
  }
}