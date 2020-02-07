import "package:sqflite/sqflite.dart";
import "dbFactory.dart";
import "../models/eventModel.dart";
import "../dbModels/eventDbModel.dart";

class EventWriter{
  static Future<int> insertEvent(EventModel event) async {
    final Database db = await getDatabase();

    EventDbModel eventDbModel = EventDbModel(
      id: event.id,
      clinicId: event.clinicId,
      beastId: event.beastId,
      type: event.type,
      dateTime: event.dateTime.millisecondsSinceEpoch,
      description: event.description
    );

    return await db.insert(
      "Events",
      eventDbModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> deleteEvent(int id) async {
    final db = await getDatabase();

    await db.delete(
      "Events",
      where: "id = ?",
      whereArgs: [id],
    );
  }
}