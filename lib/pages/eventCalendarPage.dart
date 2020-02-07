import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:table_calendar/table_calendar.dart";
import "../models/eventModel.dart";
import "../models/clinicModel.dart";
import "../dbActions/clinicReader.dart";
import "../dbActions/eventReader.dart";
import "createOrViewEventModal.dart";

class EventCalendarPage extends StatefulWidget {
  final int beastId;
  final String beastName;
  final String type;
  final bool isEditable;
  final void Function(EventModel value, String type) onEventChange;
  EventCalendarPage({this.beastId, this.beastName, this.type, this.isEditable, this.onEventChange});
  @override
  _EventCalendarPageState createState() => _EventCalendarPageState();
}

class _EventCalendarPageState extends State<EventCalendarPage> {

  Map<DateTime, List<EventModel>> events = {};
  DateTime selectedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  
    int firstDayOfMonthInMilliseconds = getMillisecondsforFirstDayOfMonth(DateTime.now().millisecondsSinceEpoch);
    EventReader.getEventsForMonth(widget.beastId, widget.type, firstDayOfMonthInMilliseconds).then((newEvents){
      setState(() {
        newEvents.forEach((newEvent){
          DateTime key = DateTime(newEvent.dateTime.year, newEvent.dateTime.month, newEvent.dateTime.day);
          if(events[key] == null){
            events[key] = [];
          }
          events[key].add(newEvent);
        });
      });
    });
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  int getMillisecondsforFirstDayOfMonth(int milliseconds){
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return DateTime(dateTime.year, dateTime.month, 1).millisecondsSinceEpoch;
  }

  Future<T> createOrViewEventsModal<T>({int eventId, String modalType, int beastId, String beastName, String type, DateTime date, int clinicId, String description}) async {
    List<ClinicModel> clinics = await ClinicReader.getClinics();

    return showDialog(
      context: context,
      builder: (BuildContext context){
        return CreateOrViewEventModal(
          eventId: eventId,
          modalType: modalType,
          beastId: beastId,
          beastName: beastName, 
          type: type, 
          date: date,
          clinicId: clinicId,
          description: description, 
          clinics: clinics, 
          onValueChange: onValueChange);
      }
    );
  }

  void onValueChange(DateTime key, EventModel value, String type) {
    setState(() {
      if(type == "Add"){
        if(events[key] == null){
          events[key] = [];
        }
        events[key].add(value);
        events[key].sort((event, event1){
          if(event.dateTime.isBefore(event1.dateTime)){
            return 0;
          } else {
            return 1;
          }
        });
        widget.onEventChange(value, "Add");
      } else {
        int index = events[key].indexWhere((event){
          return event.id == value.id;
        });
        events[key].removeAt(index);
        widget.onEventChange(value, "Delete");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Event Calendar"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            TableCalendar(
              calendarController: _calendarController,
              events: events,
              onDaySelected: (date, events){
                setState(() {
                  selectedDate = DateTime(date.year, date.month, date.day);
                });  
              },
              onDayLongPressed: (date, events) async {
                if(widget.isEditable){
                  DateTime now = DateTime.now();
                  DateTime today = DateTime(now.year, now.month, now.day, 23, 59, 59);
                  if(date.isAfter(today)){
                    await createOrViewEventsModal(
                      eventId: null,
                      modalType: "Add",
                      beastId: widget.beastId,
                      beastName: widget.beastName, 
                      type: widget.type, 
                      date: date, 
                      clinicId: 1, 
                      description: null
                    );
                  } else {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Event cannot be created"),
                          content: Text("You cannot create an event on previous date"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("Close"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              },
              availableCalendarFormats: {CalendarFormat.month : "Month"},
              onVisibleDaysChanged: (DateTime startDate, DateTime endDate, CalendarFormat format) async {
                int millisecondsOfHalfMonth = 1296000000;
                int millisecondsforFirstDayOfMonth = getMillisecondsforFirstDayOfMonth(startDate.millisecondsSinceEpoch + millisecondsOfHalfMonth);
                List<EventModel> newEvents = await EventReader.getEventsForMonth(widget.beastId, widget.type, millisecondsforFirstDayOfMonth);
                setState(() {
                  events = {};
                  newEvents.forEach((newEvent){
                    DateTime key = DateTime(newEvent.dateTime.year, newEvent.dateTime.month, newEvent.dateTime.day);
                    if(events[key] == null){
                      events[key] = [];
                    }
                    events[key].add(newEvent);
                  });
                });
              },
            ),
            Expanded(
              child: events[selectedDate] == null || events[selectedDate].length == 0 ? Center(child: Text("No Event", style: TextStyle(fontSize: 20.0))) :
              ListView.builder(
                itemCount: events[selectedDate] == null ? 0 : events[selectedDate].length,
                itemBuilder: (BuildContext ctxt, int index) {
                  EventModel event = events[selectedDate][index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: GestureDetector(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(event.beastName, style: TextStyle(fontWeight: FontWeight.bold)),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(event.type),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(event.clinicName + " - " + DateFormat("MMM dd, yyyy HH:mm").format(event.dateTime)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(event.description),
                              )
                            ],
                          ),
                        ),
                      ),
                      onLongPress: () async {
                        if(widget.isEditable){
                          await createOrViewEventsModal(
                          eventId: event.id,
                          modalType: "View",
                          beastId: event.beastId,
                          beastName: widget.beastName, 
                          type: event.type, 
                          date: event.dateTime,
                          clinicId: event.clinicId, 
                          description: event.description);
                        }
                      },
                    ) 
                  );
                }
              ),
            )
          ],
        )
      ),
    ); 
  }
}