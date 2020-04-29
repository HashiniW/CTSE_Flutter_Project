import 'package:finalproject/LearnAFruitproviders/LearnAFruit_provider.dart';
import 'package:finalproject/DisplayUI/LoginPageDisplay.dart';
import 'package:finalproject/DisplayUI/LearnAFruitSplashScreen.dart';
import 'package:finalproject/LearnAFruitUtilities/constColourAttributer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'CrudControllers/authentication_Controller.dart';
import 'CrudControllers/Fruit_Controller.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LearnAFruitProvider()),
        ChangeNotifierProvider(
          builder: (context) => AuthenticationController(),
        ),
        ChangeNotifierProvider(
          builder: (context) => FruitController(),
        ),
      ],
      child: LearnAFruitApp(),
    ),
  );
}

class LearnAFruitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LearnAFruitProvider>(
      builder: (BuildContext context, LearnAFruitProvider appProvider, Widget child) {
        return MaterialApp(
          key: appProvider.key,
          debugShowCheckedModeBanner: false,
          navigatorKey: appProvider.navigatorKey,
          title: Constants.appName,
          theme: appProvider.theme,
          home://SplashScreen(),
          Consumer<AuthenticationController>(
           builder: (context, notifier, child) {
            return notifier.user != null ? LearnAFruitSplashScreen() : LoginPageDisplayUI();
            },
         ),
        );
      },
    );
  }
}