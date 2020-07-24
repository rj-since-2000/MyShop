import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer timer;

  var loadValue = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    autoTime();
  }

  void autoTime() {
    if (timer != null) {
      timer.cancel();
    }
    timer = Timer(Duration(milliseconds: 300), trigger);
  }

  void trigger() {
    autoTime();
    setState(() {});
    if (loadValue == 4)
      loadValue = 1;
    else
      loadValue++;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            AnimatedContainer(
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
              //color: Colors.yellow,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeIn,
              height: loadValue == 1 ? 24 : 10,
              width: loadValue == 1 ? 24 : 10,
              constraints: BoxConstraints(
                  maxHeight: 24, minHeight: 10, maxWidth: 24, minWidth: 10),
            ),
            SizedBox(
              width: 30,
            ),
            AnimatedContainer(
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
              //color: Colors.yellow,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeIn,
              height: loadValue == 2 ? 24 : 10,
              width: loadValue == 2 ? 24 : 10,
              constraints: BoxConstraints(
                  maxHeight: 24, minHeight: 10, maxWidth: 24, minWidth: 10),
            ),
            SizedBox(
              width: 30,
            ),
            AnimatedContainer(
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
              //color: Colors.yellow,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeIn,
              height: loadValue == 3 ? 24 : 10,
              width: loadValue == 3 ? 24 : 10,
              constraints: BoxConstraints(
                  maxHeight: 24, minHeight: 10, maxWidth: 24, minWidth: 10),
            ),
            SizedBox(
              width: 30,
            ),
            AnimatedContainer(
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
              //color: Colors.yellow,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeIn,
              height: loadValue == 4 ? 24 : 10,
              width: loadValue == 4 ? 24 : 10,
              constraints: BoxConstraints(
                  maxHeight: 24, minHeight: 10, maxWidth: 24, minWidth: 10),
            ),
          ],
        ),
      ),
    );
  }
}
