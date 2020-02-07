class EventDbModel {
  final int id;
  final int clinicId;
  final int beastId;
  final String type;
  final int dateTime;
  final String description;

  EventDbModel({this.id, this.clinicId, this.beastId, this.type, this.dateTime, this.description});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "clinicId": clinicId,
      "beastId": beastId,
      "type": type,
      "dateTime": dateTime,
      "description": description,
    };
  }
}