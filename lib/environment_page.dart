import 'package:AiOpsApp/problem_widgets.dart';
import 'package:flutter/material.dart';

import 'package:AiOpsApp/stacked_barchart.dart';
import 'package:AiOpsApp/problem_feed.dart';
import 'package:AiOpsApp/event_feed.dart';
import 'package:AiOpsApp/colors.dart';
import 'package:AiOpsApp/futures/environment.dart';

class EnvironmentScreenArguments {
  final String title;
  final String environmentUrl;
  final String environmentSecret;
  final String entityFilter;

  EnvironmentScreenArguments(this.title, this.environmentUrl, this.environmentSecret, this.entityFilter);
}

/*
 * Screen for showing all problem and event information for a given single Dynatrace environment. 
 */
class EnvironmentPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final EnvironmentScreenArguments args = ModalRoute.of(context).settings.arguments;
    Future<ProblemFeed> problemFeed = fetchProblemFeed(args.environmentUrl, args.environmentSecret);
    Future<EventFeed> eventFeed = fetchEventFeed(args.environmentUrl, args.environmentSecret);
    
    return Scaffold(
      backgroundColor: dtBackgroundColor,
      appBar: AppBar(
        title: Text("Environment (" + args.title + ")"),
        actions: <Widget>[
            
          ],
      ),
      body: Center(
        child: ListView(
          
          children: <Widget>[
            ExpansionTile(
              backgroundColor: dtChartBackColor,
              title: Text('Events', style: TextStyle(color: Colors.white),),
              trailing: SizedBox(),
              children: <Widget>[
                FutureBuilder<EventFeed>(
                  future: eventFeed,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return StackedBarChart(seriesList: snapshot.data.series, title: "Events last 24 hours", animate: false,);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    // By default, show a loading spinner.
                    return CircularProgressIndicator();
                  },
                )
              ]
            ),
            ExpansionTile(
              initiallyExpanded: true,
              backgroundColor: dtChartBackColor,
              title: Text('Incidents', style: TextStyle(color: Colors.white),),
              trailing: SizedBox(),
              children: <Widget>[
                FutureBuilder<ProblemFeed>(
                  future: problemFeed,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return StackedBarChart(seriesList: snapshot.data.series, title: "Incidents (Problems) last 24 hours", animate: false,);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    // By default, show a loading spinner.
                    return CircularProgressIndicator();
                  },
                )
              ]
            ),
            FutureBuilder<ProblemFeed>(
              future: problemFeed,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ProblemList(snapshot.data.problems, snapshot.data.total);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                // By default, show a loading spinner.
                  return CircularProgressIndicator();
                },
            ) 
          ],
        ),
      ),
      
    );
  }
}


  



