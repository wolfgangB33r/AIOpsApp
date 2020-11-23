import 'package:flutter/material.dart';
import 'dart:async';

import 'package:AiOpsApp/model/environment_args.dart';



Future<EnvironmentScreenArguments> asyncAddEnvironmentDialog(BuildContext context) async {
  String title;
  String envUrl;
  String envSecret;
  String filter;

  return showDialog<EnvironmentScreenArguments>(
    context: context,
    barrierDismissible: true, // dialog is dismissible with a tap on the barrier
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Add a new environment'),
        content: new Row(
          children: <Widget>[
            new Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      autofocus: true,
                      decoration: new InputDecoration(
                          labelText: 'Environment Name', hintText: 'eg. Production'),
                      onChanged: (value) {
                        title = value;
                      },
                    ),
                    TextField(
                      decoration: new InputDecoration(labelText: 'Environment URL', hintText: 'eg. sample.live.dynatrace.com'),
                      onChanged: (value) {
                        envUrl = value;
                      },
                    ),
                    TextField(
                      decoration: new InputDecoration(labelText: 'Api Token', hintText: 'eg. sampletoken'),
                      onChanged: (value) {
                        envSecret = value;
                      },
                    ),
                    TextField(
                      decoration: new InputDecoration(labelText: 'Filter (optional)', hintText: 'eg. mz(TeamBoston),tag(PROD)'),
                      onChanged: (value) {
                        filter = value;
                      },
                    )
                  ]
                )
            )
            ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop(EnvironmentScreenArguments(title, envUrl, envSecret, filter));
            },
          ),
        ],
      );
    },
  );
}
