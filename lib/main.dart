import "package:flutter/material.dart";
import "package:provider/provider.dart";
import 'pages/homePage.dart';
import "stateModel/myBeastsStateModel.dart";
import "stateModel/BeastsStateModel.dart";

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MyBeastsStateModel()),
        ChangeNotifierProvider(create: (context) => BeastsStateModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}