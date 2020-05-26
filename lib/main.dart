import 'package:flutter/material.dart';
import 'package:quote_sender/Helpers/InternetCheck.dart';
import './LayoutBuilder/ListBuilder.dart';

void main() {
  InternetCheck.check();
  runApp(
    MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.deepPurple[600],
          brightness: Brightness.dark,
          primaryColorDark: Colors.deepPurpleAccent[600]),
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListBuilder();
  }
}
