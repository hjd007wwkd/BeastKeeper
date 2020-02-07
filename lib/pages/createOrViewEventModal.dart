import "package:datetime_picker_formfield/datetime_picker_formfield.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "../models/clinicModel.dart";
import "../models/eventModel.dart";
import "../dbActions/eventWriter.dart";
import "../utilities/stringUtilities.dart";

class CreateOrViewEventModal extends StatefulWidget {
  const CreateOrViewEventModal({this.eventId, this.modalType, this.beastId, this.beastName, this.type, this.date, this.clinicId, this.description, this.clinics, this.onValueChange});

  final int eventId;
  final String modalType;
  final int beastId;
  final String beastName;
  final String type;
  final DateTime date;
  final int clinicId;
  final String description;
  final List<ClinicModel> clinics;
  final void Function(DateTime key, EventModel value, String type) onValueChange;

  @override
  _CreateOrViewEventModalState createState() => _CreateOrViewEventModalState();
}

class _CreateOrViewEventModalState extends State<CreateOrViewEventModal> {

  var state = {
    "time": null,
    "clinicId": 1,
    "description": "",
    "isTimeInputNotValid": false,
    "isDescriptionInputNotValid": false,
  };

  @override
  void initState() {
    super.initState();
    if(widget.modalType == "View"){
      setState(() {
        state["time"] = widget.date;
        state["clinicId"] = widget.clinicId;
        state["description"] = widget.description;
      });
    }
  }

  Widget dropDownClinics(List<ClinicModel> clinics){
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.blueGrey)),
      child: widget.modalType == "Add" ? Padding(
        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
        child: DropdownButton<String>(
          value: state["clinicId"].toString(),
          icon: Icon(Icons.arrow_downward, color: Colors.blue),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.black),
          isExpanded: true,
          onChanged: (String newValue) {
            setState(() {
              state["clinicId"] = int.parse(newValue);
            });
          },
          items: clinics
              .map<DropdownMenuItem<String>>((ClinicModel clinic) {
            return DropdownMenuItem<String>(
              value: clinic.clinicId.toString(),
              child: Text(clinic.clinicName),
            );
          }).toList(),
        ),
      ) : Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0, left: 8.0),
        child: Text(clinics.firstWhere((clinic)=> clinic.clinicId == state["clinicId"] as int).clinicName),
      ),
    );
  }

  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("${widget.modalType} Event"),
      content: Container(
        height: 500.0,
        width: 300.0,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text("Name:"),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueGrey)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.beastName),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Text("Type:"),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueGrey)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.type),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Text("Clinic:"),
            ),
            dropDownClinics(widget.clinics),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Text("Date:"),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueGrey)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(DateFormat("MMM dd yyyy").format(widget.date))
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Text("Time:"),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueGrey)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                      child: DateTimeField(
                        enabled: widget.modalType == "Add" ? true : false,
                        resetIcon: null,
                        initialValue: (state["time"] as DateTime),
                        format: DateFormat("HH:mm"),
                        onShowPicker: (context, currentValue) async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                          );
                          DateTime selectedTime = DateTimeField.convert(time);
                          
                          return selectedTime;
                        },
                        onChanged: (dateTime){
                          setState(() {
                            state["time"] = dateTime;
                          });
                        },  
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: state["isTimeInputNotValid"],
              child: Text("Time input cannot be empty.", style: TextStyle(color: Colors.red)),
            ), 
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Text("Description:"),
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueGrey)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                      child: TextFormField(
                        enabled: widget.modalType == "Add" ? true : false,
                        initialValue: state["description"],
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        onChanged: (value){
                          setState(() {
                            state["description"] = value;
                          });
                        },  
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: state["isDescriptionInputNotValid"],
              child: Text("Descripiton input cannot be empty.", style: TextStyle(color: Colors.red)),
            ),             
            Visibility(
              visible: widget.modalType == "Add" || DateTime.now().isBefore(DateTime(widget.date.year, widget.date.month, widget.date.day, (state["time"] as DateTime).hour, (state["time"] as DateTime).minute)),
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: FlatButton(
                  color: widget.modalType == "Add" ? Colors.blue : Colors.redAccent,
                  child: Text(widget.modalType == "Add" ? "Add" : "Delete"),
                  onPressed: () async {
                    if(state["time"] == null || (state["description"] as String).isNullOrEmpty()){
                      state["isTimeInputNotValid"] = false;
                      state["isDescriptionInputNotValid"] = false;

                      bool isTimeInputNotValid = false;
                      bool isDescriptionInputNotValid = false;
                      if(state["time"] == null){
                        isTimeInputNotValid = true;
                      }
                      if((state["description"] as String).isNullOrEmpty()){
                        isDescriptionInputNotValid = true;
                      }

                      setState(() {
                        state["isTimeInputNotValid"] = isTimeInputNotValid;
                        state["isDescriptionInputNotValid"] = isDescriptionInputNotValid;
                      });
                    } else {
                      DateTime date = widget.date;
                      DateTime time = state["time"];
                      DateTime dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);

                      EventModel event = EventModel(
                        id: widget.eventId,
                        beastId: widget.beastId,
                        beastName: widget.beastName,
                        clinicId: state["clinicId"],
                        type: widget.type,
                        clinicName: widget.clinics.firstWhere((clinic){
                          return state["clinicId"] == clinic.clinicId;
                        }).clinicName,
                        dateTime: dateTime,
                        description: state["description"]
                      );

                      if(widget.modalType == "Add"){
                        int eventId = await EventWriter.insertEvent(event);
                        event.id = eventId;
                      } else {
                        await EventWriter.deleteEvent(widget.eventId);
                      }
                      
                      widget.onValueChange(DateTime(date.year, date.month, date.day), event, widget.modalType);
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            )
          ], 
        ),
      ),
    );
  }
}