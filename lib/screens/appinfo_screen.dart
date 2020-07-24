import 'package:flutter/material.dart';

class AppInfoScreen extends StatelessWidget {
  static const routeName = '/appinfo_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Info'),
      ),
      body: Container(
          child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'MyShop',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
            ),
            SizedBox(height: 10),
            Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.only(left: 50,right: 50),
              child: Text(
                  'Create your own online shop and expand your business by reaching millions of people in one app!'),
            )
          ],
        ),
      )),
    );
  }
}
