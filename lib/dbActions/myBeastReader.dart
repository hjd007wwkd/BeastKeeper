import "package:sqflite/sqflite.dart";
import "dbFactory.dart";
import "../models/myBeastSimpleInfoModel.dart";
import "../models/myBeastDetailInfoModel.dart";

class MyBeastReader{
  static Future<List<MyBeastSimpleInfoModel>> getMyBeastsSimpleInfo() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query("myBeasts");

    return List.generate(maps.length, (i) {
      return MyBeastSimpleInfoModel(
        id: maps[i]["id"],
        image: maps[i]["image"],
        name: maps[i]["name"],
        description: maps[i]["description"]
      );
    });
  }

  static Future<MyBeastDetailInfoModel> getMyBeastDetailInfo(int id) async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      "myBeasts", 
      where: "id = ?",
      whereArgs: [id],
    );

    return MyBeastDetailInfoModel(
      id: maps[0]["id"],
      image: maps[0]["image"],
      name: maps[0]["name"],
      age: maps[0]["age"],
      description: maps[0]["description"]
    );
  }
}