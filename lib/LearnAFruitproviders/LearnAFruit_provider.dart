/*
Author      : W.G.M.V.S Wijesundara  IT17035118
description : Creating the About Us Page
reference1:  https://github.com/JulianCurrie/CwC_Flutter
reference2: https://www.youtube.com/watch?v=bjMw89L61FI
reference3: https://github.com/TechieBlossom/sidebar_animation_flutter
reference4: https://apkpure.com/flutter-mobile-restaurantui-kit/com.jideguru.restaurant_ui_kit
 */

import 'package:finalproject/LearnAFruitUtilities/constColourAttributer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

//creating the class to handle the dark mode and white mode provider mode
class LearnAFruitProvider extends ChangeNotifier{
  
  //loading the theme in constructor
  LearnAFruitProvider(){
    checkTheme();
  }

  // reference: https://apkpure.com/flutter-mobile-restaurantui-kit/com.jideguru.restaurant_ui_kit
  //declare theme variable assign its default to light theme
  ThemeData theme = Constants.lightTheme;
  
  //declare unique key
  Key key = UniqueKey();
  
  //declaring the global navigator key to maintain navigation state
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  //setting the key value
  void setKey(value) {
    key = value;
    notifyListeners();
  }

 //setting the navigation value
  void setNavigatorKey(value) {
    navigatorKey = value;
    notifyListeners();
  }

  //setting the theme to dark mode to white mode vise versa
  // reference: https://apkpure.com/flutter-mobile-restaurantui-kit/com.jideguru.restaurant_ui_kit
  void setTheme(value, c) {
    theme = value;
    SharedPreferences.getInstance().then((prefs){
      prefs.setString("theme", c).then((val){
        SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: c == "dark" ? Constants.darkPrimary : Constants.lightPrimary,
          statusBarIconBrightness: c == "dark" ? Brightness.light:Brightness.dark,
        ));
      });
    });
    notifyListeners();
  }

  //return theme state
  ThemeData getTheme(value) {
    return theme;
  }

  //checking previous state of the theme and return
 // reference: https://apkpure.com/flutter-mobile-restaurantui-kit/com.jideguru.restaurant_ui_kit
  Future<ThemeData> checkTheme() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ThemeData t;
    String r = prefs.getString("theme") == null ? "light" : prefs.getString(
        "theme");

    if(r == "light"){
      t = Constants.lightTheme;
      setTheme(Constants.lightTheme, "light");
    }else{
      t = Constants.darkTheme;
      setTheme(Constants.darkTheme, "dark");
    }

    return t;
  }
}