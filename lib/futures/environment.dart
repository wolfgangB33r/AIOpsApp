import 'package:AiOpsApp/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:AiOpsApp/model/environment_args.dart';
import 'package:AiOpsApp/problem_feed.dart';
import 'package:AiOpsApp/event_feed.dart';



/* 
  Builds a text widget, filled with the number of open problems within the given environment. 
 */
Future<Text> fetchOpenProblemsCount(EnvironmentScreenArguments env) async {
  final response = await http.get(env.environmentUrl + '/api/v2/problems?from=-1d&problemSelector=status(OPEN)&Api-Token=' + env.environmentSecret);
  if (response.statusCode == 200) {
    var j = json.decode(response.body);
    Color c;
    if(j['totalCount'] > 0) {
      c = dtRedColor;
    }
    else {
      c = Colors.white;
    }
    return Text(j['totalCount'].toString(), style: TextStyle(color: c, fontSize: 20));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load event feed');
  }
}

Future<ProblemFeed> fetchProblemFeed(String url, String token) async {
  final response = await http.get(url + '/api/v2/problems?from=-1d&aggregation=groupByTime%28field%28timespan%29%2C%20groupByField%28field%28status%29%29%29&Api-Token=' + token);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return ProblemFeed.fromJson(json.decode(response.body), url);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load problem feed');
  }
}

Future<EventFeed> fetchEventFeed(String url, String token) async {
  final response = await http.get(url + '/api/v2/events?from=-1d&aggregation=groupByTime%28field%28timespan%29%2C%20groupByField%28field%28eventType%29%29%29&Api-Token=' + token);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return EventFeed.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load event feed');
  }
}