import "dbFactory.dart";
import "../dbModels/beastDbModel.dart";
import "../models/beastDetailInfoModel.dart";

class BeastWriter{
  static Future<void> updateBeast(BeastDetailInfoModel beast) async {
    final db = await getDatabase();

    BeastDbModel beastDbModel = BeastDbModel(
      id: beast.id,
      imageName: beast.imageName,
      name: beast.name,
      age: beast.age,
      description: beast.description,
      like: beast.like ? 1 : 0
    );

    await db.update(
      "Beasts",
      beastDbModel.toMap(),
      where: "id = ?",
      whereArgs: [beastDbModel.id],
    );
  }
}