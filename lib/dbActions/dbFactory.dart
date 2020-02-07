import "dart:async";
import "package:path/path.dart";
import "package:sqflite/sqflite.dart";

Future<Database> getDatabase() async {
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), "BeastKeeper.db"),
    onCreate: (db, version) {
      db.execute("CREATE TABLE MyBeasts(id INTEGER PRIMARY KEY, image Text, name TEXT, age INTEGER, description Text)");
      db.execute("CREATE TABLE Beasts(id INTEGER PRIMARY KEY, imageName Text, name TEXT, age INTEGER, description Text, like INTEGER)");
      db.execute("CREATE TABLE Events(id INTEGER PRIMARY KEY, clinicId INTEGER, beastId INTEGER, type TEXT, dateTime INTEGER, description Text)");
      db.execute("CREATE TABLE Clinics(id INTEGER PRIMARY KEY, clinicName TEXT, specialty Text)");
      
      db.execute("INSERT INTO Beasts (imageName, name, age, description, like) VALUES ('big_blue_fly.jpg', 'Big Blue Fly', 12, 'This is Big Blue Fly', 0)");
      db.execute("INSERT INTO Beasts (imageName, name, age, description, like) VALUES ('dragon_snake.jpg', 'Dragon Snake', 4, 'This is Dragon Snake', 0)");
      db.execute("INSERT INTO Beasts (imageName, name, age, description, like) VALUES ('eye_cow.jpg', 'Eye Cow', 5, 'This is Eye Cow', 0)");
      db.execute("INSERT INTO Beasts (imageName, name, age, description, like) VALUES ('fire_dragon.jpg', 'Fire Dragon', 10, 'This is Fire Dragon', 0)");
      db.execute("INSERT INTO Beasts (imageName, name, age, description, like) VALUES ('golden_eagle.jpg', 'Golden Eagle', 21, 'This is Golden Eagle', 0)");
      db.execute("INSERT INTO Beasts (imageName, name, age, description, like) VALUES ('green_bird.jpg', 'Green Bird', 8, 'This is Green Bird', 0)");
      db.execute("INSERT INTO Beasts (imageName, name, age, description, like) VALUES ('jewelry_theft.jpg', 'Jewelry Theft', 7, 'This is Jewelry Theft', 0)");
      db.execute("INSERT INTO Beasts (imageName, name, age, description, like) VALUES ('prawn_horse.jpg', 'Prawn Horse', 32, 'This is Prawn Horse', 0)");
      db.execute("INSERT INTO Beasts (imageName, name, age, description, like) VALUES ('white_grandpa.jpg', 'White Grandpa', 17, 'This is White Grandpa', 0)");
      db.execute("INSERT INTO Beasts (imageName, name, age, description, like) VALUES ('wooden_kid.jpg', 'Wooden Kid', 28, 'This is Wooden Kid', 0)");
      
      db.execute("INSERT INTO Clinics (clinicName, specialty) VALUES ('South Clinic', 'Eye, Nose, Tongue')");
      db.execute("INSERT INTO Clinics (clinicName, specialty) VALUES ('North Clinic', 'Hair, Eyebrow, Finger')");
      db.execute("INSERT INTO Clinics (clinicName, specialty) VALUES ('West Clinic', 'Nail, Beauty, Ear')");
      db.execute("INSERT INTO Clinics (clinicName, specialty) VALUES ('East Clinic', 'Toe, Palm, Heart')");
    },
    version: 1,
  );

  return database;
}