// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, duplicate_ignore

//import 'dart:js';
import 'package:flutter/material.dart';

class GlobalMethod {
  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;
  }

  static void showErrorDialog(
      {required String error, required BuildContext ctx}) {
    showDialog(
        context: ctx,
        builder: (context) {
          // ignore: prefer_const_constructors
          return AlertDialog(
            title: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.logout,
                    color: Colors.grey,
                    size: 35,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Error Occurred',
                  ),
                ),
              ],
            ),
            content: Text(
              '$error',
              style: TextStyle(
                color: Colors.black,
                fontStyle: FontStyle.italic,
                fontSize: 20,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        });
  }
}
