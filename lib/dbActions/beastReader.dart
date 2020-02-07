import "package:sqflite/sqflite.dart";
import "../models/beastSimpleInfoModel.dart";
import "../models/beastDetailInfoModel.dart";
import "dbFactory.dart";

class BeastReader{
  static Future<List<BeastSimpleInfoModel>> getBeastsSimpleInfo() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query("beasts");

    return List.generate(maps.length, (i) {
      return BeastSimpleInfoModel(
        id: maps[i]["id"],
        imageName: maps[i]["imageName"],
        name: maps[i]["name"]
      );
    });
  }

  static Future<BeastDetailInfoModel> getBeastDetailInfo(int id) async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      "beasts", 
      where: "id = ?",
      whereArgs: [id],
    );

    return BeastDetailInfoModel(
      id: maps[0]["id"],
      imageName: maps[0]["imageName"],
      name: maps[0]["name"],
      age: maps[0]["age"],
      description: maps[0]["description"],
      like: maps[0]["like"] == 1 ? true :  false
    );
  }

  static Future<List<BeastDetailInfoModel>> getBeastsILike() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      "beasts", 
      where: "like = 1"
    );

    return List.generate(maps.length, (i) {
      return BeastDetailInfoModel(
        id: maps[i]["id"],
        imageName: maps[i]["imageName"],
        name: maps[i]["name"],
        age: maps[i]["age"],
        description: maps[i]["description"],
        like: maps[i]["like"] == 1 ? true :  false
      );
    });
  }
}