import 'package:charts_flutter/flutter.dart' as charts;

class CountType {
  final String date;
  final int count;
  final charts.Color barColor;

  CountType(this.date, this.count, this.barColor);
}
