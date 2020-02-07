import "dart:convert";
import "package:flutter/material.dart";
import "package:carousel_slider/carousel_slider.dart";
import "package:provider/provider.dart";
import "eventCalendarPage.dart";
import "registerOrEditMyBeastPage.dart";
import "viewBeastPage.dart";
import "viewMyBeastPage.dart";
import 'beastPreferencePage.dart';
import "../stateModel/myBeastsStateModel.dart";
import "../stateModel/BeastsStateModel.dart";
import "../models/myBeastSimpleInfoModel.dart";
import "../models/myBeastDetailInfoModel.dart";
import "../models/beastDetailInfoModel.dart";
import "../models/eventModel.dart";
import "../dbActions/myBeastReader.dart";
import "../dbActions/beastReader.dart";
import "../dbActions/eventReader.dart";

class HomePage extends StatelessWidget {
  Widget myBeastItemWidget(BuildContext context, MyBeastSimpleInfoModel myBeast){
    return GestureDetector(
      child: Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: TextDirection.ltr,
          children: <Widget>[
            Container(
              width: 200.0,
              height: 140.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: MemoryImage(base64Decode(myBeast.image)),
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
                      child: Text(myBeast.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0), overflow: TextOverflow.ellipsis),
                    ),
                    Text(myBeast.description, overflow: TextOverflow.ellipsis, maxLines: 5,)
                  ],
                ),
              ),
            )
          ]
        ),
      ),
      onTap: () async {
        MyBeastDetailInfoModel myBeastinfo = await MyBeastReader.getMyBeastDetailInfo(myBeast.id);
        List<EventModel> events = await EventReader.getRecentEvents(myBeast.id, "Regular", DateTime.now().millisecondsSinceEpoch);
        Navigator.push(context, new MaterialPageRoute(
          builder: (context) =>
            ViewMyBeastPage(myBeastinfo, events))
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final myBeastsStateProvider = Provider.of<MyBeastsStateModel>(context);
    final beastsStateProvider = Provider.of<BeastsStateModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("My Magnificent Beasts"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              Navigator.push(context, new MaterialPageRoute(
                builder: (context) =>
                  RegisterOrEditMyBeastPage())
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.calendar_today),
        onPressed: (){
          Navigator.push(context, new MaterialPageRoute(
            builder: (context) =>
              EventCalendarPage(isEditable: false))
          );
        },
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Image(
                  image: AssetImage("assets/images/lights.jpg")
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50.0, left: 16.0),
                  child: CircleAvatar(
                    radius: 40.0,
                    backgroundImage: AssetImage("assets/images/avatar.png"),
                  )
                ),
                Padding(
                  padding: EdgeInsets.only(top: 150.0, left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("User Name", style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.white
                      )),
                      Text("user_0121@gmail.com", style: TextStyle(color: Colors.white))
                    ],
                  )
                )
              ]
            ),
            MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: ListTile(
                      leading: Icon(Icons.arrow_right, size: 50.0, color: Colors.blue),
                      title: Text("Beast Preference", style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0,
                      )),
                      onTap: () async {
                        List<BeastDetailInfoModel> beastsDetailInfo = await BeastReader.getBeastsILike();
                        Navigator.push(context, new MaterialPageRoute(
                          builder: (context) =>
                            BeastPreferencePage(beastsDetailInfo: beastsDetailInfo))
                        );
                      }
                    ),
                  )
                ],
              ),
            )
          ],
        )
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: myBeastsStateProvider.myBeastsSimpleInfo.length == 0 ? Container(child: Center(child: Text("Please add your magnificent beast."))) :
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: myBeastsStateProvider.myBeastsSimpleInfo.length,
              itemBuilder: (BuildContext context, int index){
                return myBeastItemWidget(context, myBeastsStateProvider.myBeastsSimpleInfo[index]);
              }
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.lightBlue,
            child: Padding(
              padding: EdgeInsets.only(top: 10.0, left: 16.0, bottom: 10.0, right: 16.0),
              child: Text("Beast Finder", textDirection: TextDirection.ltr, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),),
            )
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0, left: 16.0, bottom: 10.0, right: 16.0),
            child: beastsStateProvider.beastsSimpleInfo.length == 0 ? Center(child: Text("No Beast")) :
              CarouselSlider(
                height: 200,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                items: beastsStateProvider.beastsSimpleInfo.map((beast) {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/" + beast.imageName),
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: Container(
                              width: double.infinity,
                              height: 30.0,
                              color: Colors.white,
                              child: Center(child: Text(beast.name))
                            )
                          ),
                        ),
                        onTap: () async {
                          BeastDetailInfoModel beastInfo = await BeastReader.getBeastDetailInfo(beast.id);
                          List<EventModel> events = await EventReader.getRecentEvents(beast.id, "New", DateTime.now().millisecondsSinceEpoch);
                          Navigator.push(context, new MaterialPageRoute(
                            builder: (context) =>
                              ViewBeastPage(
                                beastDetailInfo: beastInfo, 
                                events: events
                              )
                            )
                          );
                        },
                      );
                    },
                  );
                }).toList(),
              ),
          )
        ],
      )
    );
  }
}