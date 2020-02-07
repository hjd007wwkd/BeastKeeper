import "clinicModel.dart";

class EventModel extends ClinicModel {
  int id;
  int beastId;
  String beastName;
  String type;
  DateTime dateTime;
  String description;

  EventModel({int id, int clinicId, int beastId, String beastName, String type, String clinicName, DateTime dateTime, String description})
    : super(clinicId: clinicId, clinicName: clinicName, specialty: null)
  {
    this.id = id;
    this.beastId = beastId;
    this.beastName = beastName;
    this.type = type;
    this.dateTime = dateTime;
    this.description = description;
  }
}