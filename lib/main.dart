import 'package:flutter/material.dart';

import 'package:AiOpsApp/colors.dart';
import 'package:AiOpsApp/environment_page.dart';
import 'package:AiOpsApp/home_page.dart';


void main() {
  runApp(App());
}

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Dynatrace AiOps',
      theme: ThemeData(
        primarySwatch: dtRedColor,
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => HomePage(),
        '/env': (context) => EnvironmentPage(),
      },
    );
  }

}