import 'package:AiOpsApp/colors.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class StackedBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final String title;

  StackedBarChart({@required this.seriesList, @required this.title, this.animate});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.all(20),
      child: Card(
        //color: dtChartBackColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
              ),
              Expanded(
                child: charts.BarChart(
                  
                  seriesList, 
                  animate: animate, 
                  barGroupingType: charts.BarGroupingType.stacked,
                  domainAxis: new charts.OrdinalAxisSpec(
                    // Make sure that we draw the domain axis line.
                    showAxisLine: true,
                    // But don't draw anything else.
                    renderSpec: new charts.NoneRenderSpec()),
                  
                  ),
              )
            ],
          ),
        ),
      ),
    );
  }
}