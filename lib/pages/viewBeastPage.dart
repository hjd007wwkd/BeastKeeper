import "package:flutter/material.dart";
import "package:intl/intl.dart";
import '../dbActions/beastWriter.dart';
import "../models/beastDetailInfoModel.dart";
import "../models/eventModel.dart";
import "eventCalendarPage.dart";

class ViewBeastPage extends StatefulWidget {
  final BeastDetailInfoModel beastDetailInfo;
  final List<EventModel> reminderEvents = [];
  final List<EventModel> historyEvents = [];
  final void Function(BeastDetailInfoModel) onInfoChange;

  ViewBeastPage({this.beastDetailInfo, List<EventModel> events, this.onInfoChange}){
    DateTime currentTime = DateTime.now();
    events.forEach((event) => {
      if(event.dateTime.isBefore(currentTime)){
        historyEvents.insert(0, event)
      } else {
        reminderEvents.add(event)
      }
    });
  }
  @override
  _ViewBeastPageState createState() => _ViewBeastPageState();
}

class _ViewBeastPageState extends State<ViewBeastPage> {

  BeastDetailInfoModel beastDetailInfo;
  List<EventModel> reminderEvents = [];
  List<EventModel> historyEvents = [];

  @override
  void initState() {
    super.initState();
    setState((){
      beastDetailInfo = widget.beastDetailInfo;
      reminderEvents = widget.reminderEvents;
      historyEvents = widget.historyEvents;
    });
  }

  Widget textField(String textName, String textValue){
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Container(
              width: 110.0,
              child: Text("$textName:", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),)
            ),
          ),
          Flexible(
            child: Text(textValue, style: TextStyle(fontSize: 15.0)),
          ),
        ],
      ),
    );
  }

  List<Widget> reminderWidgets(){
    List<Widget> reminders = <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 30.0, bottom: 15.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0), 
            color: Colors.lightBlue,
          ),
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(top: 10.0, left: 16.0, bottom: 10.0, right: 16.0),
            child: Text("Reminders", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),),
          )
        ),
      ),
    ];
    if(reminderEvents.length == 0){
      reminders.add(Center(child:Text("No Event", style: TextStyle(fontWeight: FontWeight.bold),)));
    } else {
      reminderEvents.forEach((event){
        reminders.add(
          Container(
            margin: EdgeInsets.only(bottom: 5.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueGrey),
              borderRadius: BorderRadius.circular(10.0)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(event.clinicName + " - " + DateFormat("MMM dd, yyyy HH:mm").format(event.dateTime), style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  Text(event.description)
                ]
              ),
            ),
          )
        );
      });
    }
    return reminders;
  }

  List<Widget> historyWidgets(){
    List<Widget> histories = <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 30.0, bottom: 15.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0), 
            color: Colors.lightBlue,
          ),
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(top: 10.0, left: 16.0, bottom: 10.0, right: 16.0),
            child: Text("Histories", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),),
          )
        ),
      ),
    ];
    if(historyEvents.length == 0){
      histories.add(Center(child:Text("No Event history", style: TextStyle(fontWeight: FontWeight.bold),)));
    } else {
      historyEvents.forEach((event){
        histories.add(
          Container(
            margin: EdgeInsets.only(bottom: 5.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueGrey),
              borderRadius: BorderRadius.circular(10.0)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(event.clinicName + " - " + DateFormat("MMM dd, yyyy HH:mm").format(event.dateTime), style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  Text(event.description)
                ]
              ),
            ),
          )
        );
      });
    }
    return histories;
  }

  void onEventChange(EventModel value, String type){
    if(type == "Delete"){
      setState(() {
        int index = reminderEvents.indexWhere((event){
          return event.id == value.id;
        });
        reminderEvents.removeAt(index);
      });
    } else {
      setState(() {
        if(reminderEvents.length == 0){
          reminderEvents.add(value);
        } else {
          reminderEvents.add(value);
          reminderEvents.sort((event, event1){
            if(event.dateTime.isBefore(event1.dateTime)){
              return 0;
            } else {
              return 1;
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("View My Beast"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.thumb_up, color: beastDetailInfo.like ? Colors.red : Colors.blueGrey),
              onPressed: (){
                setState(() {
                  beastDetailInfo.like = !beastDetailInfo.like;
                  BeastWriter.updateBeast(beastDetailInfo);
                  if(widget.onInfoChange != null){
                    widget.onInfoChange(beastDetailInfo);
                  }
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.calendar_today),
          onPressed: (){
            Navigator.push(context, new MaterialPageRoute(
              builder: (context) =>
                EventCalendarPage(beastId: beastDetailInfo.id, beastName: beastDetailInfo.name, type: "New", isEditable: true, onEventChange: onEventChange))
            );
          },
        ),
        body: Padding(
          padding: const EdgeInsets.only(right: 15.0, left: 15.0),
          child: ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 15.0, bottom: 30.0),
                height:400.0,
                child: Image.asset("assets/images/" + beastDetailInfo.imageName)
              ),
              textField("Name", beastDetailInfo.name),
              textField("Age", beastDetailInfo.age.toString()),
              textField("Description", beastDetailInfo.description),
              ...reminderWidgets(),
              ...historyWidgets()
            ],
          ),
        ),
      )
    ); 
  }
}