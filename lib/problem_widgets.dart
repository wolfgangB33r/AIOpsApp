import 'package:AiOpsApp/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class ProblemList extends StatelessWidget {
  final List<dynamic> problems;
  final int total;

  ProblemList(this.problems, this.total);

  @override
  Widget build(BuildContext context) {
    final List<Widget> l = [];
    // add total number text
    final String title = total.toString() + " Problems, showing first " + problems.length.toString();
    l.add(Padding(
      padding: const EdgeInsets.all(15.0), 
      child: 
        Text(
          title, 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        )
      )
    );
    
    // add all problem cards
    for(int i=0; i< problems.length;i++) {
      l.add(ProblemCard(problems[i]));
    }
    
    return Container(
      //height: 600,
      margin: EdgeInsets.all(0.0),
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(5.0),

          child: Column(
            children: l,
          ),
        ),
      ),
    );
  }
}


class ProblemCard extends StatelessWidget {
  final Map<String, dynamic> problem;
  final Map<String, IconData> iconMap = {
    "AVAILABILITY" : Icons.offline_bolt,
    "ERROR" : Icons.report_problem,
    "PERFORMANCE" : Icons.schedule,
    "RESOURCE" : Icons.trending_down,
    "CUSTOM_ALERT" : Icons.settings,
  };
  

  ProblemCard(this.problem);

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    
    var start = new DateTime.fromMicrosecondsSinceEpoch(problem['startTime']*1000);
    var formatter = new DateFormat('dd MMMM yyyy hh:mm');
    String startStr = formatter.format(start);
    
    var end;
    if(problem['endTime'] != -1) {
      end = new DateTime.fromMicrosecondsSinceEpoch(problem['endTime']*1000);
    }
    else {
      end = new DateTime.now();
    }
    var duration = end.millisecondsSinceEpoch - start.millisecondsSinceEpoch;
    duration = duration/1000/60;
  
    if(problem['status'] == "OPEN") {
      icon = iconMap[problem['severityLevel']];
      color = dtRedColor;
    }
    else {
      icon = iconMap[problem['severityLevel']];
      color = dtChartBackColor;
    }
    final int totalEntities = problem['affectedEntities'].length;
    int apps = 0;
    int services = 0;
    int synthetic = 0;
    for(int i = 0; i < problem['affectedEntities'].length; i++) {
      if(problem['affectedEntities'][i].contains('APPLICATION')) {
        apps+=1;
      } else if(problem['affectedEntities'][i].contains('SERVICE')) {
        services+=1;
      } else if(problem['affectedEntities'][i].contains('SYNTHETIC')) {
        synthetic+=1;
      }
    }
    final int infra = totalEntities - apps - services - synthetic;
    final List<Widget> tags = [];
    
    // prepare tags
    /*
    tags.add(SizedBox(width: 45,height: 1,));
    for(int i = 0; i < problem['tags'].length; i++) {
      tags.add(Text(problem['tags'][i]));
      tags.add(SizedBox(width: 5,height: 1,));
    }
    */

    // crop title
    var title = problem['title'];
    if(title.length > 50) {
      title = title.substring(0, 50) + "...";
    }

    /*
    Important problem related information:
    - Problem title
    - Start and end time (duration)
    - Severity level (AVAILABILITY, ERROR, PERFORMANCE, RESOURCE, CUSTOM_ALERT)
    - Impact level
    - Number of entities affected
    - Tags
     */
    return Container(
      width: double.infinity,
      height: 150,
      padding: EdgeInsets.all(5),
      child: Card(
        //color: dtChartBackColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row( children: <Widget>[
                Icon(
                  icon,
                  color: color,
                  size: 40.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                ),
                SizedBox(width: 5,height: 1,),
                Column(crossAxisAlignment : CrossAxisAlignment.start, children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    "P-" + problem['displayId'] + ": " + problem['severityLevel'],
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],)
                
              ],),
              Row(children: <Widget>[
                SizedBox(width: 45,height: 10,),
                Text("Detected " + startStr + ", " + duration.toInt().toString() + " minutes", style: Theme.of(context).textTheme.bodyText1,),
              ]),
              SizedBox(width: 1,height: 10,),
              Row(children: <Widget>[
                SizedBox(width: 45,height: 1,),
                Text(totalEntities.toString() + " Entities ", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(apps.toString() + " Applications "),
                Text(synthetic.toString() + " Synthetic tests "),
                Text(services.toString() + " Services "),
                Text(infra.toString() + " Infrastructure"),
              ],
              ),
              SizedBox(width: 1,height: 10,),
              Row(children: tags)
              
            ],
          ),
        ),
      ),
    );
  }
}


