import "package:flutter/material.dart";
import '../dbActions/beastReader.dart';
import '../dbActions/eventReader.dart';
import "../models/beastDetailInfoModel.dart";
import "../models/eventModel.dart";
import 'viewBeastPage.dart';

class BeastPreferencePage extends StatefulWidget {
  final List<BeastDetailInfoModel> beastsDetailInfo;

  BeastPreferencePage({this.beastsDetailInfo});

  @override
  _BeastPreferencePageState createState() => _BeastPreferencePageState();
}

class _BeastPreferencePageState extends State<BeastPreferencePage> {

  List<BeastDetailInfoModel> beastsDetailInfo;

  @override
  void initState() {
    super.initState();
    setState((){
      beastsDetailInfo = widget.beastsDetailInfo;
    });
  }

  void onInfoChange(BeastDetailInfoModel beastDetailInfo){
    setState(() {
      int index = beastsDetailInfo.indexWhere((beast) => beast.id == beastDetailInfo.id);
      beastsDetailInfo.removeAt(index);
    });
  }

  Widget beastItemWidget(BeastDetailInfoModel beast){
    return GestureDetector(
      child: Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 200.0,
              height: 140.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/" + beast.imageName),
                  fit: BoxFit.cover,
                ),
              )
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 15.0, right: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(beast.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0), overflow: TextOverflow.ellipsis),
                    ),
                    Text(beast.description, overflow: TextOverflow.ellipsis, maxLines: 5,)
                  ],
                ),
              ),
            )
          ]
        ),
      ),
      onTap: () async {
        BeastDetailInfoModel beastInfo = await BeastReader.getBeastDetailInfo(beast.id);
        List<EventModel> events = await EventReader.getRecentEvents(beast.id, "New", DateTime.now().millisecondsSinceEpoch);
        Navigator.push(context, new MaterialPageRoute(
          builder: (context) =>
            ViewBeastPage(
              beastDetailInfo: beastInfo, 
              events: events,
              onInfoChange: onInfoChange,
            )
          )
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Beast Preference"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: beastsDetailInfo.length == 0 ? Container(child: Center(child: Text("You don't have any liked beast"))) :
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: beastsDetailInfo.length,
            itemBuilder: (BuildContext context, int index){
              return beastItemWidget(beastsDetailInfo[index]);
            }
          ),
      )
    ); 
  }
}