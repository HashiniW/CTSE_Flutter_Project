
/*
Author      : W.G.M.V.S Wijesundara  IT17035118
description : Creating the firebase user object to set all the data to the notify classes
reference1:  https://github.com/JulianCurrie/CwC_Flutter
reference2: https://www.youtube.com/watch?v=bjMw89L61FI
reference3: https://github.com/TechieBlossom/sidebar_animation_flutter
reference4: https://apkpure.com/flutter-mobile-restaurantui-kit/com.jideguru.restaurant_ui_kit
 */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

//creating the authentication  controller class for user object handling
class AuthenticationController with ChangeNotifier {

  //Firebase private user object declaration
  FirebaseUser _user;

  //creation of getter of user details to the user object
  FirebaseUser get user => _user;

  //creating the user details setter object to set the user data
  void setUser(FirebaseUser user) {
    _user = user;
    notifyListeners();
  }
}
