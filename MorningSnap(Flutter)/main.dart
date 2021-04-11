import 'package:flutter/material.dart';
import './calendar.dart';
import './constant.dart' as Constant;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      builder: (context, snapshot){
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: Calendar(title: 'KN Morning Snap', theUser: Constant.KAIWEN),
        );
      }, 
    );
  }
}

