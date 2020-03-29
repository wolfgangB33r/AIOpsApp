import 'package:AiOpsApp/colors.dart';
import 'package:flutter/material.dart';
import 'dart:async';


import 'package:AiOpsApp/futures/environment.dart';
import 'package:AiOpsApp/environment_page.dart';

class HomePage extends StatefulWidget {
  
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final Map<String, EnvironmentScreenArguments> envs = {
    //'yourenv' : EnvironmentScreenArguments("your_env", "env_URL", "api_token", ""),
  }; 

  _HomePageState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> envTiles = [];
    envTiles.add(SizedBox(width: 10,height: 10,),);
    envTiles.add(Text('Your Environments', style: TextStyle(color: Colors.white, fontSize: 20)));
    envTiles.add(SizedBox(width: 10,height: 20,));

    for (var key in envs.keys) {
      print(key);
      envTiles.add(EnvironmentTile(envs[key]));
      envTiles.add(SizedBox(width: 10,height: 20,));
    }

    return Scaffold(
      backgroundColor: dtBackgroundColor,
      appBar: AppBar(
        title: Text("Home"),
        actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                
              },
            ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(0.0),
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: ListView(
          children: envTiles
        ),
      )
    );
  }
}

class EnvironmentTile extends StatefulWidget {
  final EnvironmentScreenArguments env;
  
  EnvironmentTile(this.env);

  @override
  _EnvironmentTileState createState() => _EnvironmentTileState(env);
}

class _EnvironmentTileState extends State<EnvironmentTile> {
  EnvironmentScreenArguments env;

  _EnvironmentTileState(this.env);

  @override
  Widget build(BuildContext context) {
    Future<Text> openProblemCount = fetchOpenProblemsCount(env);
    
    return ExpansionTile(
              initiallyExpanded: false,
              backgroundColor: dtChartBackColor,
              title: Row(children: <Widget>[
                FloatingActionButton.extended(
                  heroTag: env.title,
                  onPressed: () {
                    Navigator.pushNamed(context, '/env', arguments: env,); 
                  },
                  label: 
                    FutureBuilder<Text>(
                      future: openProblemCount,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return snapshot.data;
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        // By default, show a loading spinner.
                        return CircularProgressIndicator();
                      },
                    ), 
                  backgroundColor: dtChartBackColor ,
                ),
                SizedBox(width: 10,height: 10,),
                Text(env.title, style: TextStyle(color: Colors.white, fontSize: 20),),
                
                
              ]),
              trailing: SizedBox(),
              children: <Widget>[
                Text("innen")
              ]
            );
  }
}






