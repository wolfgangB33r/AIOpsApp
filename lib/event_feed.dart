import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import 'package:AiOpsApp/count_type.dart';

class EventFeed {
  final int total;
  final String nextPageKey;
  final int pageSize;
  final List<charts.Series<dynamic, dynamic>> series;

  EventFeed(this.total, this.nextPageKey, this.pageSize, this.series);

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

  factory EventFeed.fromJson(Map<String, dynamic> json) {
    final List<CountType> total = [];
    
    for(int i = 0; i < json['aggregations']['aggregations'][0]['buckets'].length; i++) {
      Map<String, dynamic> aggr = json['aggregations']['aggregations'][0]['buckets'][i]['aggregations'];
      String k = json['aggregations']['aggregations'][0]['buckets'][i]['key'];
      total.add(new CountType(k, json['aggregations']['aggregations'][0]['buckets'][i]['count'], charts.ColorUtil.fromDartColor(Colors.grey)));
    }

    final s = [
      new charts.Series<CountType, String>(
        id: 'Total',
        domainFn: (CountType c, _) => c.date,
        measureFn: (CountType c, _) => c.count,
        colorFn: (CountType c, _) => c.barColor,
        data: total,
      ),
    ];

    return EventFeed(
      json['totalCount'],
      json['nextPageKey'],
      json['pageSize'],
      s
    );
  }
}