import "package:sqflite/sqflite.dart";
import "dbFactory.dart";
import "../models/eventModel.dart";

class EventReader{
  static Future<List<EventModel>> getEventsForMonth(int beastId, String type, int firstDayOfMonthInMilliseconds) async {
    const int millisecondsForMonth = 2628000000;
    int lastDayOfMonthInMilliseconds = firstDayOfMonthInMilliseconds + millisecondsForMonth;

    final Database db = await getDatabase();

    String query;
    List<dynamic> args;

    if(type == "Regular"){
      query = 
      """
      SELECT Events.id, Events.beastId, myBeasts.name AS myBeastName, Events.clinicId, Clinics.clinicName, Events.type, Events.dateTime, Events.description 
      FROM Events Join Clinics ON Events.clinicId = Clinics.id
      Left Join MyBeasts ON Events.beastId = MyBeasts.id
      WHERE Events.beastId == ? AND Events.type == ? AND Events.dateTime <= ? AND Events.dateTime >= ? ORDER BY Events.dateTime
      """;
      args = [beastId, type, lastDayOfMonthInMilliseconds, firstDayOfMonthInMilliseconds];
    } else if (type == "New"){
      query = 
      """
      SELECT Events.id, Events.beastId, Beasts.name AS beastName, Events.clinicId, Clinics.clinicName, Events.type, Events.dateTime, Events.description 
      FROM Events Join Clinics ON Events.clinicId = Clinics.id
      Left Join Beasts ON Events.beastId = Beasts.id
      WHERE Events.beastId == ? AND Events.type == ? AND Events.dateTime <= ? AND Events.dateTime >= ? ORDER BY Events.dateTime
      """;
      args = [beastId, type, lastDayOfMonthInMilliseconds, firstDayOfMonthInMilliseconds];
    } else {
      query = 
      """
      SELECT Events.id, Events.beastId, Beasts.name AS beastName, myBeasts.name AS myBeastName, Events.clinicId, Clinics.clinicName, Events.type, Events.dateTime, Events.description 
      FROM Events Join Clinics ON Events.clinicId = Clinics.id 
      Left Join Beasts ON Events.beastId = Beasts.id AND Events.type = ?
      Left Join MyBeasts ON Events.beastId = MyBeasts.id AND Events.type = ?
      WHERE Events.dateTime <= ? AND Events.dateTime >= ? ORDER BY Events.dateTime
      """;
      args = ["New", "Regular", lastDayOfMonthInMilliseconds, firstDayOfMonthInMilliseconds];
    }
    
    final List<Map<String, dynamic>> maps = await db.rawQuery(query, args);

    return List.generate(maps.length, (i) {
      int dateTimeInMilliseconds = maps[i]["dateTime"];
      return EventModel(
        id: maps[i]["id"],
        beastId: maps[i]["beastId"],
        beastName: maps[i]["myBeastName"] ?? maps[i]["beastName"],
        clinicId: maps[i]["clinicId"],
        clinicName: maps[i]["clinicName"],
        type: maps[i]["type"],
        dateTime: DateTime.fromMillisecondsSinceEpoch(dateTimeInMilliseconds),
        description: maps[i]["description"]
      );
    });
  }

  static Future<List<EventModel>> getRecentEvents(int beastId, String type, int todayInMilliseconds) async {
    const int millisecondsForMonth = 2628000000;
    int lastDate = todayInMilliseconds - (millisecondsForMonth * 2);

    final Database db = await getDatabase();

    String query = 
      """
      SELECT Events.id, Events.beastId, Events.clinicId, Clinics.clinicName, Events.type, Events.dateTime, Events.description 
      FROM Events Join Clinics ON Events.clinicId = Clinics.id WHERE Events.beastId == ? AND Events.type == ? AND Events.dateTime >= ? ORDER BY Events.dateTime
      """;
    List<dynamic> args = [beastId, type, lastDate];
    
    final List<Map<String, dynamic>> maps = await db.rawQuery(query, args);

    return List.generate(maps.length, (i) {
      int dateTimeInMilliseconds = maps[i]["dateTime"];
      return EventModel(
        id: maps[i]["id"],
        beastId: maps[i]["beastId"],
        clinicId: maps[i]["clinicId"],
        clinicName: maps[i]["clinicName"],
        type: maps[i]["type"],
        dateTime: DateTime.fromMillisecondsSinceEpoch(dateTimeInMilliseconds),
        description: maps[i]["description"]
      );
    });
  }
}