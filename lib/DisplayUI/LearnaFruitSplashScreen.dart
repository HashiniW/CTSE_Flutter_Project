/*
Author      : IT17136402 - W.M.H.B. Warnakulasooriya
description : Creating the main screen to direct to the favorite fruit list
reference 1 : https://apkpure.com/flutter-mobile-restaurant-
ui-kit/com.jideguru.restaurant_ui_kit 
*/

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'UICollectionHandler.dart';

class LearnAFruitSplashScreen extends StatefulWidget {
  @override
  _LearnAFruitSplashScreen createState() => _LearnAFruitSplashScreen();
}

class _LearnAFruitSplashScreen extends State<LearnAFruitSplashScreen> {

//set timer to the splash screen
  startTimeout() {
    return  Timer(Duration(seconds: 10), changeScreen);
  }

  //changing the screen into home page after timer is up
  changeScreen() async{
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context){
          return UICollectionHandler();
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    startTimeout();
  }

  //UI layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        margin: EdgeInsets.only(left: 40.0, right: 40.0, top: 100.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

              //loading the .gif file from assets folder
              Image.asset(
                'assets/learnafruit.gif',
                width: 600.0,
                height: 400.0,
                fit: BoxFit.fitHeight,
              ),
              Padding(
                padding: EdgeInsets.only(top: 40),
              ),
              Expanded(
                flex: 10,
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    LinearProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.only(top: 50),
                    ),
                    Text(
                      "Loading Learn a Fruit...",
                      style: TextStyle(color: Colors.green, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
