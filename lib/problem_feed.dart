import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import 'package:AiOpsApp/count_type.dart';
import 'package:AiOpsApp/colors.dart';

class ProblemFeed {
  final String url;
  final int total;
  final String nextPageKey;
  final int pageSize;
  final List<charts.Series<dynamic, dynamic>> series;
  final List<dynamic> problems;

  ProblemFeed(this.total, this.nextPageKey, this.pageSize, this.series, this.problems, this.url);

  static int getBucketValue(Map<String, dynamic> json, String ident) {
    if(json != null) {
      if(json['aggregations'] != null) {
        for(int x = 0; x < json['aggregations'][0]['buckets'].length; x++) {
          if(json['aggregations'][0]['buckets'][x]['key'] == ident) {
            return json['aggregations'][0]['buckets'][x]['count'];
          }
        }
        return 0;
      }
      else {
        return 0;
      }
    }
    else {
      return 0;
    }
  }

  factory ProblemFeed.fromJson(Map<String, dynamic> json, String url) {
    final List<CountType> active = [];
    final List<CountType> closed = [];
    
    for(int i = 0; i < json['aggregations']['aggregations'][0]['buckets'].length; i++) {
      Map<String, dynamic> aggr = json['aggregations']['aggregations'][0]['buckets'][i]['aggregations'];
      String k = json['aggregations']['aggregations'][0]['buckets'][i]['key'];
      closed.add(new CountType(k, getBucketValue(aggr, 'CLOSED'), charts.ColorUtil.fromDartColor(Colors.grey)));
      active.add(new CountType(k, getBucketValue(aggr, 'OPEN'), charts.ColorUtil.fromDartColor(dtRedColor)));
    }

    final s = [
      new charts.Series<CountType, String>(
        id: 'Active',
        domainFn: (CountType c, _) => c.date,
        measureFn: (CountType c, _) => c.count,
        colorFn: (CountType c, _) => c.barColor,
        data: active,
      ),
      new charts.Series<CountType, String>(
        id: 'Resolved',
        domainFn: (CountType c, _) => c.date,
        measureFn: (CountType c, _) => c.count,
        colorFn: (CountType c, _) => c.barColor,
        data: closed,
      )
    ];

    return ProblemFeed(
      json['totalCount'],
      json['nextPageKey'],
      json['pageSize'],
      s,
      json['problems'],
      url
    );
  }
}