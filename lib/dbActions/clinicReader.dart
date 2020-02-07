import "package:sqflite/sqflite.dart";
import "dbFactory.dart";
import "../models/clinicModel.dart";

class ClinicReader{
  static Future<List<ClinicModel>> getClinics() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query("clinics");
    return List.generate(maps.length, (i) {
      return ClinicModel(
        clinicId: maps[i]["id"],
        clinicName: maps[i]["clinicName"],
        specialty: maps[i]["spcialty"]
      );
    });
  }
}