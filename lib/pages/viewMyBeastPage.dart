import "dart:convert";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";
import "../models/eventModel.dart";
import "../models/myBeastDetailInfoModel.dart";
import "../dbActions/myBeastWriter.dart";
import "eventCalendarPage.dart";
import "registerOrEditMyBeastPage.dart";
import "../stateModel/myBeastsStateModel.dart";

class ViewMyBeastPage extends StatefulWidget {
  final MyBeastDetailInfoModel myBeastDetailInfo;
  final List<EventModel> reminderEvents = [];
  final List<EventModel> historyEvents = [];

  ViewMyBeastPage(this.myBeastDetailInfo, List<EventModel> events){
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
  _ViewMyBeastPageState createState() => _ViewMyBeastPageState();
}

class _ViewMyBeastPageState extends State<ViewMyBeastPage> {
  MyBeastDetailInfoModel myBeastDetailInfo;
  List<EventModel> reminderEvents = [];
  List<EventModel> historyEvents = [];

  @override
  void initState() {
    super.initState();
    setState((){
      myBeastDetailInfo = widget.myBeastDetailInfo;
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

  void onInfoChange(MyBeastDetailInfoModel myBeast){
    setState(() {
      myBeastDetailInfo = myBeast;
    });
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
    final myBeastsStateProvider = Provider.of<MyBeastsStateModel>(context);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("View My Beast"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await MyBeastWriter.deleteMyBeast(myBeastDetailInfo.id);
                myBeastsStateProvider.deleteMyBeastSimpleInfo(myBeastDetailInfo.id);
                Navigator.pop(context);
              },
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) =>
                    RegisterOrEditMyBeastPage(
                      myBeastDetailInfo: myBeastDetailInfo, 
                      onInfoChange: onInfoChange
                    )
                  )
                );
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
                EventCalendarPage(beastId: myBeastDetailInfo.id, beastName: myBeastDetailInfo.name, type: "Regular", isEditable: true, onEventChange: onEventChange))
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
                child: Image.memory(base64Decode(myBeastDetailInfo.image))
              ),
              textField("Name", myBeastDetailInfo.name),
              textField("Age", myBeastDetailInfo.age.toString()),
              textField("Description", myBeastDetailInfo.description),
              ...reminderWidgets(),
              ...historyWidgets()
            ],
          ),
        ),
      )
    ); 
  }
}